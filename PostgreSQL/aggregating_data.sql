-- This PostgreSQL challenge aggregates and aligns data from multiple stages of the credit card issuance process, focusing on the specific ordering of assistants and -- dates, and handling null values.
-- Link to challenge: https://www.codewars.com/kata/65cde30b29ece3000fcf5429/sql

SELECT COALESCE(ba.event_id, c.event_id, i.event_id) AS event_id,
assistant_name, consultation_date, issuance_date
FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY event_id ORDER BY assistant_name) AS rn FROM bank_assistants) ba
FULL OUTER JOIN
(SELECT *, ROW_NUMBER() OVER (PARTITION BY event_id ORDER BY consultation_date) AS rn FROM consultations) c
ON ba.event_id = c.event_id AND ba.rn = c.rn
FULL OUTER JOIN
(SELECT *, ROW_NUMBER() OVER (PARTITION BY event_id ORDER BY issuance_date) AS rn FROM card_issuances) i
ON COALESCE(ba.event_id, c.event_id) = i.event_id AND COALESCE(ba.rn, c.rn) = i.rn
ORDER BY event_id