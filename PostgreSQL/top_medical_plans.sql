-- This PostgreSQL aggregates patient data across multiple healthcare providers.
-- Link to challenge: https://www.codewars.com/kata/64df6e752e4b2700241340b9/sql

WITH cte AS
(SELECT imd_id, plan_name, trn_per,
ROW_NUMBER() OVER (PARTITION BY imd_id ORDER BY trn_per DESC) AS rn
FROM
(SELECT imd_id, plan_name,
ROW_NUMBER() OVER (PARTITION BY imd_id ORDER BY SUM(total_trx_per_plan) DESC),
ROUND((SUM(total_trx_per_plan) / SUM(SUM(total_trx_per_plan)) OVER (PARTITION BY imd_id))::NUMERIC,2) AS trn_per,
SUM(CASE WHEN plan_name = '0' THEN 1 ELSE 0 END) OVER (PARTITION BY imd_id) AS zero_count
FROM plan_usage_summary
GROUP BY imd_id, plan_name) t1
WHERE plan_name != '0'
AND row_number < 4 + zero_count)

SELECT imd_id,
MAX(CASE WHEN rn = 1 THEN plan_name ElSE NULL END) AS top_first_plan,
MAX(CASE WHEN rn = 1 THEN trn_per ElSE NULL END) AS top_first,
MAX(CASE WHEN rn = 2 THEN plan_name ElSE NULL END) AS top_second_plan,
MAX(CASE WHEN rn = 2 THEN trn_per ElSE NULL END) AS top_second,
MAX(CASE WHEN rn = 3 THEN plan_name ElSE NULL END) AS top_third_plan,
MAX(CASE WHEN rn = 3 THEN trn_per ElSE NULL END) AS top_third
FROM cte
GROUP BY imd_id