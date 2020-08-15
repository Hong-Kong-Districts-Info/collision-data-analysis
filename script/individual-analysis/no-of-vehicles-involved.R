## This script is the "parent" script for analysis and visualisations.
## Use `source()` to run the "child" scripts.

# Load packages -----------------------------------------------------------
library(tidyverse)
library(here)
library(readxl)


# Load data ---------------------------------------------------------------
source(here("script", "read in data.R"))


# Analysis starts here ----------------------------------------------------
plot_output <- df_accident %>%  
  mutate(No__of_Vehicles_Involved = as.factor(No__of_Vehicles_Involved)) %>%
  mutate(No__of_Vehicles_Involved = fct_lump(No__of_Vehicles_Involved, 10)) %>%
  count(No__of_Vehicles_Involved) %>%
  mutate(percent = n/sum(n)) %>%
  ggplot(aes(x = No__of_Vehicles_Involved, y = percent)) +
  geom_col() # Majority of accidents involved 1 casualty injured

ggsave("output/no-of-vehicles-involved.png",
       width = 12,
       height = 9,
       plot = plot_output)
