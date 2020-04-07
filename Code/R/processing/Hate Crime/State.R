library(tidyverse)
library(dplyr)
library(data.table)
library(ggplot2)

data <- fread("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Regression/hatecrime_reg.csv")

for(i in 1:length(data$week)){
  if(data$week[i] %% 79 == 1){
    data$mean_diff_last[i] = data$mean_diff[i]
  }
  else{
    data$mean_diff_last[i] = data$mean_diff[i - 1]
  }
}

for(i in 1:length(data$week)){
  if(data$week[i] %% 79 <= 2){
    data$mean_diff_last2[i] = data$mean_diff[i]
  }
  else{
    data$mean_diff_last2[i] = data$mean_diff[i - 2]
  }
}

state <- data.frame()
for(i in 1:length(unique(data$state_name))){
  df <- data %>% 
    filter(state_name == unique(data$state_name)[i])
  if(max(df$n) >= 5){
    state <- rbind(state, df)
  }
}

ggplot(data = state, aes(x = n)) +
  ggtitle("Distribution of Hate Crime in Higher Crime-Rate State") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_bar(stat = "count", fill = "blue")

write.csv(state, "/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Regression/hatecrime_reg_low.csv", row.names = FALSE)
