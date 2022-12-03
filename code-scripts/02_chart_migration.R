# This script prepares charts for analysing migration trends

# LIBRARIES
library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)

2# data import
australia_migration_data <- read_csv("output/tables/australia_migration_data.csv")


# data prep

# this dataframe is to chart arraivls and depatures using a diverging bar chart
interstate_migration <- australia_migration_data %>%
  filter(migration_category_series != "Overseas") %>%
  mutate(metric_value = if_else(metric == "Interstate Departures", -metric_value,metric_value)) 

#36B5BE #positive colour
# F8E9E9 background
#FE5F55 negative - #AD0C01

# charts

# set up a colour table
colour_table <- tibble(
  metric = c("Interstate Arrivals", "Interstate Departures", "Net Interstate Migration"),
  colour = c("#36B5BE", "#FE5F55", "#333333")
)

# plot interstate migration over time. 
ggplot(interstate_migration, aes(x=date, y=metric_value, fill = metric)) + 
  geom_col(data = subset(interstate_migration, metric != "Net Interstate Migration")) +
  geom_line(data = subset(interstate_migration, metric == "Net Interstate Migration")) +
  scale_fill_manual(values = colour_table$colour) +
  facet_wrap(.~location, nrow = 2) +
  theme_minimal()

