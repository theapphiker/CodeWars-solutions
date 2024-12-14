-- This PostgreSQL sums all values stored in all columns of type integer across all the user-created tables in a database.
-- Link to challenge: https://www.codewars.com/kata/609a6ab739660a0056fb4a29

CREATE OR REPLACE FUNCTION test_func()
RETURNS int
LANGUAGE plpgsql
AS
$$
DECLARE
total integer=0;
t_value integer;
e text;
tc text;
BEGIN
FOR e IN (SELECT table_name
FROM information_schema.tables t
WHERE t.table_schema='public' 
AND t.table_type='BASE TABLE')
LOOP
FOR tc IN (SELECT column_name
FROM information_schema.columns
WHERE table_name=e
AND data_type='integer')
LOOP
EXECUTE 'select coalesce(sum('||tc||'),0) from '||e INTO t_value;
total:=total+t_value;
END LOOP;
END LOOP;
RETURN total;
END;$$;

SELECT test_func() AS total
