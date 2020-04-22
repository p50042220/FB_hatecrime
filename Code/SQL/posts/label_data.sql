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
  LOWER(post_name) LIKE "%immigration%" OR
  LOWER(post_message) LIKE "%immigration%" OR
  LOWER(post_caption) LIKE "%immigration%" OR
  LOWER(post_description) LIKE "%immigration%" OR
  LOWER(post_name) LIKE "%mexican%" OR
  LOWER(post_message) LIKE "%mexican%" OR
  LOWER(post_caption) LIKE "%mexican%" OR
  LOWER(post_description) LIKE "%mexican%" OR
  LOWER(post_name) LIKE "%muslim%" OR
  LOWER(post_message) LIKE "%muslim%" OR
  LOWER(post_caption) LIKE "%muslim%" OR
  LOWER(post_description) LIKE "%muslim%" OR
  LOWER(post_name) LIKE "%immigrant%" OR
  LOWER(post_message) LIKE "%immigrant%" OR
  LOWER(post_caption) LIKE "%immigrant%" OR
  LOWER(post_description) LIKE "%immigrant%"
LIMIT 500
