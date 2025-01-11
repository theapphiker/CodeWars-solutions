-- This PostgreSQL calculates the total availability time for a specific tutor over their entire record.
-- Link to challenge: https://www.codewars.com/kata/64bcfea1aaff1a6962182f3b

CREATE OR REPLACE FUNCTION calc_time(table_name TEXT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
total INTEGER = 0;
f_time TIMESTAMP;
l_time TIMESTAMP;
t_f_time TIMESTAMP;
t_l_time TIMESTAMP;
t_value INTEGER;
i INTEGER;
i_arr INTEGER[];
BEGIN
f_time := NULL;
EXECUTE 'SELECT ARRAY_AGG(id)
FROM (SELECT id FROM '||quote_ident(table_name)||' WHERE user_id = 777 ORDER BY avail_start, avail_end) a' INTO i_arr;
FOREACH i IN ARRAY i_arr
LOOP
EXECUTE 'SELECT avail_start, avail_end FROM '||quote_ident(table_name)||' WHERE user_id = 777 AND id = '||i INTO t_f_time, t_l_time;
IF f_time IS NULL THEN
EXECUTE 'SELECT avail_start, avail_end FROM '||quote_ident(table_name)||' WHERE user_id = 777 AND id = '||i INTO f_time, l_time;
EXECUTE 'SELECT EXTRACT(EPOCH FROM '''||l_time||'''::TIMESTAMP - '''||f_time||'''::TIMESTAMP)/60' INTO total;
ELSIF t_l_time > l_time AND l_time > t_f_time THEN
EXECUTE 'SELECT EXTRACT(EPOCH FROM '''||t_l_time||'''::TIMESTAMP - '''||l_time||'''::TIMESTAMP)/60' INTO t_value;
total := total + t_value;
EXECUTE 'SELECT avail_end FROM '||quote_ident(table_name)||' WHERE user_id = 777 AND id = '||i INTO l_time;
ELSIF t_l_time > l_time AND t_f_time > l_time THEN
EXECUTE 'SELECT EXTRACT(epoch FROM '''||t_l_time||'''::TIMESTAMP - '''||t_f_time||'''::TIMESTAMP)/60' INTO t_value;
total := total + t_value;
EXECUTE 'SELECT avail_start, avail_end FROM '||quote_ident(table_name)||' WHERE user_id = 777 AND id = '||i INTO f_time, l_time;
END IF;
END LOOP;
RETURN total;
END;$$;

SELECT calc_time('availability') AS total_minutes;