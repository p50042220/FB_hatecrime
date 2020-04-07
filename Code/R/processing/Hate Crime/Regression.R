library(tidyverse)
library(dplyr)
library(data.table)
library(ggplot2)
library(lfe)
install.packages("lfe")

##Read File Function
#Hatecrime
Read_hatecrime <- function(directory){
  data_list = list()
  Files <- list.files(path = directory, pattern = "*.csv")
  setwd(directory)
  df = data.table()
  for(j in 1:length(Files)){
    if(substr(Files[[j]], 1, 4) == 2015 || substr(Files[[j]], 1, 4) == 2016){
      data <- fread(Files[[j]], sep = ",")
      data$year <- substr(Files[[j]], 1, 4)
      df_list <- list(df, data)
      df <- rbindlist(df_list)
    }
  }
  return(df)
}

##Read Data
hatecrime_path_IR <- "/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Cleaned Data/IR/"
IR <- Read_hatecrime(hatecrime_path_IR)
hatecrime_path_BH <- "/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Cleaned Data/BH/"
BH <- Read_hatecrime(hatecrime_path_BH)
BH <- unique(BH)

IR$date = as.character(IR$date)
IR <- IR %>%
  mutate(date = paste(substr(date, 1, 4), "-", substr(date, 5, 6), "-", substr(date, 7, 8), sep = ""),
         week = as.numeric(as.Date(date) - as.Date("2015-05-03")) %/%7 + 1, 
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

ideology_state <- fread("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Variables/hate_crime_ideology.csv")
colnames(ideology_state)[1] = "state_name"
Population <- fread("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Population.csv", header = TRUE)
Change <- fread("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Population_change.csv", header = TRUE)
for(i in 6:length(Population$`State/Area`)){
  Population$`State/Area`[i] = substr(Population$`State/Area`[i], 2, 100)
}
colnames(Population)[1] <- "state_name"

for(i in 6:length(Change$`State/Area`)){
  Change$`State/Area`[i] = substr(Change$`State/Area`[i], 2, 100)
}
colnames(Change)[1] <- "state_name"


hatecrime <- IR %>% 
  count(week, state_name) %>% 
  mutate(state_name = as.character(state_name),
         week = as.numeric(week)) %>% 
  filter(is.na(state_name) != 1)

df = data.frame()
for(j in 1:50){
  state = unique(hatecrime$state_name)[j]
  data <- hatecrime %>% 
    filter(state_name == state,
           week <= 79,
           week > 0)
  for(i in 1:79){
    if(!(i %in% unique(data$week))){
      data <- rbind(data, c(i, state, 0))
    }
    else{
      data <- data
    }
  }
  df <- rbind(df, data)
}

month_week <- IR[c("week", "year", "month_year", "quarter", "month")]
month_week <- month_week[!duplicated(month_week$week), ]
hatecrime <- df %>% 
  mutate(week = as.numeric(week),
         state_name = as.character(state_name)) %>% 
  inner_join(month_week, by = "week") %>% 
  inner_join(ideology_state, by = c("week", "state_name")) 
   
  
for(j in 1:length(unique(hatecrime$state_name))){
  state = unique(hatecrime$state_name)[j]
  data <- hatecrime %>%
    filter(as.numeric(week) <= 79) %>% 
    filter(as.numeric(week) >= 1) %>% 
    filter(state_name == state)
  print(length(data$week))
}

hatecrime <- hatecrime %>% 
  inner_join(Population, by = "state_name") %>% 
  mutate(population = case_when(year == "2015" ~ `2015`,
                                year == "2016" ~ `2016`),
         population = gsub(",", "", population),
         population = as.numeric(population),
         n = as.numeric(n),
         crime_rate = as.numeric(n)/population, 
         extreme_1_ratio = right_1_ratio + left_1_ratio,
         extreme_2std_ratio = right_2std_ratio + left_2std_ratio,
         extreme_5_ratio = right_5_ratio + left_5_ratio,
         extreme_10_ratio = right_10_ratio + left_10_ratio,
         extreme_1_total = right_1_total + left_1_total,
         extreme_2std_total = right_2std_total + left_2std_total,
         extreme_5_total = right_5_total + left_5_total,
         extreme_10_total = right_10_total + left_10_total)

hatecrime <- hatecrime[c(1:29, 41:50)]


setwd("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Regression/")
write.csv(hatecrime, "hatecrime_reg.csv", row.names = FALSE)

hatecrime_racial <- IR %>% 
  filter(motivation == 15 | motivation == 32 | motivation == 33  | motivation == 11  | motivation == 12  | motivation == 13  | motivation == 14) %>% 
  count(week, state_name) %>% 
  mutate(state_name = as.character(state_name),
         week = as.numeric(week)) %>% 
  filter(is.na(state_name) != 1)

df = data.frame()
for(j in 1:49){
  state = unique(hatecrime_racial$state_name)[j]
  data <- hatecrime_racial %>% 
    filter(state_name == state,
           week <= 79,
           week > 0)
  for(i in 1:79){
    if(!(i %in% unique(data$week))){
      data <- rbind(data, c(i, state, 0))
    }
    else{
      data <- data
    }
  }
  df <- rbind(df, data)
}

hatecrime_racial <- df %>% 
  mutate(week = as.numeric(week),
         state_name = as.character(state_name)) %>% 
  inner_join(month_week, by = "week") %>% 
  inner_join(ideology_state, by = c("week", "state_name")) 

hatecrime_racial <- hatecrime_racial %>% 
  inner_join(Population, by = "state_name") %>% 
  mutate(population = case_when(year == "2015" ~ `2015`,
                                year == "2016" ~ `2016`),
         population = gsub(",", "", population),
         population = as.numeric(population),
         n = as.numeric(n),
         crime_rate = n/population, 
         extreme_1_ratio = right_1_ratio + left_1_ratio,
         extreme_2std_ratio = right_2std_ratio + left_2std_ratio,
         extreme_5_ratio = right_5_ratio + left_5_ratio,
         extreme_10_ratio = right_10_ratio + left_10_ratio,
         extreme_1_total = right_1_total + left_1_total,
         extreme_2std_total = right_2std_total + left_2std_total,
         extreme_5_total = right_5_total + left_5_total,
         extreme_10_total = right_10_total + left_10_total)
hatecrime_racial <- hatecrime_racial[c(1:29, 41:50)]

setwd("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Regression/")
write.csv(hatecrime_racial, "hatecrime_racial_reg.csv", row.names = FALSE)

