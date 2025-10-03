-- This PostgreSQL produces a stage-based funnel report from raw messaging and engagement logs for a multi-channel marketing campaign.
-- Link to challenge: https://www.codewars.com/kata/686f7daab952c6058e61d70c/sql

WITH cte AS (SELECT DISTINCT ON (e.user_id) e.user_id, event_time, event_type 
FROM campaign_sends c
LEFT JOIN engagement_events e
ON c.user_id = e.user_id
WHERE c.campaign_id = 'SUMMER2025'
AND e.campaign_id = 'SUMMER2025'
AND event_type IN ('open', 'converted', 'click')
ORDER BY e.user_id, event_time DESC),
events AS (SELECT UNNEST(ARRAY['received', 'opened', 'clicked', 'converted']) AS stage)

SELECT stage, COUNT(user_id) AS users
FROM events e
LEFT JOIN
(SELECT *
FROM cte
UNION
SELECT DISTINCT ON (user_id) user_id, sent_at, 'received' AS event_type
FROM campaign_sends
WHERE user_id NOT IN (SELECT user_id FROM cte)
AND campaign_id = 'SUMMER2025'
ORDER BY user_id) a
ON e.stage LIKE a.event_type||'%'
GROUP BY stage
ORDER BY CASE WHEN stage = 'received' THEN 1
              WHEN stage = 'opened' THEN 2
              WHEN stage = 'clicked' THEN 3
              ELSE 4 END;