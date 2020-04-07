library(data.table)
library(ggplot2)
library(dplyr)
library(tidyverse)

ideology_diff = fread("/Users/penny/Downloads/ideology_mean_difference.csv")
ideology_diff$week = ideology_diff$week + 1

ggplot(data = ideology_diff, aes(x = week)) +
  geom_point(aes(y = party_diff, color = "red")) +
  geom_line(aes(y = party_diff, color = "red")) +
  geom_point(aes(y = Candidate_diff_counts, color = "blue")) +
  geom_line(aes(y = Candidate_diff_counts, color = "blue")) +
  geom_point(aes(y = Candidate_diff_distance, color = "green")) +
  geom_line(aes(y = Candidate_diff_distance, color = "green")) +
  geom_vline(linetype = 3, xintercept = 4) +
  geom_vline(linetype = 3, xintercept = 5) +
  geom_vline(linetype = 3, xintercept = 6) +
  geom_vline(linetype = 3, xintercept = 7) +
  geom_vline(linetype = 3, xintercept = 11) +
  geom_vline(linetype = 3, xintercept = 14) +
  geom_vline(linetype = 3, xintercept = 15) +
  geom_vline(linetype = 3, xintercept = 32) + 
  geom_vline(linetype = 3, xintercept = 34) +
  geom_vline(linetype = 3, xintercept = 35) + 
  geom_vline(linetype = 3, xintercept = 47) +
  geom_vline(linetype = 3, xintercept = 48) +
  geom_vline(linetype = 3, xintercept = 49) +
  geom_vline(linetype = 3, xintercept = 52) +
  geom_vline(linetype = 3, xintercept = 61) +
  geom_vline(linetype = 3, xintercept = 63) + 
  geom_vline(linetype = 3, xintercept = 65) +
  geom_vline(linetype = 3, xintercept = 67) +
  geom_vline(linetype = 3, xintercept = 70) +
  geom_vline(linetype = 3, xintercept = 72) + 
  geom_vline(linetype = 3, xintercept = 75) +
  geom_vline(linetype = 3, xintercept = 76) +
  geom_vline(linetype = 3, xintercept = 77) +
  geom_vline(linetype = 3, xintercept = 78) +
  geom_vline(linetype = 3, xintercept = 79) +
  geom_vline(linetype = 3, xintercept = 81) +
  geom_vline(linetype = 3, xintercept = 83) +
  scale_color_discrete(name = "Type of differences",
                       breaks = c("red", "blue", "green"),
                       labels = c("Party", "Candidate by likes", "Candidate by distance")) + 
  labs(x = "Week",
       y = "Ideology Difference") +
  ggsave("/Users/penny/Downloads/ideology_difference.pdf")
  
  
  