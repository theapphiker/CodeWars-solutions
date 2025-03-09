-- This challenge uses a lateral join to the get the top N per group.
-- Link to challenge: https://www.codewars.com/kata/5820176255c3d23f360000a9/sql

SELECT c.id AS category_id, category, p.*
FROM categories c
LEFT JOIN LATERAL
(SELECT title, views, id AS post_id
FROM posts
WHERE posts.category_id = c.id
ORDER BY views DESC, id
LIMIT 2) AS p ON TRUE
ORDER BY category, views DESC, post_id