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
  mutate(No__of_Casualties_Injured = as.factor(No__of_Casualties_Injured)) %>%
  mutate(No__of_Casualties_Injured = fct_lump(No__of_Casualties_Injured, 10)) %>%
  count(No__of_Casualties_Injured) %>%
  mutate(percent = n/sum(n)) %>%
  ggplot(aes(x = No__of_Casualties_Injured, y = percent)) +
  geom_col() # Majority of accidents involved 1 casualty injured
