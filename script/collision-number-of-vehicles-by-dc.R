## This script is the "parent" script for analysis and visualisations.
## Use `source()` to run the "child" scripts.

# Load packages -----------------------------------------------------------
library(tidyverse)
library(here)
library(readxl)


# Load data ---------------------------------------------------------------
source(here("script", "read in data.R"))


# Analysis starts here ----------------------------------------------------
plot_data <-
  df_accident %>%
  mutate(Vehicles_N = case_when(No__of_Vehicles_Involved == 1 ~ "1",
                                between(No__of_Vehicles_Involved, 2, 3) ~ "2 - 3",
                                No__of_Vehicles_Involved > 3 ~ "3+")) %>%
  count(District_Council_District, Vehicles_N)

dc_data_fct <-
  plot_data %>%
  group_by(District_Council_District) %>%
  summarise(n = sum(n)) %>%
  arrange(n) %>%
  mutate(District_Council_District = factor(District_Council_District, 
                                            levels = .$District_Council_District)) %>%
  
  pull(District_Council_District)

plot_output <-
  plot_data %>%
  mutate(District_Council_District = factor(District_Council_District,
                                            levels = dc_data_fct)) %>%
  ggplot(aes(x = District_Council_District,
             y = n,
             fill = Vehicles_N)) +
  geom_col() +
  labs(title = "Number of collisions by \nnumber of vehicles involved",
       subtitle = "By District Council",
       fill = "Number of vehicles involved",
       x = "District Council Districts",
       y = "Number of collisions") +
  ggthemes::theme_solarized_2() +
  theme(legend.position = "bottom")

ggsave("output/number-of-vehicles-by-dc.svg",
       width = 12,
       height = 9,
       plot = plot_output)


