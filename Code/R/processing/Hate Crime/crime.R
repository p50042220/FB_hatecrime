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
  for(j in 1:length(Files)){
    data <- fread(Files[[j]], sep = ",")
    data$year <- substr(Files[[j]], nchar(Files[[j]]) - 7, nchar(Files[[j]]) - 4)
    State = paste(toupper(substr(Files[[j]], 1, 1)), substr(Files[[j]], 2, nchar(Files[[j]]) - 9), sep = "")
    data <- data %>% 
      mutate(state = State)
    data_list[[j]] <- data
  }
  return(data_list)
}

##Read Data
Crime_path <- "/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Crime/"
crime <- Read_hatecrime(Crime_path)

month_char <- c("JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC")

df = data.frame()
crime_list = list()
for(i in 1:length(crime)){
  data <- crime[[i]]
  if(data$year[1] == 2015){
    data <- data %>% 
      mutate(week = as.numeric(as.Date(substr(incident_date, 1, 10)) - as.Date("2015-05-03")) %/%7 + 1,
             month = substr(incident_date, 6, 7))
  }
  else{
    data <- data %>% 
      mutate(month = case_when(substr(INCIDENT_DATE, 4, 6) == "JAN" ~ "01",
                               substr(INCIDENT_DATE, 4, 6) == "FEB" ~ "02",
                               substr(INCIDENT_DATE, 4, 6) == "MAR" ~ "03",
                               substr(INCIDENT_DATE, 4, 6) == "APR" ~ "04",
                               substr(INCIDENT_DATE, 4, 6) == "MAY" ~ "05",
                               substr(INCIDENT_DATE, 4, 6) == "JUN" ~ "06",
                               substr(INCIDENT_DATE, 4, 6) == "JUL" ~ "07",
                               substr(INCIDENT_DATE, 4, 6) == "AUG" ~ "08",
                               substr(INCIDENT_DATE, 4, 6) == "SEP" ~ "09",
                               substr(INCIDENT_DATE, 4, 6) == "OCT" ~ "10",
                               substr(INCIDENT_DATE, 4, 6) == "NOV" ~ "11",
                               substr(INCIDENT_DATE, 4, 6) == "DEC" ~ "12",)) %>% 
      mutate(date = paste(year, "-", month, "-", substr(INCIDENT_DATE, 1, 2), sep = "")) %>% 
      mutate(week = as.numeric(as.Date(date) - as.Date("2015-05-03")) %/%7 + 1)
  }
  crime_list[[i]] <- data %>% 
    select("state", "year", "month", "week")
}

crime_data <- rbindlist(crime_list) %>% 
  mutate(month_year = paste(year, month, sep = ""))

data <- crime_data %>% 
  count(week, state)

month_data <- crime_data %>% 
  count(month_year)


crime_trend <- ggplot(data = month_data, aes(x = month_year, group = 1)) +
  ggtitle("2015-2017 Monthly Crime Trend in 35 States") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_line(aes(y = n), color = "blue") +
  geom_point(aes(y = n), colour = "blue") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Month",
       y = "Total Crime")

hatecrime <- fread("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Regression/hatecrime_reg.csv")
colnames(data) <- c("week", "state_name", "crime")

hatecrime <- hatecrime %>% 
  inner_join(race, by = "week")
hatecrime <- hatecrime %>% 
  inner_join(data, by = c("week", "state_name"))

crime_imm <- fread("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/crime_related.csv", sep = ",")
crime_race <- fread("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/race_crime_related.csv", sep = ",")
write.csv(hatecrime, "/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Regression/hatecrime_reg_crime.csv", row.names = FALSE)

immigration <- crime_imm %>% 
  mutate(week = as.numeric(as.Date(post_created_date_CT) - as.Date("2015-05-03")) %/%7 + 1) %>% 
  filter(week > 0) %>% 
  count(week)

race <- crime_race %>% 
  mutate(week = as.numeric(as.Date(post_created_date_CT) - as.Date("2015-05-03")) %/%7 + 1) %>% 
  filter(week > 0) %>% 
  count(week)

month_race <- crime_race %>% 
  mutate(month = paste(substr(post_created_date_CT, 1, 4), substr(post_created_date_CT, 6, 7), sep = "")) %>% 
  count(month) %>% 
  mutate(posts = n + month_imm$n)

month_imm <- crime_imm %>% 
  mutate(month = paste(substr(post_created_date_CT, 1, 4), substr(post_created_date_CT, 6, 7), sep = "")) %>% 
  count(month)

race <- race %>% 
  mutate(posts = n + immigration$n)
race <- race[,c("week", "posts")] 
race <- race

ggplot(data = month_race, aes(x = month, group = 1)) +
  ggtitle("Time Trend of Crime Related Posts on Facebook") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_line(aes(y = posts), color = "blue") +
  geom_point(aes(y = posts), colour = "blue") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Month",
       y = "Total Posts")

hate <- hatecrime %>% 
  group_by(week) %>% 
  summarise(total = sum(n))

hate <- hate %>% 
  inner_join(race, by = "week")

cor(hate$total, hate$posts)

ideology <- fread("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/ideology/ideology_mean_difference.csv", sep = ",")

cor(hate$posts, ideology$Candidate_diff_distance)
population <- fread("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Variables/Population.csv", sep = ",", header = TRUE )
hatecrime <- hatecrime %>% 
  inner_join(population, by = "state_name") %>% 
  mutate(population = case_when(year == "2015" ~ `2015`,
                                year == "2016" ~ `2016`),
         population = gsub(",", "", population),
         population = as.numeric(population))

hatecrime <- hatecrime %>% 
  