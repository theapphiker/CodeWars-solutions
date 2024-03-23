-- This PostgreSQL identifies DVD renters whose total rentals are prime and whose identifying numbers sum to even digits.
-- Link to challenge: https://www.codewars.com/kata/64466fb8b8642100159e0574

WITH RECURSIVE n(n) AS (
  SELECT 2 n
  UNION ALL
  SELECT n+1 FROM n WHERE n<=(SELECT MAX(all_rentals) FROM customers)
), 
even_id AS (SELECT customer_id
FROM
(SELECT c.customer_id,
UNNEST(REGEXP_SPLIT_TO_ARRAY(c.customer_id::TEXT,'')) AS tid
FROM customer c) a
GROUP BY customer_id
HAVING SUM(tid::INT)%2=0), 
customers AS (SELECT c.customer_id,first_name,last_name,
COUNT(DISTINCT p.rental_id) AS all_rentals,
SUM(p.amount) AS total_payments
FROM customer c
JOIN rental r
ON c.customer_id=r.customer_id
JOIN payment p
ON r.rental_id=p.rental_id
WHERE c.customer_id IN (SELECT * FROM even_id)
GROUP BY c.customer_id,first_name,last_name)

SELECT customer_id,first_name||' '||last_name AS customer_name,
all_rentals,
total_payments
FROM customers
WHERE all_rentals IN
(SELECT a.n
FROM n a
LEFT JOIN n b
ON b.n<=SQRT(a.n)
GROUP BY a.n
HAVING a.n=2 OR a.n=3 OR MIN(a.n%b.n)>0
ORDER BY a.n ASC)
ORDER BY total_payments DESC,all_rentals DESC,last_name