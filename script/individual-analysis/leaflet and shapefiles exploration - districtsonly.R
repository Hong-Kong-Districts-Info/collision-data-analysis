## This is a short script to demonstrate how to use shapefiles with leaflet to create
## an interactive map. Comments are intentionally verbose for educational purposes.
## Note: see hong-kong-districts-info site repo (MDR) for original implementation

## Shape files are at Hong Kong District level (not Constituency)
# https://opendata.esrichina.hk/datasets/eea8ff2f12b145f7b33c4eef4f045513_0

# Load packages -----------------------------------------------------------

library(leaflet)
library(tidyverse)
library(sf) # Parse shapefiles
library(hkdatasets) # Data of Constituency Codes available


# Load in shapefiles ------------------------------------------------------

path_shape_district <- here::here("data", "Hong_Kong_18_Districts-shp", "HKDistrict18.shp")

## shapefiles - read and transform
shape_district <- st_read(dsn = path_shape_district)
shape_district <- st_transform(x = shape_district, crs = 4326)

shape_district$centroids <- shape_district %>% 
  st_centroid() %>% 
  st_coordinates()


## Create map with shapefiles

leaflet(data = st_as_sf(shape_district)) %>% 
  addTiles() %>% 
  # addProviderTiles(providers$Stamen.Toner) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(weight = 0.5, 
              fillOpacity = 0.1, 
              color = '#009E73',
              highlightOptions = highlightOptions(color = '#000000', 
                                                  weight = 5,
                                                  bringToFront = TRUE),
              popup = shape_district$CNAME,
              options = popupOptions(clickable = TRUE,
                                     closeOnClick = TRUE))
