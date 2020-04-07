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
  post_created_date
FROM
  [ntue-data-sci:Political_Polarization.1000_pages_posts_201501_201611_all]
WHERE 
  TIMESTAMP(post_created_date) BETWEEN TIMESTAMP("2016-08-24") AND TIMESTAMP("2016-09-07")