-- This PostgresSQL assigns a "Developer for the Day" in a cyclical manner.
-- Link to challenge: https://www.codewars.com/kata/6496dbe08673b33ddae5c733

WITH ne AS (SELECT ROW_NUMBER() OVER (ORDER BY birth_date DESC) AS rn,
            employee_id,full_name
FROM employees
WHERE team='backend'
ORDER BY birth_date DESC)

SELECT date,day_of_week,
employee_id,full_name
FROM
(SELECT date::DATE,
CASE
WHEN EXTRACT(dow FROM date)=1 THEN 'Monday   '
WHEN EXTRACT(dow FROM date)=2 THEN 'Tuesday  '
WHEN EXTRACT(dow FROM date)=3 THEN 'Wednesday'
WHEN EXTRACT(dow FROM date)=4 THEN 'Thursday '
WHEN EXTRACT(dow FROM date)=5 THEN 'Friday   '
END AS day_of_week,
(ROW_NUMBER() OVER ()-1)%(SELECT COUNT(*) FROM ne)+1 AS rn_mod
FROM generate_series
        ( '2023-07-01'::DATE
        , '2023-09-29'::DATE
        , '1 day'::INTERVAL) date
WHERE EXTRACT(dow FROM date) NOT IN (0,6)) t1
JOIN ne
ON t1.rn_mod=ne.rn