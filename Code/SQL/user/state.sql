WITH USER_POLITICIAN_LIKES AS (
SELECT SPLIT(post_id, '_')[OFFSET(0)] AS page_id,
        post_id AS post_id,
        user_id AS user_id,
        post_created_date_CT AS post_created_date_CT
FROM `USdata.politician_us_user_post_like_all_remove_duplicated_politicians`
WHERE post_id NOT IN (
SELECT post_id
FROM `politician_post.201501_to_201611_all`
WHERE LOWER(page_name) LIKE '%bernie sanders%'
AND TIMESTAMP(post_created_date_CT) BETWEEN TIMESTAMP('2015-04-30') AND TIMESTAMP('2016-06-26')
UNION DISTINCT
SELECT post_id
FROM `politician_post.201501_to_201611_all`
WHERE LOWER(page_name) LIKE "%martin o'malley%"
AND TIMESTAMP(post_created_date_CT) BETWEEN TIMESTAMP('2015-05-31') AND TIMESTAMP('2016-02-01')
UNION DISTINCT
SELECT post_id
FROM `politician_post.201501_to_201611_all`
WHERE LOWER(page_name) LIKE "%lincoln chafee%"
AND TIMESTAMP(post_created_date_CT) BETWEEN TIMESTAMP('2015-06-03') AND TIMESTAMP('2015-10-23')
UNION DISTINCT
SELECT post_id
FROM `politician_post.201501_to_201611_all`
WHERE LOWER(page_name) LIKE "%jim webb%"
AND TIMESTAMP(post_created_date_CT) BETWEEN TIMESTAMP('2015-07-07') AND TIMESTAMP('2015-10-20')
UNION DISTINCT
SELECT post_id
FROM `politician_post.201501_to_201611_all`
WHERE LOWER(page_name) LIKE "%ted cruz%"
AND TIMESTAMP(post_created_date_CT) BETWEEN TIMESTAMP('2015-03-23') AND TIMESTAMP('2016-05-03')
UNION DISTINCT
SELECT post_id
FROM `politician_post.201501_to_201611_all`
WHERE LOWER(page_name) LIKE "%marco rubio%"
AND TIMESTAMP(post_created_date_CT) BETWEEN TIMESTAMP('2015-04-13') AND TIMESTAMP('2016-03-15')
UNION DISTINCT
SELECT post_id
FROM `politician_post.201501_to_201611_all`
WHERE LOWER(page_name) LIKE "%john kasich%"
AND TIMESTAMP(post_created_date_CT) BETWEEN TIMESTAMP('2015-07-21') AND TIMESTAMP('2016-05-04')
UNION DISTINCT
SELECT post_id
FROM `politician_post.201501_to_201611_all`
WHERE LOWER(page_name) LIKE "%rand paul%"
AND TIMESTAMP(post_created_date_CT) BETWEEN TIMESTAMP('2015-04-07') AND TIMESTAMP('2016-02-03')
UNION DISTINCT
SELECT post_id
FROM `politician_post.201501_to_201611_all`
WHERE LOWER(page_name) LIKE "%chris christie%"
AND TIMESTAMP(post_created_date_CT) BETWEEN TIMESTAMP('2015-06-30') AND TIMESTAMP('2016-02-10')
UNION DISTINCT
SELECT post_id
FROM `politician_post.201501_to_201611_all`
WHERE LOWER(page_name) LIKE "%lindsey graham%"
AND TIMESTAMP(post_created_date_CT) BETWEEN TIMESTAMP('2015-06-01') AND TIMESTAMP('2015-12-21')
UNION DISTINCT
SELECT post_id
FROM `politician_post.201501_to_201611_all`
WHERE LOWER(page_name) LIKE "%bobby jindal%"
AND TIMESTAMP(post_created_date_CT) BETWEEN TIMESTAMP('2015-06-24') AND TIMESTAMP('2015-11-17')
UNION DISTINCT
SELECT post_id
FROM `politician_post.201501_to_201611_all`
WHERE LOWER(page_name) LIKE "%scott walker%"
AND TIMESTAMP(post_created_date_CT) BETWEEN TIMESTAMP('2015-07-13') AND TIMESTAMP('2015-09-21')
UNION DISTINCT
SELECT post_id
FROM `politician_post.201501_to_201611_all`
WHERE LOWER(page_name) LIKE "%rick perry%"
AND TIMESTAMP(post_created_date_CT) BETWEEN TIMESTAMP('2015-06-04') AND TIMESTAMP('2015-09-11')
))
, POLITICIAN_INFO AS (
SELECT CAST(page_id AS STRING) AS page_id,
        page_name,
        politician_name,
        party,
        state
FROM `politician_info.politician_info`
WHERE state IS NOT NULL)
SELECT RANK_STATE.user_id,
        RANK_STATE.state,
        RANK_STATE.like_state
FROM
(SELECT LIKE_STATE.user_id AS user_id,
        ROW_NUMBER() OVER (PARTITION BY LIKE_STATE.user_id ORDER BY LIKE_STATE.like_state DESC) AS like_ranks,
        LIKE_STATE.state AS state,
        LIKE_STATE.like_state
FROM
(SELECT USER_POLITICIAN_LIKES.user_id,
       POLITICIAN_INFO.state,
       COUNT(*) AS like_state
from USER_POLITICIAN_LIKES 
LEFT JOIN POLITICIAN_INFO ON USER_POLITICIAN_LIKES.page_id = POLITICIAN_INFO.page_id
GROUP BY USER_POLITICIAN_LIKES.user_id, POLITICIAN_INFO.state) AS LIKE_STATE) AS RANK_STATE
WHERE RANK_STATE.like_ranks = 1