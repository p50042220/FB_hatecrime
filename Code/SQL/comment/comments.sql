##Extract comment data
SELECT
  F2.user_id as user_id,
  F1.page_id as page_id,
  F1.page_name as page_name,
  F1.page_category as page_category,
  F1.post_id as post_id,
  F1.post_name as post_name,
  F1.post_message as post_message,
  F2.comments as comments,
  F2.comment_created_date as comment_created_date,
  F2.comment_created_time_UTC as comment_created_time_UTC,
  F2.likes as comment_likes,
  F2.reactions as comment_reactions,
  F1.post_reactions as post_reactions,
  F1.post_comments as post_comments,
  F1.post_shares as post_shares,
  F1.post_created_date as post_created_date,
  F1.events as events,
  F1.issue as issue,
FROM(
SELECT
  fromid as user_id,
  message as comments,
  postid as post_id,
  NTH(1, SPLIT(created_time, "T")) as comment_created_date,
  NTH(1, SPLIT(NTH(2, SPLIT(created_time, "T")), "+")) as comment_created_time_UTC,
  like_count as likes,
  reactions as reactions,
FROM
  [ntue-data-sci:US_Election_Dataset_Local.old_posts_2015_2016_comments_version20171216]) AS F2
INNER JOIN EACH
  [ntue-data-sci:Political_Polarization.Media_events_with_Trump] AS F1
ON 
  F1.post_id = F2.post_id  