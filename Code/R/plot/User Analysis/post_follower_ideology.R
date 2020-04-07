install.packages("data.table")
install.packages("tidyverse")
install.packages("bit64")

library(tidyverse)
library(dplyr)
library(data.table)
library(bit64)

setwd("/home3/r05322021/Desktop/FB Data/posts_category/")
data = fread("immigration_posts_event1.csv")

unique_pages = unique(data$page_name)
data$post_created_date <- as.Date(data$post_created_date)

data03 = data %>%
  filter(as.Date("2015-05-19") <= post_created_date & post_created_date < as.Date("2015-05-26"))

data02 = data %>%
  filter(as.Date("2015-05-26") <= post_created_date & post_created_date < as.Date("2015-06-02"))

data01 = data %>%
  filter(as.Date("2015-06-02") <= post_created_date & post_created_date < as.Date("2015-06-09"))

data0 = data %>%
  filter(as.Date("2015-06-09") <= post_created_date & post_created_date < as.Date("2015-06-16"))

data1 = data %>%
  filter(as.Date("2015-06-16") <= post_created_date & post_created_date < as.Date("2015-06-23"))

data2 = data %>%
  filter(as.Date("2015-06-23") <= post_created_date & post_created_date < as.Date("2015-06-30"))

data3 = data %>%
  filter(as.Date("2015-06-30") <= post_created_date & post_created_date < as.Date("2015-07-07"))

data4 = data %>%
  filter(as.Date("2015-07-07") <= post_created_date)

unique_pages1 = unique(data1$page_name)
unique_pages2 = unique(data2$page_name)
unique_pages3 = unique(data3$page_name)
unique_pages4 = unique(data4$page_name)

page_score_w1 = fread("/home3/r05322021/Desktop/FB Data/page_score/2015-05-03_to_2016-11-26_4weeks/page_ideology_score_4_weeks2015-06-14_to_2015-07-11.csv")
page_score_w2 = fread("/home3/r05322021/Desktop/FB Data/page_score/2015-05-03_to_2016-11-26_4weeks/page_ideology_score_4_weeks2015-06-21_to_2015-07-18.csv")
page_score_w3 = fread("/home3/r05322021/Desktop/FB Data/page_score/2015-05-03_to_2016-11-26_4weeks/page_ideology_score_4_weeks2015-06-28_to_2015-07-25.csv")
page_score_w4 = fread("/home3/r05322021/Desktop/FB Data/page_score/2015-05-03_to_2016-11-26_4weeks/page_ideology_score_4_weeks2015-07-05_to_2015-08-01.csv")

page_score_b1 = fread("/home3/r05322021/Desktop/FB Data/page_score/2015-05-03_to_2016-11-26_4weeks/page_ideology_score_4_weeks2015-05-17_to_2015-06-13.csv")
page_score_b2 = fread("/home3/r05322021/Desktop/FB Data/page_score/2015-05-03_to_2016-11-26_4weeks/page_ideology_score_4_weeks2015-05-24_to_2015-06-20.csv")
page_score_b3 = fread("/home3/r05322021/Desktop/FB Data/page_score/2015-05-03_to_2016-11-26_4weeks/page_ideology_score_4_weeks2015-05-31_to_2015-06-27.csv")
page_score_b4 = fread("/home3/r05322021/Desktop/FB Data/page_score/2015-05-03_to_2016-11-26_4weeks/page_ideology_score_4_weeks2015-06-07_to_2015-07-04.csv")

w1 <- merge(data1, page_score_w1, by.x = "page_name", by.y = "page_name")
w2 <- merge(data2, page_score_w2, by.x = "page_name", by.y = "page_name")
w3 <- merge(data3, page_score_w3, by.x = "page_name", by.y = "page_name")
w4 <- merge(data4, page_score_w4, by.x = "page_name", by.y = "page_name")

ideology_w1 <- as.data.frame(unique(w1$PC1_std))
ideology_w2 <- as.data.frame(unique(w2$PC1_std))
ideology_w3 <- as.data.frame(unique(w3$PC1_std))
ideology_w4 <- as.data.frame(unique(w4$PC1_std))

b1 <- merge(data03, page_score_b1, by.x = "page_name", by.y = "page_name")
b2 <- merge(data02, page_score_b2, by.x = "page_name", by.y = "page_name")
b3 <- merge(data01, page_score_b3, by.x = "page_name", by.y = "page_name")
b4 <- merge(data0, page_score_b4, by.x = "page_name", by.y = "page_name")

ideology_b1 <- as.data.frame(unique(b1$PC1_std))
ideology_b2 <- as.data.frame(unique(b2$PC1_std))
ideology_b3 <- as.data.frame(unique(b3$PC1_std))
ideology_b4 <- as.data.frame(unique(b4$PC1_std))

colnames(ideology_b1) <- "PC1"
colnames(ideology_b2) <- "PC1"
colnames(ideology_b3) <- "PC1"
colnames(ideology_b4) <- "PC1"


ggplot() + 
  geom_density(data = ideology_b1, mapping = aes(x = PC1), color = "darkblue") +
  geom_density(data = ideology_b2, mapping = aes(x = PC1), color = "blue") + 
  geom_density(data = ideology_b3, mapping = aes(x = PC1), color = "deepskyblue") + 
  geom_density(data = ideology_b4, mapping = aes(x = PC1), color = "skyblue") +
  labs(x = "Ideology",
       y = "Density")

colnames(ideology_w1) <- "PC1"
colnames(ideology_w2) <- "PC1"
colnames(ideology_w3) <- "PC1"
colnames(ideology_w4) <- "PC1"

length(filter(ideology_w1, abs(PC1) >=1)$PC1)/length(ideology_w1$PC1)
length(filter(ideology_w2, abs(PC1) >=1)$PC1)/length(ideology_w2$PC1)
length(filter(ideology_w3, abs(PC1) >=1)$PC1)/length(ideology_w3$PC1)
length(filter(ideology_w4, abs(PC1) >=1)$PC1)/length(ideology_w4$PC1)


unique_pages01 = unique(data0$page_name)
unique_pages02 = unique(data01$page_name)
unique_pages03 = unique(data02$page_name)
unique_pages04 = unique(data03$page_name)

select_index <- c()

data_n <- fread("immigration_negative_posts_event1.csv")

datan03 = data_n %>%
  filter(as.Date("2015-05-19") <= post_created_date & post_created_date < as.Date("2015-05-26"))

datan02 = data_n %>%
  filter(as.Date("2015-05-26") <= post_created_date & post_created_date < as.Date("2015-06-02"))

datan01 = data_n %>%
  filter(as.Date("2015-06-02") <= post_created_date & post_created_date < as.Date("2015-06-09"))

datan0 = data_n %>%
  filter(as.Date("2015-06-09") <= post_created_date & post_created_date < as.Date("2015-06-16"))

datan1 = data_n %>%
  filter(as.Date("2015-06-16") <= post_created_date & post_created_date < as.Date("2015-06-23"))

datan2 = data_n %>%
  filter(as.Date("2015-06-23") <= post_created_date & post_created_date < as.Date("2015-06-30"))

datan3 = data_n %>%
  filter(as.Date("2015-06-30") <= post_created_date & post_created_date < as.Date("2015-07-07"))

datan4 = data_n %>%
  filter(as.Date("2015-07-07") <= post_created_date)

unique_pagesn1 = unique(datan1$page_name)
unique_pagesn2 = unique(datan2$page_name)
unique_pagesn3 = unique(datan3$page_name)
unique_pagesn4 = unique(datan4$page_name)
unique_pagesn01 = unique(datan0$page_name)
unique_pagesn02 = unique(datan01$page_name)
unique_pagesn03 = unique(datan02$page_name)
unique_pagesn04 = unique(datan03$page_name)

nw1 <- merge(datan1, page_score_w1, by.x = "page_name", by.y = "page_name")
nw2 <- merge(datan2, page_score_w2, by.x = "page_name", by.y = "page_name")
nw3 <- merge(datan3, page_score_w3, by.x = "page_name", by.y = "page_name")
nw4 <- merge(datan4, page_score_w4, by.x = "page_name", by.y = "page_name")

ideology_nw1 <- as.data.frame(unique(nw1$PC1_std))
ideology_nw2 <- as.data.frame(unique(nw2$PC1_std))
ideology_nw3 <- as.data.frame(unique(nw3$PC1_std))
ideology_nw4 <- as.data.frame(unique(nw4$PC1_std))

colnames(ideology_nw1) <- "PC1"
colnames(ideology_nw2) <- "PC1"
colnames(ideology_nw3) <- "PC1"
colnames(ideology_nw4) <- "PC1"

ggplot() + 
  ggtitle("Ideology Distribution of Pages with Anti-Immigration Posts") +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_density(data = ideology_nw1, mapping = aes(x = PC1), color = "darkblue") +
  geom_density(data = ideology_nw2, mapping = aes(x = PC1), color = "blue") + 
  geom_density(data = ideology_nw3, mapping = aes(x = PC1), color = "deepskyblue") + 
  geom_density(data = ideology_nw4, mapping = aes(x = PC1), color = "skyblue") +
  scale_color_discrete(name = "Weeks",
                       breaks = c("darkblue", "blue", "deepskyblue", "skyblue"),
                       labels = c("Week1", "Week2", "Week3", "Week4")) 

nb1 <- merge(data03, page_score_b1, by.x = "page_name", by.y = "page_name")
nb2 <- merge(data02, page_score_b2, by.x = "page_name", by.y = "page_name")
nb3 <- merge(data01, page_score_b3, by.x = "page_name", by.y = "page_name")
nb4 <- merge(data0, page_score_b4, by.x = "page_name", by.y = "page_name")

ideology_nb1 <- as.data.frame(unique(nb1$PC1_std))
ideology_nb2 <- as.data.frame(unique(nb2$PC1_std))
ideology_nb3 <- as.data.frame(unique(nb3$PC1_std))
ideology_nb4 <- as.data.frame(unique(nb4$PC1_std))

colnames(ideology_nb1) <- "PC1"
colnames(ideology_nb2) <- "PC1"
colnames(ideology_nb3) <- "PC1"
colnames(ideology_nb4) <- "PC1"


ggplot() + 
  ggtitle("Ideology Distribution of Pages with Anti-Immigration Posts before 2015-06-16") +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_density(data = ideology_nb1, mapping = aes(x = PC1), color = "darkblue") +
  geom_density(data = ideology_nb2, mapping = aes(x = PC1), color = "blue") + 
  geom_density(data = ideology_nb3, mapping = aes(x = PC1), color = "deepskyblue") + 
  geom_density(data = ideology_nb4, mapping = aes(x = PC1), color = "skyblue") +
  labs(x = "Ideology",
       y = "Density")


posts_number <- c(length(data03$index), length(data02$index), length(data01$index), length(data0$index), length(data1$index),length(data2$index), length(data3$index), length(data4$index))
uniquepage_number <- c(length(unique_pages04), length(unique_pages03), length(unique_pages02),length(unique_pages01), length(unique_pages1), length(unique_pages2), length(unique_pages3), length(unique_pages4))
nposts_number <- c(length(datan03$index), length(datan02$index), length(datan01$index), length(datan0$index), length(datan1$index),length(datan2$index), length(datan3$index), length(datan4$index))
nuniquepage_number <- c(length(unique_pagesn04), length(unique_pagesn03), length(unique_pagesn02),length(unique_pagesn01), length(unique_pagesn1), length(unique_pagesn2), length(unique_pagesn3), length(unique_pagesn4))

df <- data.frame(week = c(1:8))

ggplot(df) + 
  ggtitle("Posts and Pages Mentioning Immigration") +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_line(mapping = aes(x = week, y = posts_number), color = "blue") +
  geom_point(mapping = aes(x = week, y = posts_number), color = "blue") +
  geom_line(mapping = aes(x = week, y = uniquepage_number), color = "darkblue") +
  geom_point(mapping = aes(x = week, y = uniquepage_number), color = "darkblue") +
  geom_vline(linetype = 1, xintercept = 4.5) +
  labs(x = "Week",
       y = "Total Number")

nposts_ratio <- nposts_number/posts_number
npages_ratio <- nuniquepage_number/uniquepage_number

ggplot(data = df) + 
  ggtitle("Ratio of Posts and Pages with Negative posts") +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_line(mapping = aes(x = week, y = nposts_ratio), color = "blue") +
  geom_point(mapping = aes(x = week, y = nposts_ratio), color = "blue") +
  geom_line(mapping = aes(x = week, y = npages_ratio), color = "darkblue") +
  geom_point(mapping = aes(x = week, y = npages_ratio), color = "darkblue") +
  geom_vline(linetype = 1, xintercept = 4.5) +
  labs(x = "Week",
       y = "Ratio")


page_score_w1 = fread("/home3/r05322021/Desktop/FB Data/user_score/2015-05-03_to_2016-11-26_4weeks/us_user_user_like_page_4_weeks2015-06-14_to_2015-07-11.csv")  
page_score_w2 = fread("/home3/r05322021/Desktop/FB Data/user_score/2015-05-03_to_2016-11-26_4weeks/us_user_user_like_page_4_weeks2015-06-21_to_2015-07-18.csv")   
page_score_w3 = fread("/home3/r05322021/Desktop/FB Data/user_score/2015-05-03_to_2016-11-26_4weeks/us_user_user_like_page_4_weeks2015-06-28_to_2015-07-25.csv")  
page_score_w4 = fread("/home3/r05322021/Desktop/FB Data/user_score/2015-05-03_to_2016-11-26_4weeks/us_user_user_like_page_4_weeks2015-07-05_to_2015-08-01.csv")  

page_score_b1 = fread("/home3/r05322021/Desktop/FB Data/user_score/2015-05-03_to_2016-11-26_4weeks/us_user_user_like_page_4_weeks2015-05-17_to_2015-06-13.csv")  
page_score_b2 = fread("/home3/r05322021/Desktop/FB Data/user_score/2015-05-03_to_2016-11-26_4weeks/us_user_user_like_page_4_weeks2015-05-24_to_2015-06-20.csv")   
page_score_b3 = fread("/home3/r05322021/Desktop/FB Data/user_score/2015-05-03_to_2016-11-26_4weeks/us_user_user_like_page_4_weeks2015-05-31_to_2015-06-27.csv")  
page_score_b4 = fread("/home3/r05322021/Desktop/FB Data/user_score/2015-05-03_to_2016-11-26_4weeks/us_user_user_like_page_4_weeks2015-06-07_to_2015-07-04.csv")  

data <- fread("/home3/r05322021/Desktop/FB Data/reaction/immigration_event1/negative_reactions.csv")

data$post_created_date <- as.Date(data$post_created_date)

data03 = data %>%
  filter(as.Date("2015-05-19") <= post_created_date & post_created_date < as.Date("2015-05-26"))

data02 = data %>%
  filter(as.Date("2015-05-26") <= post_created_date & post_created_date < as.Date("2015-06-02"))

data01 = data %>%
  filter(as.Date("2015-06-02") <= post_created_date & post_created_date < as.Date("2015-06-09"))

data0 = data %>%
  filter(as.Date("2015-06-09") <= post_created_date & post_created_date < as.Date("2015-06-16"))

data1 = data %>%
  filter(as.Date("2015-06-16") <= post_created_date & post_created_date < as.Date("2015-06-23"))

data2 = data %>%
  filter(as.Date("2015-06-23") <= post_created_date & post_created_date < as.Date("2015-06-30"))

data3 = data %>%
  filter(as.Date("2015-06-30") <= post_created_date & post_created_date < as.Date("2015-07-07"))

data4 = data %>%
  filter(as.Date("2015-07-07") <= post_created_date)

w1 <- merge(data1, page_score_w1, by.x = "user_id", by.y = "user_id")
w2 <- merge(data2, page_score_w2, by.x = "user_id", by.y = "user_id")
w3 <- merge(data3, page_score_w3, by.x = "user_id", by.y = "user_id")
w4 <- merge(data4, page_score_w4, by.x = "user_id", by.y = "user_id")

ideology_w1 <- as.data.frame(unique(w1$user_PC1_mean))
ideology_w2 <- as.data.frame(unique(w2$user_PC1_mean))
ideology_w3 <- as.data.frame(unique(w3$user_PC1_mean))
ideology_w4 <- as.data.frame(unique(w4$user_PC1_mean))

colnames(ideology_w1) <- "PC1"
colnames(ideology_w2) <- "PC1"
colnames(ideology_w3) <- "PC1"
colnames(ideology_w4) <- "PC1"

ggplot() + 
  ggtitle("Ideology Distribution of Pages with Anti-Immigration Posts") +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_density(data = ideology_w1, mapping = aes(x = PC1), color = "darkblue") +
  geom_density(data = ideology_w2, mapping = aes(x = PC1), color = "blue") + 
  geom_density(data = ideology_w3, mapping = aes(x = PC1), color = "deepskyblue") + 
  geom_density(data = ideology_w4, mapping = aes(x = PC1), color = "skyblue")

b1 <- merge(data03, page_score_b1, by.x = "user_id", by.y = "user_id")
b2 <- merge(data02, page_score_b2, by.x = "user_id", by.y = "user_id")
b3 <- merge(data01, page_score_b3, by.x = "user_id", by.y = "user_id")
b4 <- merge(data0, page_score_b4, by.x = "user_id", by.y = "user_id")

ideology_b1 <- as.data.frame(unique(b1$user_PC1_mean))
ideology_b2 <- as.data.frame(unique(b2$user_PC1_mean))
ideology_b3 <- as.data.frame(unique(b3$user_PC1_mean))
ideology_b4 <- as.data.frame(unique(b4$user_PC1_mean))

colnames(ideology_b1) <- "PC1"
colnames(ideology_b2) <- "PC1"
colnames(ideology_b3) <- "PC1"
colnames(ideology_b4) <- "PC1"

ggplot() + 
  geom_density(data = ideology_w1, mapping = aes(x = PC1), color = "darkblue") +
  geom_density(data = ideology_w2, mapping = aes(x = PC1), color = "blue") + 
  geom_density(data = ideology_w3, mapping = aes(x = PC1), color = "deepskyblue") + 
  geom_density(data = ideology_w4, mapping = aes(x = PC1), color = "skyblue") +
  labs(x = "Ideology",
       y = "Density")
  

ggplot() + 
  geom_density(data = ideology_b1, mapping = aes(x = PC1), color = "darkblue") +
  geom_density(data = ideology_b2, mapping = aes(x = PC1), color = "blue") + 
  geom_density(data = ideology_b3, mapping = aes(x = PC1), color = "deepskyblue") + 
  geom_density(data = ideology_b4, mapping = aes(x = PC1), color = "skyblue") +
  labs(x = "Ideology",
       y = "Density")

user <- c(length(unique(data03$user_id)), length(unique(data02$user_id)), length(unique(data01$user_id)), length(unique(data0$user_id)), length(unique(data1$user_id)), length(unique(data2$user_id)), length(unique(data3$user_id)), length(unique(data4$user_id)))

ggplot(df) + 
  ggtitle("Users Liking Anti-Immigration Posts") +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_line(mapping = aes(x = week, y = user), color = "blue") +
  geom_point(mapping = aes(x = week, y = user), color = "blue") +
  geom_vline(linetype = 1, xintercept = 4.5) +
  labs(x = "Week",
       y = "Number of users")

