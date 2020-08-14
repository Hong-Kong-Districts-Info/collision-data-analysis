## This script is the "parent" script for analysis and visualisations.
## Use `source()` to run the "child" scripts.

# Load packages -----------------------------------------------------------
library(tidyverse)
library(here)
library(readxl)
library(HK80) # https://cran.r-project.org/web/packages/HK80/HK80.pdf
library(leaflet)

# Load data ---------------------------------------------------------------
source(here("script", "read in data.R"))

# Convert grids -----------------------------------------------------------
df_accident$Grid_N <- as.numeric(df_accident$Grid_N)
df_accident$Grid_E <- as.numeric(df_accident$Grid_E)

## Generate lat/long
latlong <- HK1980GRID_TO_WGS84GEO(df_accident$Grid_N, df_accident$Grid_E)

## cbind
df_accident_new <- cbind(df_accident, latlong)


# leaflet -----------------------------------------------------------------
df_accident_new %>%
  drop_na(latitude, longitude) %>%
  filter(Year == 2019) %>%
  slice(1:100) %>%
  mutate(Info = paste("Severity:", Severity, "\n",
                      "District:", District_Council_District, "\n",
                      "Vehicles involved:", No__of_Vehicles_Involved)) %>%
  leaflet() %>%
  # addTiles() %>%
  addProviderTiles(providers$Stamen.Toner) %>%
  addCircleMarkers(lng = ~longitude,
                   lat = ~latitude,
                   popup = ~as.character(Info),
                   label = ~as.character(Info))
  # addMarkers(lng = ~longitude,
  #            lat = ~latitude,
  #            popup = ~as.character(Info),
  #            label = ~as.character(Info))
