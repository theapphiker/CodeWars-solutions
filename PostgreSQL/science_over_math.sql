-- This PostgreSQL uses the crosstab function to identify students who excel in science over math.
-- Link to challenge: https://www.codewars.com/kata/649421e15e89dc1ca27e5fb3/sql

CREATE EXTENSION tablefunc;

SELECT student_id,name,score_difference
FROM students s
JOIN
(SELECT student_id,science-math AS score_difference
FROM
CROSSTAB('SELECT student_id,course_name,score FROM courses ORDER BY 1,2')
AS results(student_id INT, math INT, science INT)
WHERE science>math) nc
ON s.id=nc.student_id
ORDER BY score_difference DESC, student_id