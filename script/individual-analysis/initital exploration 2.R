## This script is the "parent" script for analysis and visualisations.
## Use `source()` to run the "child" scripts.

# Load packages -----------------------------------------------------------
library(tidyverse)
library(here)
library(readxl)
library(dlookr) # Using dlookr for EDA - https://cran.r-project.org/web/packages/dlookr/vignettes/EDA.html


# Load data ---------------------------------------------------------------
source(here("script", "read in data.R"))


# Analysis starts here ----------------------------------------------------
## Continuous data
df_accident_summary <- describe(df_accident,
         No__of_Vehicles_Involved, No__of_Casualties_Injured)

distribution <- plot_normality(df_accident,
               No__of_Vehicles_Involved, No__of_Casualties_Injured)

## Categorical data
df_accident %>%
  count(Vehicle_Movements) %>%
  mutate(percent = round((n / sum(n)), 2)) %>%
  mutate(Vehicle_Movements = case_when(
    Vehicle_Movements == "1" ~ "One moving vehicle",
    Vehicle_Movements == "2" ~ "Two moving vehicles - from same direction",
    Vehicle_Movements == "3" ~ "Two moving vehicles - from opposite direction",
    Vehicle_Movements == "4" ~ "Two moving vehicles - from different roads",
    Vehicle_Movements == "5" ~ "> 2 moving vehicles - from same direction",
    Vehicle_Movements == "6" ~ "> 2 moving vehicles - from opposite direction",
    Vehicle_Movements == "7" ~ ">2 moving vehicles - from different roads"
  )) %>%
  ggplot(aes(x = fct_reorder(Vehicle_Movements, percent), y = percent, label = percent)) +
  geom_col() +
  coord_flip() +
  geom_text(size = 5, hjust = 1) +
  ggsave("output/vehicle-movements-count.png",
         width = 12,
         height = 9)

df_accident %>%
  count(Junction_Control) %>%
  mutate(percent = round((n / sum(n)), 2)) %>%
  mutate(Junction_Control = case_when(
      Junction_Control == "1" ~ "No control",
      Junction_Control == "2" ~ "Stop (halt)",
      Junction_Control == "3" ~ "Give way (slow)",
      Junction_Control == "4" ~ "Traffic signal",
      Junction_Control == "5" ~ "Police",
      Junction_Control == "6" ~ "Not junction"
  )) %>%
  ggplot(aes(x = fct_reorder(Junction_Control, percent), y = percent, label = percent)) +
  geom_col() +
  coord_flip() +
  geom_text(size = 5, hjust = 1) +
  ggsave("output/junction-control-count.png",
         width = 12,
         height = 9)

df_vehicle %>%
  count(Vehicle_Class) %>%
  mutate(percent = round((n / sum(n)), 2)) %>%
  mutate(Vehicle_Class = case_when(
    Vehicle_Class == 1 ~ "Motorcycle",
    Vehicle_Class == 2 ~ "Private car",
    Vehicle_Class == 3 ~ "Public light bus",
    Vehicle_Class == 4 ~ "Light goods vehicle",
    Vehicle_Class == 5 ~ "Medium goods vehicle",
    Vehicle_Class == 6 ~ "Heavy goods vehicle",
    Vehicle_Class == 7 ~ "Public franchised bus",
    Vehicle_Class == 8 ~ "Public non-franchised bus",
    Vehicle_Class == 9 ~ "Taxi",
    Vehicle_Class == 10 ~ "Bicycle",
    Vehicle_Class == 11 ~ "Tram",
    Vehicle_Class == 12 ~ "Light rail vehicle",
    Vehicle_Class == 13 ~ "Others/ Unknown"
  )) %>%
  ggplot(aes(x = fct_reorder(Vehicle_Class, percent), y = percent, label = percent)) +
  geom_col() +
  coord_flip() +
  geom_text(size = 5, hjust = 1) +
  ggsave("output/vehicle-class-count.png",
         width = 12,
         height = 9)

df_casualty %>%
  count(Pedestrian_Action) %>%
  mutate(percent = round((n / sum(n)), 2)) %>%
  mutate(Pedestrian_Action = case_when(
    Pedestrian_Action == 1 ~ "Walking - back to traffic",
    Pedestrian_Action == 2 ~ "Walking - facing traffic",
    Pedestrian_Action == 3 ~ "Standing",
    Pedestrian_Action == 4 ~ "Boarding vehicle",
    Pedestrian_Action == 5 ~ "Alighting from vehicle",
    Pedestrian_Action == 6 ~ "Falling or jumping from vehicle",
    Pedestrian_Action == 7 ~ "Working at a vehicle",
    Pedestrian_Action == 8 ~ "Other working",
    Pedestrian_Action == 9 ~ "Playing",
    Pedestrian_Action == 10 ~ "Crossing from near-side",
    Pedestrian_Action == 11 ~ "Crossing from off-side",
    Pedestrian_Action == 12 ~ "Not known",
    Pedestrian_Action == 13 ~ "Not Applicable (i.e. non-pedestrian)"
  )) %>%
  ggplot(aes(x = fct_reorder(Pedestrian_Action, percent), y = percent, label = percent)) +
  geom_col() +
  coord_flip() +
  geom_text(size = 5, hjust = 1) +
  ggsave("output/pedestrian-action-count.png",
         width = 12,
         height = 9)
