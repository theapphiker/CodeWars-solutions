-- This PostgreSQL turns bad data in a database into a sales opportunity by identifying customers with bad data in a database and turning it into a sales opportunity.
-- Link to challenge: https://www.codewars.com/kata/58d460e4091c1126a000004c

DROP TABLE IF EXISTS tb1;
CREATE TEMP TABLE tb1 AS SELECT t1.customerid,c2.email,SUM(s2.price) AS total_bought,script,
ROW_NUMBER() OVER (ORDER BY SUM(s2.price) DESC,c2.email)
FROM
(SELECT customerid,'You''ve spent enough money with us so we care about your business. You don''t have an address on file yet you''ve selected an address. Please login to our site and add an address so we may use it... Don''t ask any questions on how this happened.'
 AS script
FROM sales s1
WHERE customerid NOT IN (SELECT customerid FROM addresses)
UNION
SELECT DISTINCT s.customerid,'You''ve spent enough money with us so we care about your business. Unfortunately you have selected a bad address. Please login to our site and select a good address.' 
 AS script
FROM sales s
JOIN addresses a
ON s.customerid=a.customerid
AND s.addressid!=a.addressid) t1
JOIN sales s2
ON t1.customerid=s2.customerid
JOIN customers c2
ON t1.customerid=c2.customerid
GROUP BY t1.customerid,c2.email,t1.script
HAVING SUM(s2.price)>=199
ORDER BY total_bought DESC, email;

SELECT email,total_bought,
CASE
WHEN row_number%3=1 THEN (SELECT CASE WHEN lastname!='' THEN firstname||' '||lastname ELSE firstname END FROM salesreps WHERE hiredate=(SELECT MIN(hiredate) FROM salesreps))
WHEN row_number%3=2 THEN (SELECT CASE WHEN lastname!='' THEN firstname||' '||lastname ELSE firstname END FROM salesreps WHERE hiredate!=(SELECT MAX(hiredate) FROM salesreps) AND hiredate!=(SELECT MIN(hiredate) FROM salesreps))
WHEN row_number%3=0 THEN (SELECT CASE WHEN lastname!='' THEN firstname||' '||lastname ELSE firstname END FROM salesreps WHERE hiredate=(SELECT MAX(hiredate) FROM salesreps))
END AS rep_name,
script
FROM tb1;
