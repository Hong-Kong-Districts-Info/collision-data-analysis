## This is a short script to demonstrate how to use shapefiles with leaflet to create
## an interactive map. Comments are intentionally verbose for educational purposes.
## Note: see hong-kong-districts-info site repo (MDR) for original implementation

# Load packages -----------------------------------------------------------

library(leaflet)
library(tidyverse)
library(sf) # Parse shapefiles
library(hkdatasets) # Data of Constituency Codes available


# Load in shapefiles ------------------------------------------------------

path_shape_district <- here::here("data", "dcca_2019", "DCCA_2019.shp")

## shapefiles - read and transform
shape_district <- st_read(dsn = path_shape_district)
shape_district <- st_transform(x = shape_district, crs = 4326)

shape_district$centroids <- shape_district %>% 
  st_centroid() %>% 
  st_coordinates()


# Join shapefiles with ConstituencyCode -----------------------------------

match_sf <-
  hkdc %>%
  select(ConstituencyCode) %>%
  # remove hyphen for joining to shape file
  mutate(ConstituencyCode = gsub(x = ConstituencyCode, pattern = "-", replacement = "")) %>%
  left_join(y = shape_district, by = c("ConstituencyCode" = "CACODE"))

## Set an arbitrary view

arbitrary_view <-
  match_sf %>%
  filter(ConstituencyCode == "E17")

## Create map with shapefiles
map_hk_districts <-
  leaflet(data = st_as_sf(match_sf)) %>% 
  addTiles() %>% 
  # addProviderTiles(providers$Stamen.Toner) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(weight = 0.5, 
              fillOpacity = 0.1, 
              color = '#009E73',
              highlightOptions = highlightOptions(color = '#000000', 
                                                  weight = 5,
                                                  bringToFront = TRUE),
              popup = match_sf$ConstituencyCode,
              options = popupOptions(clickable = TRUE,
                                     closeOnClick = TRUE)) %>%
  setView(lng = arbitrary_view$centroids[,"X"],
          lat = arbitrary_view$centroids[,"Y"],
          zoom = 13)

## Save leaflet file
htmlwidgets::saveWidget(map_hk_districts, "MapHKDistricts.html")
