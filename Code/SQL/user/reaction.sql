##Extracting reaction data
SELECT
  F3.user_id as user_id,
  F4.page_id as page_id,
  F4.page_name as page_name,
  F4.page_category as page_category,
  F4.post_name as post_name,
  F4.post_message as post_message,
  F4.post_reactions as post_reactions,
  F4.post_comments as post_comments,
  F4.post_shares as post_shares,
  F3.post_id as post_id,
  F4.post_created_date as post_created_date,
FROM (
  SELECT
    F1.user_id as user_id,
    post_id,
    NTH(1, SPLIT(post_id, "_")) as page_id,
  FROM (
    SELECT
      INTEGER(data.id) as user_id,
      post_id,
    FROM 
      FLATTEN([ntue-data-sci:Facebookdata_Kenchi_Req0102.US_top_100_circulate_magazine_3_2_reaction_data_refactor], data.id),
      FLATTEN([ntue-data-sci:Facebookdata_Kenchi_Req0102.US_top_100_circulate_magazine_3_2_reaction_data_refactor], data.type)
    WHERE
      data.type = "LIKE"
  ) as F1
  INNER JOIN EACH
    [ntue-data-sci:Political_Polarization.politician_user_info] as F2
  ON F1.user_id = F2.user_id
) as F3
INNER JOIN EACH
  [ntue-data-sci:Political_Polarization.US_top_circulate_magazine_posts] as F4
ON
  F3.post_id = F4.post_id


