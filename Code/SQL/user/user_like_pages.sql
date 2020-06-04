WITH OLD_USER AS(
SELECT user_id
FROM `ntufbdata.user_type.user_entering_type`
WHERE TYPE = 'WHOLE'
), REACTION AS(
(SELECT user_id,
        SPLIT(post_id, '_')[ORDINAL(1)] AS page_id,
        post_id
FROM `ntufbdata.USdata.1000_page_us_user_like_post_201501_to_201611_all`
WHERE TIMESTAMP(post_created_date_CT) >= TIMESTAMP('2015-05-03')
AND TIMESTAMP(post_created_date_CT) < TIMESTAMP('2015-05-31'))
UNION DISTINCT
(SELECT user_id,
        SPLIT(post_id, '_')[ORDINAL(1)] AS page_id,
        post_id
FROM `ntufbdata.USdata.politician_us_user_post_like_all`
WHERE TIMESTAMP(post_created_date_CT) >= TIMESTAMP('2015-05-03')
AND TIMESTAMP(post_created_date_CT) < TIMESTAMP('2015-05-31'))
)

SELECT user_id,
        STRING_AGG(page_id, ',') AS like_pages,
        STRING_AGG(CAST(like_time AS STRING), ',') AS like_times
FROM(
SELECT OLD_USER.user_id,
        REACTION.page_id,
        COUNT(*) AS like_time
FROM OLD_USER
INNER JOIN REACTION ON OLD_USER.user_id = REACTION.user_id
GROUP BY OLD_USER.user_id, REACTION.page_id)
GROUP BY user_id
      