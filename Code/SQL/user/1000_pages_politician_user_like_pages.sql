##create user_like_pages table
SELECT
  user_id,
  GROUP_CONCAT(page_id) as like_pages,
  GROUP_CONCAT(STRING(like_time)) as like_times,
FROM(
  SELECT
    user_id,
    page_id,
    count(*) as like_time,
  FROM(
    SELECT
      user_id,
      NTH(1, SPLIT(post_id, "_")) as page_id,
    FROM
      [ntue-data-sci:Political_Polarization.1000_pages_user_like_post_201501_to_201611_all]
    WHERE
      TIMESTAMP(post_created_date) BETWEEN TIMESTAMP("2015-01-18") AND TIMESTAMP("2015-02-14"))
  GROUP BY
    user_id,
    page_id,)
GROUP BY
  user_id
  