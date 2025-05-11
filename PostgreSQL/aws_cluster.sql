-- This PostgreSQL analyzes backup intervals and restarts in AWS clusters.
-- Link to challenge: https://www.codewars.com/kata/652eac1a3a9be51b35dbfbbb

SELECT prev_dt::TEXT AS start_time, event_datetime::TEXT AS end_time,
aws_cluster_id, AGE(event_datetime, prev_dt) AS total_backup_duration,
rn - prev_rn - 1 AS number_of_restarts
FROM
(SELECT *,
LAG(rn) OVER (PARTITION BY aws_cluster_id ORDER BY event_datetime) AS prev_rn,
LAG(event_datetime) OVER (PARTITION BY aws_cluster_id ORDER BY event_datetime) AS prev_dt
FROM
(SELECT *,
LAG(backup_status) OVER (PARTITION BY aws_cluster_id ORDER BY event_datetime) AS prev_status,
ROW_NUMBER() OVER (PARTITION BY aws_cluster_id ORDER BY event_datetime) AS rn
FROM backup_events
ORDER BY aws_cluster_id, event_datetime) a
WHERE backup_status <> COALESCE(prev_status, 'None')) b
WHERE backup_status = 'End'
ORDER BY start_time, aws_cluster_id