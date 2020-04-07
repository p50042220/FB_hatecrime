##First Select month data
SELECT
  page_id,
  page_name,
  post_id,
  post_name,
  post_message,
  post_description,
  post_created_date_CT,
FROM
  [ntue-data-sci:Political_Polarization.1000page_all_post]
WHERE
  TIMESTAMP(post_created_date_CT) BETWEEN TIMESTAMP("2015-07-01") AND TIMESTAMP("2015-07-31")


##Then do keyword searching
SELECT
  *
FROM
  [ntue-data-sci:Political_Polarization.201506]
WHERE
  post_name LIKE "%immigration%" OR
  post_message LIKE "%immigration%" OR
  post_caption LIKE "%immigration%" OR
  post_description LIKE "%immigration%" OR
  post_name LIKE "%mexican%" OR
  post_message LIKE "%mexican%" OR
  post_caption LIKE "%mexican%" OR
  post_description LIKE "%mexican%" OR
  post_name LIKE "%Mexican%" OR
  post_message LIKE "%Mexican%" OR
  post_caption LIKE "%Mexican%" OR
  post_description LIKE "%Mexican%" OR
  post_name LIKE "%muslim%" OR
  post_message LIKE "%muslim%" OR
  post_caption LIKE "%muslim%" OR
  post_description LIKE "%muslim%" OR
  post_name LIKE "%Muslim%" OR
  post_message LIKE "%Muslim%" OR
  post_caption LIKE "%Muslim%" OR
  post_description LIKE "%Muslim%" OR
  post_name LIKE "%immigrant%" OR
  post_message LIKE "%immigrant%" OR
  post_caption LIKE "%immigrant%" OR
  post_description LIKE "%immigrant%"
LIMIT 500