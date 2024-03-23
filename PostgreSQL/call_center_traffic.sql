-- This PostgreSQL analyzes call volume data for a call center by identifying peak, off-peak, and quiet hours on a specific date, as well as determining the maximum number of calls handled by a single user during each hour
-- Link to challenge: https://www.codewars.com/kata/657d994ffbfb3ac8fdb093d6

WITH count_calls AS (SELECT
to_char(called_time,'FMhh12 PM' ) AS hour,
COUNT(*) AS call_count
FROM calls 
WHERE called_time::date='2023-12-14'
GROUP BY hour),
user_max_calls AS (SELECT DISTINCT ON (hour) hour,count AS max_calls_by_single_user
FROM
(SELECT to_char(called_time,'FMhh12 PM' ) AS hour, username, COUNT(*)
FROM calls
WHERE called_time::date='2023-12-14'
GROUP BY hour,username) u
ORDER BY hour, max_calls_by_single_user DESC)

SELECT *,
CASE WHEN ROW_NUMBER() OVER (ORDER BY call_count DESC,to_timestamp(hour,'hh12 PM'))=1 THEN 'Peak Hour'
WHEN ROW_NUMBER() OVER (ORDER BY call_count DESC,to_timestamp(hour,'hh12 AM')) BETWEEN 2 AND 4 THEN 'Off-Peak Hour'
ELSE 'Quiet Hour'
END AS call_volume_category
FROM
(SELECT t.hour,
CASE WHEN call_count>0 THEN call_count ELSE 0 END AS call_count,
CASE WHEN max_calls_by_single_user>0 THEN max_calls_by_single_user ELSE 0 END AS max_calls_by_single_user
FROM count_calls cc
JOIN user_max_calls mc
ON cc.hour=mc.hour
RIGHT JOIN (SELECT to_char(dd,'FMhh12 PM' ) AS hour
FROM generate_series('2023-12-14 09:00:00'::timestamp, '2023-12-14 18:59:59'::timestamp
, '1 hour'::interval) dd) t
ON cc.hour=t.hour) a
ORDER BY call_count DESC,to_timestamp(hour,'hh12 PM')