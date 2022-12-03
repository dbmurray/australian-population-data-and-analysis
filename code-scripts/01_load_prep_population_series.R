# This script downloads Australian Demographic Statistics in R and prepares them
# for further downstream anaylsis. 

# LIBRARIES

library(readabs)
library(dplyr)

# IMPORT DATA

# import the data and seperate out the series
australian_demographic_statistics <- read_abs("3101.0") %>%
  separate_series() 


# TIDY DATA
australian_migration_data <- australian_demographic_statistics %>%
  filter(ifelse(series_3 =="Australia",
                series_2 == c("Net Overseas Migration", "Overseas Arrivals", "Overseas Departures"), 
                series_2 == c("Interstate Arrivals", "Interstate Departures", "Net Interstate Migration", "Net Overseas Migration"))) %>%
  rename(location=series_3,metric = series_2, metric_value=value) %>%
  mutate(migration_category_series = if_else(metric == "Net Overseas Migration", "Overseas Migration","Interstate Migration")) %>%
  select(migration_category_series, date, location, metric, metric_value)



# OUTPUT
write.csv(australian_migration_data, "output/tables/australia_migration_data.csv", row.names = FALSE)
