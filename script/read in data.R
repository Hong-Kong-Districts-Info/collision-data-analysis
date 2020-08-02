## All the data loading and cleaning happens here
# Load in data ------------------------------------------------------------

df_accident <- read_xlsx(here("data", "Accident 2014-2019.xlsx"))
df_casualty <- read_xlsx(here("data", "Casualty 2014-2019.xlsx"))
df_vehicle <- read_xlsx(here("data", "Vehicle 2014-2019.xlsx"))
