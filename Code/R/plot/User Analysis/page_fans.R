install.packages("rlist")
library(tidyverse)
library(dplyr)
library(data.table)
library(ggplot2)
library(rlist)
library(devtools)
library(easyGgplot2)

##Read File Function
#Only for Clinton new fans
Readfiles_CN <- function(directory){
  setwd(directory)
  Files <- list.files(path = directory, pattern = "*.csv")
  data_list <- list()
  for(i in 1:length(Files)){
    data <- fread(Files[[i]], sep = ",")
    data$week <- i
    data$user_id <- as.double(data$user_id)
    if(i >= 7){
      data_list[[i]] <- data[, c(1,2,4,5,6,7,8,9)]
    }
    else{
      data_list[[i]] <- data
    }
    print(paste(i, "Data Done", sep = " "))
  }
  df <- rbindlist(data_list)
  return(df)
}

#General
Readfiles <- function(directory){
  setwd(directory)
  Files <- list.files(path = directory, pattern = "*.csv")
  data_list <- list()
  for(i in 1:length(Files)){
    data <- fread(Files[[i]], sep = ",")
    data$week <- i
    data$user_id <- as.double(data$user_id)
    data_list[[i]] <- data
    print(paste(i, "Data Done", sep = " "))
  }
  df <- rbindlist(data_list)
  return(df)
}

##Read Data
Clinton_path = "/home3/r05322021/Desktop/FB Data/Clinton_fans/week_fans/ideology/"
Trump_path = "/home3/r05322021/Desktop/FB Data/Trump_fans/week_fans/ideology/"
Clinton_data <- Readfiles(Clinton_path)
Trump_data <- Readfiles(Trump_path)

##Plot ideology distribution
data_list <- list()
for(i in 1:length(unique(data$week))){
  data_list[[i]] <- data_list[[i]] %>% 
    filter(week == i)
}
plot_ideology_distribution <- function(datas){
  plot_list <- list()
  for(i in 1:length(datas)){
    data <- datas[[i]]
    plot_list[[i]] <- ggplot(data = data) +
      geom_density(mapping = aes(x = user_PC1_mean_weighted))
  }
  return(plot_list)
}

plot <- plot_ideology_distribution(data_list)
ggplot2.multiplot(plot[[1]], plot[[2]], plot[[3]], plot[[4]], plot[[5]], plot[[6]], plot[[7]], plot[[8]], plot[[9]], plot[[10]], plot[[11]], plot[[12]], plot[[13]], plot[[14]], plot[[15]], plot[[16]], plot[[17]], plot[[18]], plot[[19]], plot[[20]], cols = 4)

##Read extreme_threshold data
extreme_threshold <- fread("/home3/r05322021/Desktop/FB Data/Trump_fans/extreme_user.csv")
extreme_threshold <- rbind(extreme_threshold, extreme_threshold[79, ]) 
extreme_threshold <- rbind(extreme_threshold, extreme_threshold[79, ]) 
extreme_threshold <- rbind(extreme_threshold, extreme_threshold[79, ]) 
extreme_threshold <- extreme_threshold %>%
  mutate(week = row_number())

##Merge two data
Clinton_data <- merge(x = Clinton_data, y = extreme_threshold, by = "week")
Clinton_data <- Clinton_data %>%
  add_count(week, user_PC1_mean_weighted < (mean - 1.645 * std)) %>%
  add_count(week) %>% 
  add_count(week, user_PC1_mean_weighted < -1) %>% 
  add_count(week, user_PC1_mean_weighted < (mean - 2 * std)) %>% 
  add_count(week, user_PC1_mean_weighted < (mean - 1.5 * std))

Trump_data <- merge(x = Trump_data, y = extreme_threshold, by = "week")
Trump_data <- Trump_data %>%
  add_count(week, user_PC1_mean_weighted > `1.645std`) %>%
  add_count(week) %>% 
  add_count(week, user_PC1_mean_weighted > 1) %>% 
  add_count(week, user_PC1_mean_weighted > `2std`) %>% 
  add_count(week, user_PC1_mean_weighted > (mean + 1.5 * std))
  

##Filter plotting data
C_extreme_user <- Clinton_data %>%
  filter(user_PC1_mean_weighted < (mean - 1.645 * std))

C_extreme_user1 <- Clinton_data %>%
  filter(user_PC1_mean_weighted < -1)

C_extreme_user2 <- Clinton_data %>%
  filter(user_PC1_mean_weighted < (mean - 2 * std))

C_extreme_user3 <- Clinton_data %>%
  filter(user_PC1_mean_weighted < (mean - 1.5 * std))

T_extreme_user <- Trump_data %>%
  filter(user_PC1_mean_weighted > `1.645std`)

T_extreme_user1 <- Trump_data %>%
  filter(user_PC1_mean_weighted > 1)

T_extreme_user2 <- Trump_data %>%
  filter(user_PC1_mean_weighted > `2std`)

T_extreme_user3 <- Trump_data %>%
  filter(user_PC1_mean_weighted < (mean - 1.5 * std))

##Plot ratio changing
ggplot(data = C_extreme_user2, aes(x = week, y = nnnn/nn)) +
  ggtitle("Ratio of Clinton's Extreme Fans (>2std)") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_line(colour = "blue") +
  geom_vline(linetype = 3, xintercept = 7) +
  geom_vline(linetype = 3, xintercept = 14) +
  geom_vline(linetype = 3, xintercept = 30) +
  geom_vline(linetype = 3, xintercept = 32) +
  geom_vline(linetype = 3, xintercept = 43) +
  geom_vline(linetype = 3, xintercept = 48) +
  geom_vline(linetype = 3, xintercept = 58) +
  geom_vline(linetype = 3, xintercept = 70) +
  geom_vline(linetype = 3, xintercept = 75) +
  labs(x = "Week",
       y = "Ratio")

##Added
ggplot() +
  ggtitle("Ratio of Trump and Clinton's Extreme Fans (>1.5std)") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_line(data = C_extreme_user3, aes(x = week, y = nnnnn/nn), colour = "blue") +
  geom_line(data = T_extreme_user3, aes(x = week, y = nnnnn/nn), colour = "red") +
  geom_vline(linetype = 3, xintercept = 7) +
  geom_vline(linetype = 3, xintercept = 14) +
  geom_vline(linetype = 3, xintercept = 30) +
  geom_vline(linetype = 3, xintercept = 32) +
  geom_vline(linetype = 3, xintercept = 43) +
  geom_vline(linetype = 3, xintercept = 48) +
  geom_vline(linetype = 3, xintercept = 58) +
  geom_vline(linetype = 3, xintercept = 70) +
  geom_vline(linetype = 3, xintercept = 75) +
  labs(x = "Week",
       y = "Ratio")


##Plot mean changing
ggplot(data = extreme_threshold, aes(x = week)) +
  ggtitle("Mean of All User's Ideology") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_line(aes(y = mean), colour = "blue") +
  geom_vline(linetype = 3, xintercept = 7) +
  geom_vline(linetype = 3, xintercept = 14) +
  geom_vline(linetype = 3, xintercept = 30) +
  geom_vline(linetype = 3, xintercept = 32) +
  geom_vline(linetype = 3, xintercept = 43) +
  geom_vline(linetype = 3, xintercept = 48) +
  geom_vline(linetype = 3, xintercept = 58) +
  geom_vline(linetype = 3, xintercept = 70) +
  geom_vline(linetype = 3, xintercept = 75) +
  labs(x = "Week",
       y = "Mean") 

##
ggplot(data = extreme_threshold, aes(x = week)) +
  ggtitle("Standard Deviation of All User's Ideology") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_line(aes(y = std), colour = "blue") +
  geom_vline(linetype = 3, xintercept = 7) +
  geom_vline(linetype = 3, xintercept = 14) +
  geom_vline(linetype = 3, xintercept = 30) +
  geom_vline(linetype = 3, xintercept = 32) +
  geom_vline(linetype = 3, xintercept = 43) +
  geom_vline(linetype = 3, xintercept = 48) +
  geom_vline(linetype = 3, xintercept = 58) +
  geom_vline(linetype = 3, xintercept = 70) +
  geom_vline(linetype = 3, xintercept = 75) +
  labs(x = "Week",
       y = "Mean")


 


