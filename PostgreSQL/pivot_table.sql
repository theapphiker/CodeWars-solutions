-- This PostgreSQL creates a complicated pivot table.
-- Link to challenge: https://www.codewars.com/kata/64c57002edf1bc9f208283bc

DROP TABLE IF EXISTS pivot_table;
CREATE TABLE pivot_table AS 
SELECT c.id AS "Cat. ID", c.name AS "Category"
FROM categories c
WHERE c.id IN (SELECT p.category_id
FROM sales s
JOIN products p
ON s.product_id=p.id);

INSERT INTO pivot_table VALUES (NULL,NULL);

DO $$
DECLARE
dept TEXT;
cat_id INT;
dept_name TEXT;
cat_sum MONEY;
dept_sum MONEY;
BEGIN
FOR dept IN (SELECT d.name||' ('||d.id||')' FROM departments d WHERE d.id IN (SELECT department_id FROM sales))
LOOP
dept_sum := '$0.00';
dept_name := REPLACE((SELECT REGEXP_REPLACE(dept,'\s\(\d{1,}\)','','g')),'''','''''');
EXECUTE 'ALTER TABLE pivot_table ADD COLUMN '||quote_ident(dept)||' TEXT';
FOR cat_id IN (SELECT id FROM categories)
LOOP
EXECUTE 'SELECT COALESCE((SELECT SUM(amount)
FROM sales s
JOIN products p
ON s.product_id=p.id
JOIN categories c
ON p.category_id=c.id
JOIN departments d
ON s.department_id=d.id
WHERE c.id='||cat_id||' and d.name='''||dept_name||'''),''$0.00'')' INTO cat_sum;
EXECUTE 'UPDATE pivot_table SET '||quote_ident(dept)||'='''||cat_sum||''' WHERE "Cat. ID"='||cat_id;
dept_sum := dept_sum + cat_sum;
END LOOP;
EXECUTE 'UPDATE pivot_table SET '||quote_ident(dept)||'='''||dept_sum||''' WHERE "Cat. ID" IS NULL';
END LOOP;
END;
$$ LANGUAGE 'plpgsql';

ALTER TABLE pivot_table ADD "Totals" MONEY;

DO $$
DECLARE
c_id INT;
row_sum MONEY;
col TEXT;
t_value MONEY;
BEGIN
FOR c_id IN (SELECT "Cat. ID" FROM pivot_table)
LOOP
row_sum := '$0.00';
IF c_id IS NOT NULL THEN
FOR col IN (SELECT column_name
FROM information_schema.columns
WHERE table_name='pivot_table'
AND column_name NOT IN ('Cat. ID','Category','Totals'))
LOOP
EXECUTE 'SELECT '||quote_ident(col)||' FROM pivot_table WHERE "Cat. ID"='||c_id INTO t_value;
row_sum := row_sum + t_value;
END LOOP;
EXECUTE 'UPDATE pivot_table SET "Totals"='''||row_sum||''' WHERE "Cat. ID"='||c_id;
ELSE
FOR col IN (SELECT column_name
FROM information_schema.columns
WHERE table_name='pivot_table'
AND column_name NOT IN ('Cat. ID','Category','Totals'))
LOOP
EXECUTE 'SELECT '||quote_ident(col)||' FROM pivot_table WHERE "Cat. ID" IS NULL' INTO t_value;
row_sum := row_sum + t_value;
END LOOP;
EXECUTE 'UPDATE pivot_table SET "Totals"='''||row_sum||''' WHERE "Cat. ID" IS NULL';
END IF;
END LOOP;
END;
$$ LANGUAGE 'plpgsql';

SELECT *
FROM pivot_table
ORDER BY "Cat. ID";