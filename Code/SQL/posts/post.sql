##Extracting post data
SELECT
  page_id,
  page_name,
  page_category,
  post_id,
  post_name,
  post_message,
  post_picture,
  post_link,
  post_description,
  post_reactions,
  post_comments,
  post_shares,
  CONCAT(post_created_date, " ", post_created_time_UTC, " UTC") as post_created_timestamp_UTC,
  post_created_date,
FROM (
  SELECT
    from.id as page_id,
    from.name as page_name,
    from.category as page_category,
    id as post_id,
    name as post_name,
    message as post_message,
    picture as post_picture,
    link as post_link,
    description as post_description,
    reactions as post_reactions,
    comments as post_comments,
    shares as post_shares,
    NTH(1, SPLIT(created_time, "T")) as post_created_date,
    NTH(1, SPLIT(NTH(2, SPLIT(created_time, "T")), "+")) as post_created_time_UTC,
  FROM 
    [ntue-data-sci:Facebookdata_Kenchi_Req0102.top_pages_by_category_1_1_post])
WHERE
  NOT(page_id IS NULL)