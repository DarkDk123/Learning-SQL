"""This is a GoogleSQL (Bigquery) script file!"""



-- SQL Subqueries - Query inside a Query!

-- Used whenever we need multiple query to perform a single query i.e.

-- 1. Find characters whose experience is between min and max of experience column.

SELECT name, experience
FROM fantasy_dataset.character
WHERE experience > (
  -- Select minimum - 2100
  SELECT MIN(experience) FROM fantasy_dataset.character
)
AND
experience < (
  -- select maximum - 15000
  SELECT MAX(experience) FROM fantasy_dataset.character
);


-- 2. Find the difference b/w a character's experience and their mentor's!

SELECT concat("(", id, ") ", name) AS char_id_name, mentor_id,
(
  SELECT experience
  FROM fantasy_dataset.character
  WHERE id = char.mentor_id
) - experience as exp_difference, 

FROM `fantasy_dataset.character` AS char
WHERE mentor_id IS NOT NULL
ORDER BY id;

-- Here, we learn to select column using subqueries also! we can also use "join" here (we'll learn about that later)
-- these syntax doesn't allow multiple columns, but there is a "STRUCT" to select multiple columns as these syntax.


-- Above, we used un-correlated subqueries for example 1 & correlated subquery for example 2.
-- correlated means, it computes dynamically for individual rows!
-- while un-correlated queries executes only ones, giving a constant value.


-- Nested query
-- A nested query, also known as a subquery, is a query within another query.
-- The inner query is executed first, and its results are used by the outer query. i.e. 

SELECT * 
FROM ( -- Using another query result as a Table
  SELECT name, level,
      CASE -- let's say for some usecase!
        WHEN class = "Mage" THEN level * 0.5
        WHEN class IN ("Archer", "Warrior") THEN level * 0.75
        ELSE level * 1.5
      END AS power_level
      FROM fantasy_dataset.character
)
WHERE power_level >= 15; -- This was hard to do without nested queries!

-- Nested query Vs Subquery -- They're almost same.

-- In a Nested query, the inner query is executed first, and its results are used by the outer query, like above. (It's a type of Subquery)
-- A subquery is a query that returns a single value or a set of values, used in a "WHERE, FROM, or SELECT" clause. (broader term)




-- Common Table Expressions (CTEs)

-- A tool to manage complexity in queries! [read.](https://docs.getdbt.com/terms/cte)
-- CTEs help us to create "temporary Tables/Views" in our SQL script to use them. A cleaner look to subqueries!


-- Writing above query as a CTE.

-- Create a temp. table.
WITH power_level_table AS (
  SELECT name, level,
      CASE -- let's say for some usecase!
        WHEN class = "Mage" THEN level * 0.5
        WHEN class IN ("Archer", "Warrior") THEN level * 0.75
        ELSE level * 1.5
      END AS power_level
      FROM fantasy_dataset.character
),
-- Creating multiple CTEs, It needs "WITH" Clause only once!
-- Useful in many complex usecases with a clean syntax
eligible_chars AS (
  SELECT *
  FROM fantasy_dataset.character
  WHERE is_alive IS TRUE AND experience > 6000
)

-- Now, query on that table! or don't use it, your choice!
SELECT *
FROM power_level_table -- Using that alias here, for a clean-readable syntax.
WHERE power_level >= 15;

-- Hence, "Common Table expressions" provide cleaner look, reusability and are more useful in complex queries instead of subqueries!

