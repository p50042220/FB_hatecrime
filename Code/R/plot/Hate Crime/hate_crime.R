library(tidyverse)
library(dplyr)
library(data.table)
library(bit64)
library(ggplot2)
library(fiftystater)
library(maps)
library(mapdata)
library(devtools)
library(easyGgplot2)

setwd("/home3/r05322021/Desktop/FB Data/hate_crime_data/")
data1 <- fread("2015.csv")
data1$date = as.character(data1$date)
data1 <- data1 %>%
  mutate(date = paste(substr(date, 1, 4), "-", substr(date, 5, 6), "-", substr(date, 7, 8), sep = ""),
         week = as.numeric(as.Date(date) - as.Date("2015-01-04")) %/%7 + 1 )
data2 <- fread("2016.csv")
data2$date = as.character(data2$date)
data2 <- data2 %>%
  mutate(date = paste(substr(date, 1, 4), "-", substr(date, 5, 6), "-", substr(date, 7, 8), sep = ""),
         week = as.numeric(as.Date(date) - as.Date("2015-01-04")) %/%7 + 1 )

data1 <- data1 %>%
  mutate(state_name = case_when(state == 50 ~ "Alaska",
                           state == 1 ~ "Alabama",
                           state == 3 ~ "Arkansas",
                           state == 2 ~ "Arizona",
                           state == 4 ~ "California",
                           state == 5 ~ "Colorado",
                           state == 6 ~ "Connecticut",
                           state == 7 ~ "Delaware",
                           state == 9 ~ "Florida",
                           state == 10 ~ "Georgia",
                           state == 11 ~ "Idaho",
                           state == 51 ~ "Hawaii",
                           state == 12 ~ "Illinois",
                           state == 13 ~ "Indiana",
                           state == 14 ~ "Iowa",
                           state == 15 ~ "Kansas",
                           state == 16 ~ "Kentucky",
                           state == 17 ~ "Louisiana",
                           state == 18 ~ "Maine",
                           state == 19 ~ "Maryland",
                           state == 20 ~ "Massachusetts",
                           state == 21 ~ "Michigan",
                           state == 22 ~ "Minnesota",
                           state == 23 ~ "Mississippi",
                           state == 24 ~ "Missouri",
                           state == 25 ~ "Montana",
                           state == 26 ~ "Nebraska",
                           state == 27 ~ "Nevada",
                           state == 28 ~ "New Hampshire",
                           state == 29 ~ "New Jersey",
                           state == 30 ~ "New Mexico",
                           state == 31 ~ "New York",
                           state == 32 ~ "North Carolina",
                           state == 33 ~ "North Dakota",
                           state == 34 ~ "Ohio",
                           state == 35 ~ "Oklahoma",
                           state == 36 ~ "Oregon",
                           state == 37 ~ "Pennsylvania",
                           state == 38 ~ "Rhode Island",
                           state == 39 ~ "South Carolina",
                           state == 40 ~ "South Dakota", 
                           state == 41 ~ "Tennessee",
                           state == 42 ~ "Texas",
                           state == 43 ~ "Utah",
                           state == 44 ~ "Vermont",
                           state == 45 ~ "Virginia", 
                           state == 46 ~ "Washington",
                           state == 47 ~ "West Virginia",
                           state == 48 ~ "Wisconsin",
                           state == 49 ~ "Wyoming"))

data2 <- data2 %>%
  mutate(state_name = case_when(state == 50 ~ "Alaska",
                                state == 1 ~ "Alabama",
                                state == 3 ~ "Arkansas",
                                state == 2 ~ "Arizona",
                                state == 4 ~ "California",
                                state == 5 ~ "Colorado",
                                state == 6 ~ "Connecticut",
                                state == 7 ~ "Delaware",
                                state == 9 ~ "Florida",
                                state == 10 ~ "Georgia",
                                state == 11 ~ "Idaho",
                                state == 51 ~ "Hawaii",
                                state == 12 ~ "Illinois",
                                state == 13 ~ "Indiana",
                                state == 14 ~ "Iowa",
                                state == 15 ~ "Kansas",
                                state == 16 ~ "Kentucky",
                                state == 17 ~ "Louisiana",
                                state == 18 ~ "Maine",
                                state == 19 ~ "Maryland",
                                state == 20 ~ "Massachusetts",
                                state == 21 ~ "Michigan",
                                state == 22 ~ "Minnesota",
                                state == 23 ~ "Mississippi",
                                state == 24 ~ "Missouri",
                                state == 25 ~ "Montana",
                                state == 26 ~ "Nebraska",
                                state == 27 ~ "Nevada",
                                state == 28 ~ "New Hampshire",
                                state == 29 ~ "New Jersey",
                                state == 30 ~ "New Mexico",
                                state == 31 ~ "New York",
                                state == 32 ~ "North Carolina",
                                state == 33 ~ "North Dakota",
                                state == 34 ~ "Ohio",
                                state == 35 ~ "Oklahoma",
                                state == 36 ~ "Oregon",
                                state == 37 ~ "Pennsylvania",
                                state == 38 ~ "Rhode Island",
                                state == 39 ~ "South Carolina",
                                state == 40 ~ "South Dakota", 
                                state == 41 ~ "Tennessee",
                                state == 42 ~ "Texas",
                                state == 43 ~ "Utah",
                                state == 44 ~ "Vermont",
                                state == 45 ~ "Virginia", 
                                state == 46 ~ "Washington",
                                state == 47 ~ "West Virginia",
                                state == 48 ~ "Wisconsin",
                                state == 49 ~ "Wyoming"))

datat <- rbind(data1, data2)

data1_1 <- data1 %>%
  filter(motivation == 15 | motivation == 32 | motivation == 33)

data2_1 <- data2 %>%
  filter(motivation == 15 | motivation == 32 | motivation == 33)

datat_1 <- datat %>%
  filter(motivation == 15 | motivation == 32 | motivation == 33  | motivation == 11  | motivation == 12  | motivation == 13  | motivation == 14)

datat_12 <- datat_1 %>%
  filter(offenders_race == "W")

datat_12 <- datat_1 %>%
  filter(offense_type == "13A" | offense_type == "13B" | offense_type == "13C")

ggplot(data = data1_1, aes(x = offense_type)) +
  geom_histogram(stat = "count")

for(i in 1:51){
  data = datat_1 %>%
    filter(state == i)
  assign(data$state_name, ggplot(data = data, aes(x = month)) + 
    ggtitle(data$state_name) +
    theme(plot.title = element_text(hjust = 0.5)) + 
    geom_line(stat = "count", colour = "blue") +
    geom_point(stat = "count", colour = "blue") +
    geom_vline(linetype = 3, xintercept = 6) +
    labs(x = "Week",
         y = "Total"))
}


ggplot2.multiplot(Alabama, Arizona, Arkansas, California, Colorado, Connecticut, Delaware, Florida, Georgia, Idaho, Illinois, Indiana, Iowa, Kansas, Kentucky, Louisiana, Maine, Maryland,cols = 4)
ggplot2.multiplot(Massachusetts, Michigan, Minnesota, Mississippi, Missouri, Montana, Nebraska, Nevada, `New Hampshire`, `New Jersey`, `New Mexico`, `New York`, `North Carolina`, `North Dakota`, cols = 4)
ggplot2.multiplot(Ohio, Oklahoma, Oregon, Pennsylvania, `Rhode Island`, `South Carolina`, `South Dakota`, Tennessee, Texas, Utah, Vermont, Virginia, Washington, `West Virginia`, Wisconsin, Wyoming, cols = 4)

(6121-5850)/5850

data1 <- data1 %>%
  mutate(month = substr(date, 6, 7))
data2 <- data2 %>%
  mutate(month = substr(date, 6, 7))

datat <- datat %>%
  mutate(month = substr(date, 1, 7))

n <- datat %>%
  count(month)

n_1 <- datat_12 %>%
  count(month)

datat <- inner_join(datat, n, by = "month")

datat_12 <- inner_join(datat_12, n_1, by = "month")

datat_12 <- datat_12 %>%
  mutate(ratio = as.numeric)

ggplot(data = datat, aes(x = month)) +
  geom_line(stat = "count", colour = "blue") +
  geom_point(stat = "count", colour = "blue") +
  geom_vline(linetype = 3, xintercept = 6) +
  labs(x = "Month",
       y = "Total")

ggplot(data = datat_12, aes(x = month, y = n_1/n)) +
  geom_line(colour = "blue") +
  geom_point(colour = "blue") +
  geom_vline(linetype = 3, xintercept = 6) +
  labs(x = "Month",
       y = "Total")



