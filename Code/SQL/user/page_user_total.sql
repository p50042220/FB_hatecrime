WITH IMM_AMOUNT AS (
SELECT COUNT(*) as imm_amount,
        dates,
        page_id
FROM
(SELECT page_id,
        post_id,
        SPLIT(post_created_date_CT, ' ')[OFFSET(0)]  as dates
FROM post_category.immigration_related)
GROUP BY dates, page_id),

RACE_AMOUNT AS (
SELECT COUNT(*) as race_amount,
        dates,
        page_id
FROM
(SELECT page_id,
        post_id,
        SPLIT(post_created_date_CT, ' ')[OFFSET(0)]  as dates
FROM post_category.immigration_related)
GROUP BY dates, page_id),

REACTION_TOTAL AS (
SELECT COUNT(DISTINCT user_id) as total,
        dates,
        state,
        page_id,
FROM
(SELECT reactions.user_id,
        reactions.post_id,
        user_state.state,
        STRING(post_created_date_CT) as dates,
        reactions.page_id as page_id,
FROM `us_user_info.user_like_state_max_exclude_primary_all` AS user_state
INNER JOIN
((SELECT *,
         SPLIT(post_id, '_')[OFFSET(0)] as page_id,
FROM `USdata.1000_page_us_user_like_post_201501_to_201611_all`
WHERE TIMESTAMP(post_created_date_CT) >= TIMESTAMP('2015-05-03')
AND TIMESTAMP(post_created_date_CT) < TIMESTAMP('2017-01-01'))
UNION DISTINCT
(SELECT *,
        SPLIT(post_id, '_')[OFFSET(0)] as page_id,
FROM `USdata.politician_us_user_post_like_all`
WHERE TIMESTAMP(post_created_date_CT) >= TIMESTAMP('2015-05-03')
AND TIMESTAMP(post_created_date_CT) < TIMESTAMP('2017-01-01'))) AS reactions
ON user_state.user_id = reactions.user_id)
GROUP BY dates, state, page_id)

SELECT REACTION_TOTAL.dates,
        REACTION_TOTAL.state,
        REACTION_TOTAL.page_id,
        REACTION_TOTAL.total AS user_amount,
        IMM_AMOUNT.imm_amount,
        RACE_AMOUNT.race_amount
FROM REACTION_TOTAL 
LEFT JOIN IMM_AMOUNT ON REACTION_TOTAL.dates = IMM_AMOUNT.dates
AND REACTION_TOTAL.page_id = IMM_AMOUNT.page_id
LEFT JOIN RACE_AMOUNT ON REACTION_TOTAL.dates = RACE_AMOUNT.dates
AND REACTION_TOTAL.page_id = RACE_AMOUNT.page_id