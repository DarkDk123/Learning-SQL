-- """This is a GoogleSQL (Bigquery) script file!"""
-- TRANSFORMING COLUMNS WITH SELECT STATEMENT

-- Aliasing | nickname OF COLUMNS when viewing them
SELECT
  level,
  class AS class_name,
  1.1 AS version, -- Constants VALUES AS COLUMNS
  experience/100 AS experience_percentage, -- Calculations
  experience + 100 / level*2 AS comp_exp, -- complex calculations having constants and differnet columns
  UPPER(guild) AS guild_upper, -- Functions - prepackaged piece of code
  SQRT(health) AS sqrt_health -- There are a lot of functions, refer to specific dilect docs for more! (GoogleSQL in this case)
FROM
  `fantasy_dataset.character`;




-- Using Select without From statement (without any table)
-- Used for testing function, doing calculations etc.

SELECT 38, concat("Dipesh ", "Rathore") as name;




-- ORDER OF CALCULATIONS
-- Brackets -> Functions -> Multiplication/Division -> subtraction/addition!

SELECT (4 * 5 - 5) - 4 / 2 * (POW(2, 3) + 2) + GREATEST(5, 4, 3);




-- THE "WHERE" STATEMENT
-- used to filter data (rows) based on logical expressions on columns!
SELECT * FROM `fantasy_dataset.character` WHERE is_alive IS TRUE; -- Or is_alive = TRUE;

-- We can also combine complex logical statements!
SELECT * FROM fantasy_dataset.character WHERE experience > 4000 AND  is_alive IS TRUE;

-- This all "logical statements" works on "boolean algebra"
-- Main operator we have are "NOT, AND, OR" (Actual order of execution in boolean expressions).
SELECT NOT(true AND NOT false OR false AND (true OR true) AND true) OR (true AND (false AND true)); -- Solve based on order!

-- Another complex query
SELECT name, level, is_alive, mentor_id, class
FROM `fantasy_dataset.character`
WHERE (level > 20 AND is_alive IS true OR mentor_id IS NOT NULL) AND LOWER(class) NOT IN ("mage", "archer");




-- DISTINCT CLAUSE
-- Selecting only Unique Rows and dropping duplicated rows! | Determines duplication based on all the selected columns.
SELECT DISTINCT class, CAST(is_alive AS STRING) -- also using function
FROM fantasy_dataset.character;




-- Set Operations on queried rows like Union, intersection etc. (Same as in maths) [Docs](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#set_operators)

-- First, let's create two different "tables" from "Select queries" | Useful syntax

CREATE TABLE fantasy_dataset.character_alive AS(
  SELECT * 
  FROM fantasy_dataset.character
  WHERE is_alive IS TRUE
);

CREATE TABLE fantasy_dataset.character_dead AS(
  SELECT *
  FROM fantasy_dataset.character
  WHERE is_alive IS FALSE
);

-- Above, we can replace a already created table with "CREATE OR REPLACE TABLE table_name" syntax.
-- Or only create the table if it's not there with "CREATE TABLE IF NOT EXISTS table_name" syntax.


-- Union operator to combine query results (stacking them)

-- "UNION ALL" will combine regradless of duplicated (intersection) rows!
-- While "UNION DISTINCT" discards rows that are in both queries!

SELECT * FROM fantasy_dataset.character_alive
UNION ALL -- Or "UNION DISTINCT"
SELECT * FROM fantasy_dataset.character_dead;


-- Intersection in queries!

-- "INTERSECT DISTINCT" helps to get common queries between two results
-- There is nothing like "INTERSECT ALL" ❌

SELECT class FROM `fantasy_dataset.character_alive`
INTERSECT DISTINCT
SELECT class FROM `fantasy_dataset.character_dead`;


-- Now, these "Set Operations" only works between queries when there are same number of columns and of same data types.

-- Also converting "experience" into String to perform valid Union.

SELECT name, class, level, last_active, CAST(experience AS String) As Exp_rare FROM `fantasy_dataset.character`
UNION DISTINCT
SELECT name, item_type, power, date_added, rarity FROM `fantasy_dataset.items`;

-- Hence this distinct select statements are executed separetely and then Set operations are performed on them!




-- Understanding "ORDER BY"
-- "ORDER BY" is used to sort the returned data based on sorted order of some columns.

SELECT * FROM `fantasy_dataset.character` ORDER BY name;

-- By default, "ORDER BY" sorts the data in ascending order!
-- We can also order by multiple columns, and with Ascending or Descending order.
-- We can also order by columns that are not selected in the select statement.

SELECT name, class FROM `fantasy_dataset.character` ORDER BY level DESC, class;


-- LIMIT clause
-- "LIMIT" helps to show only a part of the output of the SQL Query.

SELECT name, item_type, power FROM `fantasy_dataset.items` ORDER BY power; -- This will select entire data.

SELECT name, item_type, power FROM `fantasy_dataset.items` ORDER BY power LIMIT 1; -- This will limit the output to only 1 row.

-- But, a common misconception is that "LIMIT" reduces the cost of SQL Query, "LIMIT" clause never optimizes the query, it only truncates the query output to show.
-- And shows only the "N" rows.




-- CASE clause
-- "CASE" helps us to filter data based on conditions. (Like if-else in other programming langs.)
-- A common usecase of "CASE" is when bucketing the rows to better distinguise them!

-- Let's select characters with 3 different buckets i.e. 
-- level 0-15: low.
-- level 15-25: mid.
-- above 25 : Super.

SELECT
  name, level,
  CASE
    WHEN level BETWEEN 0 AND 14 THEN "Low"
    WHEN level BETWEEN 15 AND 24 THEN "Mid"
    ELSE "Super" -- If we remove this line, SQL will put NULL because it's not specified.
  END AS level_category

FROM fantasy_dataset.character; 



-- Working with "Aggregations"
-- Using simple aggregation function in the select statement!
-- [docs](https://cloud.google.com/bigquery/docs/reference/standard-sql/aggregate_functions)
-- This way works on aggregating whole data.

SELECT SUM(level), AVG(level), MIN(level), MAX(level), COUNT(level), MAX(last_active) as time,
STRING_AGG(name, "-") as names,  -- functions for all data types.
FROM `fantasy_dataset.character`;

SELECT COUNT(*) AS Alives -- count of is_alive.
FROM fantasy_dataset.character
WHERE is_alive=TRUE;

