#install.packages("bigrquery")

library(DBI)

con <- dbConnect(
  bigrquery::bigquery(),
  project = "ntue-data-sci",
  dataset = "Political_Polarization",
)

sql_unique_type_sub <- "SELECT type_sub FROM `ntue-data-sci.Political_Polarization.1000_page_and_politician_info` GROUP BY type_sub"
type_sub <- dbGetQuery(con, sql_unique_type_sub)$type_sub

sql_unique_type <- "SELECT type FROM `ntue-data-sci.Political_Polarization.1000_page_and_politician_info` GROUP BY type"
type <- dbGetQuery(con, sql_unique_type)$type

sql_media <- 'SELECT page_id, page_name, type, type_sub FROM `ntue-data-sci.Political_Polarization.1000_page_and_politician_info` WHERE type = "media"'
media <- dbGetQuery(con, sql_media)

library(bigQueryR)
bqr_auth()
bqr_upload_data(projectId = "ntue-data-sci", datasetId = "Political_Polarization", "media_list", media, overwrite = TRUE)

media <- data.frame()
for(type in type_sub[1:5]){
  sql <- paste("SELECT ",
              "page_name, ",
               "avg_fans, ",
               "type_sub ",
               "FROM( ",
               "SELECT ",
               "page_name, ",
               "AVG(fans) as avg_fans, ",
               "type_sub ",
               "FROM(",
               "SELECT ",
               "page_name, ",
               "avg_fans, ",
               "type_sub ",
               "FROM( ",
               "SELECT ",
               "page_name, ",
               "post_likes + 3*post_comments + 7*post_shares as fans,  ",
               "type_sub ",
               "FROM "
               "`ntue-data-sci.Political_Polarization.media_post`)", 
               "GROUP BY ",
               "type_sub, ",
               "page_name) ",
               "WHERE ", 
               "type_sub = ", 
               "'",
               type,
               "' ",
               "ORDER BY ",
               "avg_fans DESC ",
               "LIMIT 10", sep = "")
  media <- rbind(media, dbGetQuery(con, sql))
}

bqr_upload_data(projectId = "ntue-data-sci", datasetId = "Political_Polarization", "media_top", media,)

sql <- "SELECT * FROM `ntue-data-sci.Political_Polarization.top_media_post`"
media_post <- dbGetQuery(con, sql)
setwd("/home3/r05322021/Desktop/FB Data/")
write.csv(media_post, "media_post.csv", row.names = FALSE)


