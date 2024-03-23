-- This PostgresSQL accurately counts the number of users in each class, with a special rule: If a user belongs to both classes, they should only be counted under class 'b'.
-- Link to challenge: https://www.codewars.com/kata/64a579dcdddc250831dfa2b7

SELECT class,COUNT(*)
FROM
(SELECT DISTINCT ON (user_id) user_id,class
FROM users
ORDER BY user_id,class DESC) t
GROUP BY class