# This script downloads Australian Demographic Statistics in R and prepares them
# for further downstream anaylsis of migration statistics. 

# LIBRARIES
library(readabs)
library(dplyr)

# IMPORT DATA

# import the data and separate out the series
australian_demographic_statistics <- read_abs("3101.0") %>%
  separate_series() %>%
  mutate(date = as.Date(date))


# TIDY DATA

# filter for the appropriate data series based on location (national, states) and select the appropriate metrics.

australian_migration_data <- australian_demographic_statistics %>%
  rename(location=series_3,metric = series_2, metric_value=value) %>% # better variable names.
  filter(metric == "Interstate Arrivals" | metric == "Interstate Departures" | metric == "Net Interstate Migration",
         location != "Australia") %>% # filter for required variables
  mutate(migration_category_series = if_else(metric == "Net Overseas Migration", 
                                             "Overseas","Interstate"),) %>% 
  select(migration_category_series, date, location, metric, metric_value) # select needed fields only

# OUTPUT

write.csv(australian_migration_data, "output/tables/australia_migration_data.csv", row.names = FALSE)
