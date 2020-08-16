## This script is the "parent" script for analysis and visualisations.
## Use `source()` to run the "child" scripts.

# Load packages -----------------------------------------------------------
library(tidyverse)
library(here)
library(readxl)
library(HK80) # https://cran.r-project.org/web/packages/HK80/HK80.pdf
library(leaflet)
library(shiny)
library(shinythemes)
library(shinyWidgets)

# Load data ---------------------------------------------------------------
source(here("script", "read in data.R"))

# Convert grids -----------------------------------------------------------
df_accident$Grid_N <- as.numeric(df_accident$Grid_N)
df_accident$Grid_E <- as.numeric(df_accident$Grid_E)

## Generate lat/long
latlong <- HK1980GRID_TO_WGS84GEO(df_accident$Grid_N, df_accident$Grid_E)

## cbind
df_accident_new <- cbind(df_accident, latlong)

## Identify locations with repeated accidents
df_accident_new %>%
  filter(!is.na(latitude), !is.na(longitude)) %>%
  count(latitude, longitude) %>%
  filter(n > 1) # 2376 locations identified

## Identify locations with repeated accidents on the same day
df_accident_new %>%
  filter(!is.na(latitude), !is.na(longitude)) %>%
  count(latitude, longitude, Date) %>%
  filter(n > 1) %>% # 171 locations identified
  arrange(desc(n)) # 3 accidents reported at 22.34468, 114.1507 on 2019-11-15

# Tidy data ---------------------------------------------------------------
df_accident_new <- df_accident_new %>%
  mutate(Severity = case_when( # Severity: Translate code into description
  Severity == 1 ~ "Fatal",
  Severity == 2 ~ "Serious",
  TRUE ~ "Slight"
)) %>%
  mutate(District_Council_District_Full = case_when( # District: Translate code into description
    District_Council_District == "CW" ~ "Central and Western",
    District_Council_District == "E" ~ "Eastern",
    District_Council_District == "I" ~ "Islands",
    District_Council_District == "KC" ~ "Kowloon City",
    District_Council_District == "KT" ~ "Kwun Tong",
    District_Council_District == "KTS" ~ "Kwai Tsing",
    District_Council_District == "N" ~ "North",
    District_Council_District == "S" ~ "Southern",
    District_Council_District == "SK" ~ "Sai Kung",
    District_Council_District == "SSP" ~ "Sham Shui Po",
    District_Council_District == "ST" ~ "Sha Tin",
    District_Council_District == "TM" ~ "Tuen Mun",
    District_Council_District == "TP" ~ "Tai Po",
    District_Council_District == "TW" ~ "Tsuen Wan",
    District_Council_District == "WCH" ~ "Wan Chai",
    District_Council_District == "WTS" ~ "Wong Tai Sin",
    District_Council_District == "YL" ~ "Yuen Long",
    District_Council_District == "YTM" ~ "Yau Tsim Mong"
  )) %>%
  mutate(Junction_Control = case_when( # Junction: Translate code into description
    Junction_Control == "1" ~ "No control",
    Junction_Control == "2" ~ "Stop (halt)",
    Junction_Control == "3" ~ "Give way (slow)",
    Junction_Control == "4" ~ "Traffic signal",
    Junction_Control == "5" ~ "Police",
    TRUE ~ "Not junction"
  )) %>%
  mutate(Type_of_Collision = case_when( # Type of Collision: Translate code into description
    Type_of_Collision == "1" ~ "Vehicle collision with Pedestrian",
    Type_of_Collision == "2" ~ "Vehicle collision with Vehicle",
    Type_of_Collision == "3" ~ "Vehicle collision with Object",
    TRUE ~ "Vehicle collision with Nothing"
  )) %>%
  mutate(Time = paste0(str_sub(Time, 1, 2), ":", str_sub(Time, 3,4))) # Add colon to time

# str(df_accident_new)
# sum(is.na(df_accident_new$Time))

# Create summary info -----------------------------------------------------
df_accident_new <- df_accident_new %>%
  mutate(Summary = paste(Date, Time, "<br/>",
                         District_Council_District_Full, "District", "<br/>",
                         "<br/>",
                         "Severity:", Severity, "<br/>",
                         "Casualties:", No__of_Casualties_Injured, "<br/>",
                         "Vehicles Involved:", No__of_Vehicles_Involved, "<br/>",
                         "Collision Type:", Type_of_Collision))

# Shiny -------------------------------------------------------------------
ui <- bootstrapPage(
  theme = shinythemes::shinytheme('simplex'),
  leaflet::leafletOutput('map', width = '100%', height = '100%'),
  absolutePanel(top = 10, right = 10, id = 'controls',
                selectInput("district", "Select District",
                            choices = unique(df_accident_new$District_Council_District),
                            multiple = TRUE),
                sliderInput('nb_casualties', 'Minimum Casualties', 1, 77, 1),
                dateRangeInput('date_range', 'Select Date', "2014-01-01", "2019-12-31")
  ),
  tags$style(type = "text/css", "
    html, body {width:100%;height:100%}     
    #controls{background-color:white;padding:20px;}
  ")
)

server <- function(input, output, session) {
  output$map <- leaflet::renderLeaflet({
    df_accident_new %>% 
      filter(
        District_Council_District %in% input$district,
        Date >= input$date_range[1],
        Date <= input$date_range[2],
        No__of_Casualties_Injured >= input$nb_casualties
      ) %>% 
      leaflet() %>% 
      setView( 114.1303, 22.3669, zoom = 11) %>% 
      addTiles() %>% 
      addMarkers(
        popup = ~ Summary,
        clusterOptions = markerClusterOptions()
      ) %>%
      addProviderTiles(providers$CartoDB.Positron)
  })
}

shinyApp(ui, server)
