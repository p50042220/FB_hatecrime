-- Type Definition
SELECT *,
        CASE WHEN start_week <= '2015-05-24' AND quit_week = '2016-11-20' THEN "WHOLE"
            WHEN start_week > '2015-05-24' AND quit_week = '2016-11-20' THEN "NEW"
            WHEN start_week <= '2015-05-24' AND quit_week < '2016-11-20' THEN "QUIT"
            ELSE "NEW_QUIT" END AS TYPE
FROM
(SELECT user_id,
        COUNT(*) AS total_week,
        MIN(Week) AS start_week,
        MAX(Week) AS quit_week
FROM
(SELECT user_id,
        Week
FROM
(SELECT user_id,
        Week,
        COUNT(*) AS week_total
FROM(
(SELECT user_id,
        post_created_date_CT,
        DATE_ADD(DATE(2015,5,3), INTERVAL CAST(FLOOR(DATE_DIFF(CAST(post_created_date_CT AS DATE), DATE('2015-05-03'), DAY)/7) AS INT64) WEEK) AS Week
FROM `USdata.1000_page_us_user_like_post_201501_to_201611_all`
WHERE TIMESTAMP(post_created_date_CT) >= TIMESTAMP('2015-05-03')
AND TIMESTAMP(post_created_date_CT) < TIMESTAMP('2016-11-27'))
UNION DISTINCT
(SELECT user_id,
        post_created_date_CT,
        DATE_ADD(DATE(2015,5,3), INTERVAL CAST(FLOOR(DATE_DIFF(CAST(post_created_date_CT AS DATE), DATE('2015-05-03'), DAY)/7) AS INT64) WEEK) AS Week
FROM `USdata.politician_us_user_post_like_all`
WHERE TIMESTAMP(post_created_date_CT) >= TIMESTAMP('2015-05-03')
AND TIMESTAMP(post_created_date_CT) < TIMESTAMP('2016-11-27'))
)
GROUP BY user_id, Week)
WHERE week_total > 0)
GROUP BY user_id)

-- Combine with Geographical Information
SELECT A.user_id,
        B.state,
        A.TYPE,
        A.total_week,
        A.start_week,
        A.quit_week
FROM `ntufbdata.user_type.user_entering_type` AS A
INNER JOIN `ntufbdata.us_user_info.user_like_state_max_exclude_primary_all` AS B
ON A.user_id = B.user_id