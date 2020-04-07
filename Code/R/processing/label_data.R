sql <- "SELECT * FROM `ntufbdata.label_data.201611_immigration`"
data <- dbGetQuery(con, sql)
data <- data[!duplicated(data$post_id), ]
data <- data[sample(nrow(data), 500), ]
df <- rbind(df, data[1:100,])
data <- data[101:500, ]
setwd("/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/label/")
write.csv(data, "immigration_201611.csv", row.names = FALSE, fileEncoding = "UTF-8")

write.csv(df, "immigration_all.csv", row.names = FALSE, fileEncoding = "UTF-8")
