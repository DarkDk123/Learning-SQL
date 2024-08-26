-- """This is a GoogleSQL (Bigquery) script file!"""


-- _____________Aggregations-in-SQL_______________________

-- Aggregation in data refers to the process of combining multiple data points into a single value.
-- In SQL, aggregation is used to perform calculations on a set of rows and return a single output.
-- Common SQL Aggregation functions are SUM, AVG, MAX, MIN, COUNT etc.

-- We've seen common Aggregations on entire data using these functions!
-- But, now we'll perform aggregations on specific groups of data using "GROUP BY".



-- A. GROUP BY

-- Aggregation is often used with the GROUP BY clause
-- to group data by one or more columns and perform calculations on each group.
-- It's handy in many common business problems, it squishes rows in buckets i.e. 


-- 1. What are the average level measures by class of characters??

-- Averaging the level by class
SELECT ROUND(AVG(level), 3) AS Average, class 
FROM fantasy_dataset.character
GROUP BY class; -- Creating groups by class!


-- We can infact group by multiple fields i.e
-- 2. Average power by item type & rarity combination

SELECT  item_type, rarity, AVG(power) AS avg_power
FROM fantasy_dataset.items
GROUP BY item_type, rarity
ORDER BY 1,2; -- can use col numbers

-- To avoid error in Group BY clause, remember:
-- Law of grouping: After grouping we can only select:

-- 1. Grouping Fields (Columns that are listed in GROUP BY)
-- 2. Aggregations of other fields.


-- But, the above law is an exception as below -
-- We can also group by multiple grouping sets such as: 

SELECT name, class, AVG(experience) AS avg_exp, is_alive, guild
FROM fantasy_dataset.character
GROUP BY GROUPING SETS (
  (class),  -- Group by class only
  (name),  -- Group by name only
  (is_alive, guild)  -- Group by both is_alive & guild
) ORDER BY avg_exp;


-- B. HAVING clause

-- "Having" is used to filter groups created by "Group By"
-- We can apply any boolean condition to drop/filter the groups/buckets.


-- 1. List all character classes with average experience above 7000

SELECT class, AVG(experience) as avg_experience
FROM fantasy_dataset.character
GROUP BY class
HAVING avg_experience > 7000; -- Dropping groups having exp <= 7000



-- C. WINDOW Functions in SQL:

-- Window functions perform calculations across a set of rows, known as a "window", that are related to the current row. They allow you to:

-- Calculate aggregations (e.g., SUM, AVG) over a window
-- Rank rows within a window
-- Access data from previous or next rows within a window

-- Unlike group by aggregations, which collapse multiple rows into a single row, window functions do not collapse rows.
-- Instead, they return a value for each row in the result set, based on the calculation performed over the window.
-- Window, a set of rows related to the current row, defined by the OVER() clause, used for calculations like aggregations, rankings, and accessing neighboring rows.


-- There are 4 most used types of windows

-- 1. OVER() : Using Entire table as a window, then performing aggregating functions on it! 

-- i.e. show each item in the items table, with a "total sum of power" & what % of total power that item holds.

SELECT
  name, item_type,
  `power`, SUM(`power`) OVER() AS total_power_sum, -- Sum (aggregating) over entire table, no-row collapsed!
  ROUND(`power`/SUM(`power`) OVER() * 100, 2) AS percent_total_power, -- shared power  
FROM fantasy_dataset.items;


-- 2. OVER(PARTITION BY col) : Using partitions to perform aggregating functions separately within each group defined by the column.
 
-- Example: Show each item in the items table, along with the total sum of power for its item_type and the percentage of the item's power relative to its item_type.

SELECT
  name, item_type, power,
  SUM(power) OVER (PARTITION BY item_type) as total_power_by_type, -- Sum of power within each item_type (Window)
  ROUND(power/SUM(power) OVER (PARTITION BY item_type) * 100, 2)
  AS percent_power_by_type, -- Percentage of power within item_type

FROM fantasy_dataset.items;
            

-- 3. OVER(ORDER BY col) : Using ordering to perform calculations that depend on the sequence of rows, such as running totals or rankings.

-- Example: List all items with their cumulative power ordered by power ascending.

SELECT
  name, item_type, `power`, -- wrap `` to avoid name clashes.
  SUM(`power`) OVER(ORDER BY `power`) AS cumulative_power -- Running total of power ordered by power value
FROM fantasy_dataset.items;


-- 4.OVER(PARTITION BY col ORDER BY col2) : Combining partitioning and ordering to perform calculations like running totals or rankings within each group. 

-- Example: Show each item with its cumulative power within each item_type, ordered by power ascending.

SELECT
  name, item_type, power,
  SUM(`power`) OVER(
    PARTITION BY item_type ORDER BY `power`
  ) AS cumulative_power_by_type, -- Running total of power within each item_type
  ROW_NUMBER() OVER(PARTITION BY item_type ORDER BY power) AS power_rank_by_type -- Rank of each item within item_type based on power
FROM
  fantasy_dataset.items;

-- As usual, we can use multiple columns with PARTITION BY & ORDER BY when using in a window function!


-- Also, some commonly used "window function" are "Numbering Functions"!

-- Number functions in SQL window functions are used to generate specific types
-- of numeric values over a window of rows such as Rank, Dense_rank, Row_number, Ntile etc.


-- ROW_NUMBER(): Assigns a unique sequential integer to rows, starting from 1 for the first row in each partition.

-- RANK(): Assigns a rank to each row, with the same rank given to rows with equal values,
-- but leaves gaps in the ranking for ties. like 1,2,3,3,5,6 etc.

-- DENSE_RANK(): Similar to RANK(), but does not leave gaps in the ranking for ties. like 1,2,3,3,4,5 etc.

-- NTILE(n): Divides the rows in the partition/window into n buckets and assigns a bucket number to each row.

SELECT
  name, item_type, weight, 
  ROW_NUMBER() OVER(ORDER BY weight) as row_num,
  RANK() OVER(ORDER BY weight) as rank, -- obviously, we can use any window (PARTITION BY) here!
  DENSE_RANK() OVER(ORDER BY weight) as rank_dense,
  NTILE(17) OVER(ORDER BY weight) as bucket_num
FROM fantasy_dataset.items
ORDER BY weight;

-- [Numbering_functions](/link/to/img/)