-- This PostgreSQL identifies managers who are their own manager, either directly or indirectly.
-- Link to challenge: https://www.codewars.com/kata/649409f78673b33921e59889/sql

CREATE OR REPLACE FUNCTION get_manager_cycles()
RETURNS TABLE (
id INTEGER,
name TEXT,
cycle INTEGER[])
AS $$
DECLARE
i INTEGER;
BEGIN
CREATE TEMP TABLE temp_new_table (
id INTEGER,
name TEXT,
cycle INTEGER[]) ON COMMIT DROP;
FOR i IN (SELECT t.id FROM employees t)
LOOP
WITH RECURSIVE cte AS (
SELECT e1.id, e1.name, e1.manager_id,
ARRAY[e1.id] AS path
FROM employees e1
WHERE e1.id = i
UNION ALL
SELECT e2.id, e2.name, e2.manager_id,
ARRAY_PREPEND(e2.id, path) AS path
FROM employees e2
JOIN cte ON cte.manager_id = e2.id
WHERE e2.id = ANY(cte.path) IS FALSE)
INSERT INTO temp_new_table (SELECT e3.id, e3.name, ARRAY_PREPEND(cte.manager_id, path)
FROM cte
JOIN employees e3
ON cte.manager_id  = e3.id
WHERE cte.manager_id = i);
END LOOP;
RETURN QUERY SELECT * FROM temp_new_table;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_manager_cycles();