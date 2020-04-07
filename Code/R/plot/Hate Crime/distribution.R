library(tidyverse)
library(dplyr)
library(data.table)
library(ggplot2)

data <- fread("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Regression/hatecrime_reg.csv")

ggplot(data = data, aes(x = cr, y = height)) +
  ggtitle("Distribution of Hate Crime Rate") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_histogram(stat = "identity", fill = "blue") 

ggplot(data = data, aes(y = cr)) +
  ggtitle("Distribution of Hate Crime Rate") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_boxplot(color = "blue") 

mean <- data %>% 
  group_by(state_name) %>%
  summarize(cr_ean = mean(cr, na.rm=TRUE)) 

data <- data %>% 
  inner_join(mean, by = "state_name")

data <- data %>% 
  mutate(cr = crime_rate * 10000)

high <- data %>% 
  filter(cr_ean > 0.0033)

high <- data %>% 
  filter(cr_ean > 0.0016)

high <- data %>% 
  filter(Mean > 0.7)

ggplot(data = high, aes(x = n)) +
  ggtitle("Distribution of Hate Crime with Rate > 0.0016") +
  theme(plot.title = element_text(hjust = 0.5)) +

  geom_bar(stat = "count", fill = "blue") +
  labs(x = "Times",
       y = "Frequency")

zero <- high %>% 
  filter(n == 0)
