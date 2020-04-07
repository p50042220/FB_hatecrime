##Read extreme_threshold
extreme_threshold <- fread("/home3/r05322021/Desktop/FB Data/Trump_fans/extreme_user.csv")
extreme_threshold <- rbind(extreme_threshold, extreme_threshold[79, ]) 
extreme_threshold <- rbind(extreme_threshold, extreme_threshold[79, ]) 
extreme_threshold <- rbind(extreme_threshold, extreme_threshold[79, ]) 
extreme_threshold <- extreme_threshold %>%
  mutate(week = row_number())

##Readfile function
#Ideology_state
Read_ideology <- function(directory){
  setwd(directory)
  Files <- list.files(path = directory, pattern = "*.csv")
  data_list <- list()
  for(i in 1:length(Files)){
    data <- fread(Files[[i]], sep = ",")
    data$week <- i
    data <- merge(x = data, y = extreme_threshold, by = "week")
    data <- data %>%
      group_by(like_state_max) %>% 
      add_count(week, user_PC1_mean_weighted > `1.645std`) %>%
      add_count(week) %>% 
      filter(user_PC1_mean_weighted > `1.645std`) %>% 
      mutate()
    data_list[[i]] <- data
    print(paste(i, "Data Done", sep = " "))
  }
  print("Start binding data")
  df <- rbindlist(data_list)
  return(df)
}

##Read data
ideology_path <- "/home3/r05322021/Desktop/FB Data/user_score/user_score_with_state/"
ideology <- Read_ideology(ideology_path)
ideology <- ideology %>% 
  mutate(ratio = n/nn)

##Write csv
write.csv(ideology, file = "extreme_state_week.csv", row.names = FALSE)











