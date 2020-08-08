## This script is the "parent" script for analysis and visualisations.
## Use `source()` to run the "child" scripts.

# Load packages -----------------------------------------------------------
library(tidyverse)
library(here)
library(readxl)


# Load data ---------------------------------------------------------------
source(here("script", "read in data.R"))


# Analysis starts here ----------------------------------------------------
df_accident %>%
  mutate(Vehicles_N = case_when(No__of_Vehicles_Involved == 1 ~ "1",
                                between(No__of_Vehicles_Involved, 2, 3) ~ "2 - 3",
                                No__of_Vehicles_Involved > 3 ~ "3+")) %>%
  count(District_Council_District, VehiclesN) %>%
  summarise(Vehicles_N = mean(Vehicles_N, na.rm = TRUE))

df_accident %>% glimpse()

