-- This PostgreSQL provide an hourly breakdown of the total distance travelled by all cars in the fleet during a certain period.
-- Link to challenge: https://www.codewars.com/kata/64b3aad51cefd8003c1a35f6/sql

SELECT time_from::TEXT,time_to::TEXT,km,
'Total of '||ROW_NUMBER() OVER (ORDER BY time_from)||' hour(s): '||SUM(km) OVER (ORDER BY time_from) AS total_km
FROM
(SELECT DATE_TRUNC('hour',time) AS time_from,
DATE_TRUNC('hour',time)+interval '1 hour' AS time_to,
SUM(km) AS km
FROM cars
WHERE time BETWEEN '2023-07-16 08:00:00' AND '2023-07-16 17:59:59'
GROUP BY DATE_TRUNC('hour',time)
ORDER BY time_from) a
