##Read File Function
#Hatecrime
Read_hatecrime <- function(directory){
  Folders <- list.files(path = directory)
  data_list = list()
  for(i in 1:2){
    Files <- list.files(path = paste(directory, Folders[[i]], "/", sep = ""), pattern = "*.csv")
    df = data.table()
    for(j in 1:length(Files)){
      setwd(paste(directory, Folders[[i]], "/", sep = ""))
      data <- fread(Files[[j]], sep = ",")
      data$year <- substr(Files[[j]], 1, 4)
      df_list <- list(df, data)
      df <- rbindlist(df_list)
    }
    data_list <- append(data_list, df)
  }
  data_final <- merge(x = data_list[[1]], y = data_list[[2]], by = c("agency", "year"))
  return(data_final)
}

##Read Data
hatecrime_path <- "/home3/r05322021/Desktop/FB Data/hate_crime_data/"
hatecrime <- Read_hatecrime(hatecrime_path)

##Data Process
data$date = as.character(data$date)
data <- data %>%
  mutate(date = paste(substr(date, 1, 4), "-", substr(date, 5, 6), "-", substr(date, 7, 8), sep = ""),
         week = as.numeric(as.Date(date) - as.Date("2015-01-04")) %/%7 + 1,
         month_year = substr(date, 1, 7),
         month = substr(date, 6, 7),
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


##Filter out data uncovered by ideology score
ideology_data <- data %>% 
  filter(as.numeric(year) != 2017) %>%
  mutate(month2 = paste(year, month, sep = "")) %>%
  filter(as.numeric(month2) >= 201505 & as.numeric(month2) < 201612)


##Write csv
write.csv(data, file = "hate_crime.csv", row.names = FALSE)
write.csv(ideology_data, file = "hate_crime_201505_to_201611.csv", row.names = FALSE)