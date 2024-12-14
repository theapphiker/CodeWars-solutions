-- This PostgreSQL challenge creates a simple contingency table with totals.
-- Link to challenge: https://www.codewars.com/kata/65a1199e066be50650d761e1/sql

CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT *, "Right-handed" + "Left-handed" AS "Total"
FROM
(SELECT *
FROM crosstab(
    'SELECT sex, handedness, COUNT(handedness)
      FROM survey_data
      GROUP BY sex, handedness
      ORDER BY sex DESC, handedness',
      'SELECT DISTINCT handedness FROM survey_data ORDER BY handedness DESC'
) AS ct ("Sex/Handedness" text, "Right-handed" int, "Left-handed" int)
UNION ALL
SELECT *
FROM crosstab(
    'SELECT ''Total'', handedness, COUNT(handedness)
      FROM survey_data
      GROUP BY handedness',
      'SELECT DISTINCT handedness FROM survey_data ORDER BY handedness DESC'
) AS ct ("Sex/Handedness" text, "Right-handed" int, "Left-handed" int)) t1;