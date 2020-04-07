##Combine reaction data
SELECT
  F2.user_id as user_id,
  F1.page_id as page_id,
  F1.page_name as page_name,
  F1.page_category as page_category,
  F1.post_id as post_id,
  F1.post_name as post_name,
  F1.post_message as post_message,
  F1.post_reactions as post_reactions,
  F1.post_comments as post_comments,
  F1.post_shares as post_shares,
  F1.post_created_date as post_created_date,
  F1.events as events,
  F1.page_type as page_type,
  F1.issue as issue,
FROM(
SELECT
  user_id,
  post_id,
FROM
[ntue-data-sci:Political_Polarization.other_reactions]) AS F2
INNER JOIN EACH
  [ntue-data-sci:Political_Polarization.Events_with_Trump] AS F1
ON 
  F1.post_id = F2.post_id  