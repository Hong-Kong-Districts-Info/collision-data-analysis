## Testing script for leaflet
library(leaflet)
library(tidyverse)
library(here)
library(readxl)
library(maps)

options(viewer = NULL) # Show maps directly in browser

# Load data ---------------------------------------------------------------
source(here("script", "read in data.R"))


# Run leaflet -------------------------------------------------------------
df_accident %>% glimpse()

# Main leaflet example
m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
m  # Print the map

# map tests
mapStates <- maps::map("state", fill = TRUE, plot = FALSE)

leaflet(data = mapStates)

leaflet(data = mapStates) %>%
  addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)

# example 2
m = leaflet() %>% addTiles()
df = data.frame(
  lat = rnorm(100),
  lng = rnorm(100),
  size = runif(100, 5, 20),
  color = sample(colors(), 100)
)
m = leaflet(df) %>%
  addProviderTiles(providers$Stamen.Toner)
  # addTiles()
m %>% addCircleMarkers(radius = ~size, color = ~color, fill = FALSE)
m %>% addCircleMarkers(radius = runif(100, 4, 10), color = c('red'))

htmlwidgets::saveWidget(m, file="map.html")
