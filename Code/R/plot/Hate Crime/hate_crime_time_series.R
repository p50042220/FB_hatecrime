library(tidyverse)
library(dplyr)
library(data.table)
library(ggplot2)


##Read File Function
#Hatecrime
Read_hatecrime <- function(directory){
  data_list = list()
  Files <- list.files(path = directory, pattern = "*.csv")
  df = data.table()
  for(j in 1:length(Files)){
    setwd(directory)
    data <- fread(Files[[j]], sep = ",")
    data$year <- substr(Files[[j]], 1, 4)
    df_list <- list(df, data)
    df <- rbindlist(df_list)
    }
  return(df)
}

##Read Data
hatecrime_path_IR <- "/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Cleaned Data/IR/"
IR <- Read_hatecrime(hatecrime_path_IR)
hatecrime_path_BH <- "/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Cleaned Data/BH/"
BH <- Read_hatecrime(hatecrime_path_BH)
BH <- unique(BH)
hatecrime <- inner_join(IR, BH, by = c("agency", "year"))
hatecrime <- unique(hatecrime)

IR$date = as.character(IR$date)
IR <- IR %>%
  mutate(date = paste(substr(date, 1, 4), "-", substr(date, 5, 6), "-", substr(date, 7, 8), sep = ""),
         week = as.numeric(as.Date(date) - as.Date("2006-01-01")) %/%7 + 1, 
         month = as.numeric(substr(date, 6, 7)) + (as.numeric(year) - 2006) * 12,
         month_year = substr(date, 6, 7),
         state_name = case_when(state == 50 ~ "Alaska",
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

All <- ggplot(data = IR, aes(x = month)) +
  ggtitle("A.2006-2017 Monthly Hate Crime Trend") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_line(stat = "count", colour = "blue") +
  geom_point(stat = "count", colour = "blue") +
  geom_vline(linetype = 3, xintercept = 12) +
  geom_vline(linetype = 3, xintercept = 24) +
  geom_vline(linetype = 3, xintercept = 36) +
  geom_vline(linetype = 3, xintercept = 48) +
  geom_vline(linetype = 3, xintercept = 60) +
  geom_vline(linetype = 3, xintercept = 72) +
  geom_vline(linetype = 3, xintercept = 84) +
  geom_vline(linetype = 3, xintercept = 96) +
  geom_vline(linetype = 3, xintercept = 108) +
  geom_vline(linetype = 3, xintercept = 120) +
  geom_vline(linetype = 3, xintercept = 132) +
  geom_vline(linetype = 3, xintercept = 144) +
  labs(x = "Month",
       y = "Total Hate Crime")

IR_racial <- IR %>%
  filter(motivation == 15 | motivation == 32 | motivation == 33  | motivation == 11  | motivation == 12  | motivation == 13  | motivation == 14)

Race <- ggplot(data = IR_racial, aes(x = month)) +
  ggtitle("B.2006-2017 Monthly Racial Hate Crime Trend") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_line(stat = "count", colour = "blue") +
  geom_point(stat = "count", colour = "blue") +
  geom_vline(linetype = 3, xintercept = 12) +
  geom_vline(linetype = 3, xintercept = 24) +
  geom_vline(linetype = 3, xintercept = 36) +
  geom_vline(linetype = 3, xintercept = 48) +
  geom_vline(linetype = 3, xintercept = 60) +
  geom_vline(linetype = 3, xintercept = 72) +
  geom_vline(linetype = 3, xintercept = 84) +
  geom_vline(linetype = 3, xintercept = 96) +
  geom_vline(linetype = 3, xintercept = 108) +
  geom_vline(linetype = 3, xintercept = 120) +
  geom_vline(linetype = 3, xintercept = 132) +
  geom_vline(linetype = 3, xintercept = 144) +
  labs(x = "Month",
       y = "Total Racial Hate Crime")

setwd("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Plot/Hate Crime/state_time_series/total/")
for(i in 1:51){
  data = IR %>%
    filter(state == i)
  ggsave(paste(data$state_name[1], ".pdf", sep = ""),
  assign(data$state_name, ggplot(data = data, aes(x = month)) + 
           ggtitle(data$state_name) +
           theme(plot.title = element_text(hjust = 0.5)) + 
           geom_line(stat = "count", colour = "blue") +
           geom_point(stat = "count", colour = "blue") +
           geom_vline(linetype = 3, xintercept = 12) +
           geom_vline(linetype = 3, xintercept = 24) +
           geom_vline(linetype = 3, xintercept = 36) +
           geom_vline(linetype = 3, xintercept = 48) +
           geom_vline(linetype = 3, xintercept = 60) +
           geom_vline(linetype = 3, xintercept = 72) +
           geom_vline(linetype = 3, xintercept = 84) +
           geom_vline(linetype = 3, xintercept = 96) +
           geom_vline(linetype = 3, xintercept = 108) +
           geom_vline(linetype = 3, xintercept = 120) +
           geom_vline(linetype = 3, xintercept = 132) +
           geom_vline(linetype = 3, xintercept = 144) +
           labs(x = "Week",
                y = "Total Hate Crime")))
}

setwd("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Plot/Hate Crime/state_time_series/racial/")
for(i in 1:51){
  data = IR_racial %>%
    filter(state == i)
  ggsave(paste(data$state_name[1], "_racial.pdf", sep = ""),
         assign(data$state_name, ggplot(data = data, aes(x = month)) + 
                  ggtitle(data$state_name) +
                  theme(plot.title = element_text(hjust = 0.5)) + 
                  geom_line(stat = "count", colour = "blue") +
                  geom_point(stat = "count", colour = "blue") +
                  geom_vline(linetype = 3, xintercept = 12) +
                  geom_vline(linetype = 3, xintercept = 24) +
                  geom_vline(linetype = 3, xintercept = 36) +
                  geom_vline(linetype = 3, xintercept = 48) +
                  geom_vline(linetype = 3, xintercept = 60) +
                  geom_vline(linetype = 3, xintercept = 72) +
                  geom_vline(linetype = 3, xintercept = 84) +
                  geom_vline(linetype = 3, xintercept = 96) +
                  geom_vline(linetype = 3, xintercept = 108) +
                  geom_vline(linetype = 3, xintercept = 120) +
                  geom_vline(linetype = 3, xintercept = 132) +
                  geom_vline(linetype = 3, xintercept = 144) +
                  labs(x = "Week",
                       y = "Total Racial Hate Crime")))
}

IR_total <- IR %>% 
  count(month_year, year)

IR_total <- merge(IR, IR_total, by = "month")
  
ggplot(data = IR_total) +
  ggtitle("2006-2017 Monthly Racial Hate Crime Trend") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_line(mapping = aes(x = month_year, y = n, color = year)) +
  geom_point(mapping = aes(x = month_year, y = n, color = year)) + 
  geom_vline(linetype = 3, xintercept = 12) +
  geom_vline(linetype = 3, xintercept = 24) +
  geom_vline(linetype = 3, xintercept = 36) +
  geom_vline(linetype = 3, xintercept = 48) +
  geom_vline(linetype = 3, xintercept = 60) +
  geom_vline(linetype = 3, xintercept = 72) +
  geom_vline(linetype = 3, xintercept = 84) +
  geom_vline(linetype = 3, xintercept = 96) +
  geom_vline(linetype = 3, xintercept = 108) +
  geom_vline(linetype = 3, xintercept = 120) +
  geom_vline(linetype = 3, xintercept = 132) +
  geom_vline(linetype = 3, xintercept = 144) +
  labs(x = "Month",
       y = "Total Racial Hate Crime")

ggplot2.multiplot(All, Race, cols = 1)
