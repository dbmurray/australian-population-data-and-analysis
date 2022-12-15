# This script prepares charts for analysing migration trends

# LIBRARIES
library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)
library(scales)

# data import
australia_migration_data <- read_csv("output/tables/australia_migration_data.csv")

# data prep

# this dataframe is to chart arraivls and depatures using a diverging bar chart
interstate_migration <- australia_migration_data %>%
  filter(migration_category_series != "Overseas") %>%
  mutate(metric_value = if_else(metric == "Interstate Departures", -metric_value,metric_value)) %>%
  mutate(state_factor = factor(location, levels = c("New South Wales",
                                                    "Victoria",
                                                    "Queensland",
                                                    "Western Australia",
                                                    "South Australia",
                                                    "Tasmania",
                                                    "Australian Capital Territory",
                                                    "Northern Territory")))



  
# charts
theme_set(theme_minimal())

# set up a colour table
colour_table <- tibble(
  metric = c("Interstate Arrivals", "Interstate Departures", "Net Interstate Migration"),
  colour = c("#36B5BE", "#FE5F55", "#333333")
)

# plot interstate migration over time. 

# all dates

ggplot(interstate_migration, aes(x=date, y=metric_value, fill = metric)) + 
  geom_col(data = subset(interstate_migration, metric != "Net Interstate Migration")) +
  geom_line(data = subset(interstate_migration, metric == "Net Interstate Migration")) +
  scale_fill_manual(values = colour_table$colour) +
  facet_wrap(.~state_factor, nrow = 2) + # wrap the facet using our factorised state ordering.  
  labs(
    title = 'Interstate Migration',
    x = 'Year',
    y = '# of Migrants',
    fill = element_blank()
    ) +
  scale_y_continuous(labels = label_number(suffix = "K", scale = 1e-3)) + # thousands +
  scale_x_date(date_labels = "%Y")

# last five years

ggplot(interstate_migration, aes(x=date, y=metric_value, fill = metric)) + 
  geom_col(data = subset(interstate_migration, metric != "Net Interstate Migration")) +
  geom_line(data = subset(interstate_migration, metric == "Net Interstate Migration")) +
  scale_fill_manual(values = colour_table$colour) +
  facet_wrap(.~state_factor, nrow = 2) + # wrap the facet using our factorised state ordering.  
  labs(
    title = 'Interstate Migration',
    x = 'Year',
    y = '# of Migrants',
    fill = element_blank()
  ) +
  scale_y_continuous(labels = label_number(suffix = "K", scale = 1e-3)) + # thousands +
  scale_x_date(date_labels = "%Y",
               limits = as.Date(c('2017-06-30','2022-06-30')))
