-- This challenge calculates the frequency of each word from a sprint retrospective.
-- Link to challenge: https://www.codewars.com/kata/695ab2c033095ab4afafbbed/sql

WITH cte AS (SELECT regexp_split_to_table(LOWER(msg), '[^a-z0-9''/_-]+') AS word
FROM retro_comments)

SELECT word, COUNT(*) AS freq
FROM cte
WHERE LENGTH(word) > 2
AND word NOT IN (SELECT word FROM stopwords)
GROUP BY 1
ORDER BY 2 DESC, 1
LIMIT 10;