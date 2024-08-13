A GoogleSQL (BigQuery) Script.

## Transforming Columns with `SELECT` Statement

### Aliasing | Nickname of Columns When Viewing Them
```sql
SELECT
  level,
  class AS class_name,
  1.1 AS version, -- Constants values as columns
  experience / 100 AS experience_percentage, -- Calculations
  experience + 100 / level * 2 AS comp_exp, -- Complex calculations having constants and different columns
  UPPER(guild) AS guild_upper, -- Functions - prepackaged piece of code
  SQRT(health) AS sqrt_health -- There are a lot of functions, refer to specific dialect docs for more! (GoogleSQL in this case)
FROM
  `fantasy_dataset.character`;
```

## Using `SELECT` Without `FROM` Statement (Without Any Table)
- Used for testing functions, doing calculations, etc.

```sql
SELECT 38, CONCAT("Dipesh ", "Rathore") AS name;
```

## Order of Calculations
- Brackets → Functions → Multiplication/Division → Subtraction/Addition!

```sql
SELECT (4 * 5 - 5) - 4 / 2 * (POW(2, 3) + 2) + GREATEST(5, 4, 3);
```

## The `WHERE` Statement
- Used to filter data (rows) based on logical expressions on columns!

```sql
SELECT * FROM `fantasy_dataset.character` WHERE is_alive IS TRUE; -- Or is_alive = TRUE;
```

### We Can Also Combine Complex Logical Statements!
```sql
SELECT * FROM fantasy_dataset.character WHERE experience > 4000 AND is_alive IS TRUE;
```

- This all "logical statements" work on "Boolean algebra".
- Main operators we have are `NOT`, `AND`, `OR` (Actual order of execution in Boolean expressions).

```sql
SELECT NOT(true AND NOT false OR false AND (true OR true) AND true) OR (true AND (false AND true)); -- Solve based on order!
```

### Another Complex Query
```sql
SELECT name, level, is_alive, mentor_id, class
FROM `fantasy_dataset.character`
WHERE (level > 20 AND is_alive IS true OR mentor_id IS NOT NULL) AND LOWER(class) NOT IN ("mage", "archer");
```

## `DISTINCT` Clause
- Selecting only unique rows and dropping duplicated rows! Determines duplication based on all the selected columns.

```sql
SELECT DISTINCT class, CAST(is_alive AS STRING) -- also using function
FROM fantasy_dataset.character;
```

## Set Operations on Queried Rows like Union, Intersection, etc. (Same as in Maths) | [Docs](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#set_operators)

### First, Let's Create Two Different "Tables" from "Select Queries" | Useful Syntax

```sql
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
```

- Above, we can replace an already created table with `CREATE OR REPLACE TABLE table_name` syntax.
- Or only create the table if it's not there with `CREATE TABLE IF NOT EXISTS table_name` syntax.

### Union Operator to Combine Query Results (Stacking Them)
- `UNION ALL` will combine regardless of duplicated (intersection) rows!
- While `UNION DISTINCT` discards rows that are in both queries!

```sql
SELECT * FROM fantasy_dataset.character_alive
UNION ALL -- Or "UNION DISTINCT"
SELECT * FROM fantasy_dataset.character_dead;
```

### Intersection in Queries!
- `INTERSECT DISTINCT` helps to get common queries between two results.
- There is nothing like `INTERSECT ALL` ❌.

```sql
SELECT class FROM `fantasy_dataset.character_alive`
INTERSECT DISTINCT
SELECT class FROM `fantasy_dataset.character_dead`;
```

- Now, these "Set Operations" only work between queries when there are the same number of columns and of the same data types.

### Also Converting `experience` into String to Perform Valid Union
```sql
SELECT name, class, level, last_active, CAST(experience AS String) AS Exp_rare FROM `fantasy_dataset.character`

UNION DISTINCT

SELECT name, item_type, power, date_added, rarity FROM `fantasy_dataset.items`;
```

- Hence these distinct select statements are executed separately, and then Set operations are performed on them!

## Understanding `ORDER BY`

- `ORDER BY` is used to sort the returned data based on the sorted order of some columns.

```sql
SELECT * FROM `fantasy_dataset.character` ORDER BY name;
```

- By default, `ORDER BY` sorts the data in ascending order!
- We can also order by multiple columns, and with ascending or descending order.
- We can also order by columns that are not selected in the `SELECT` statement.

```sql
SELECT name, class FROM `fantasy_dataset.character` ORDER BY level DESC, class;
```

## `LIMIT` Clause

- `LIMIT` helps to show only a part of the output of the SQL Query.

```sql
SELECT name, item_type, power FROM `fantasy_dataset.items` ORDER BY power; -- This will select entire data.

SELECT name, item_type, power FROM `fantasy_dataset.items` ORDER BY power LIMIT 1; -- This will limit the output to only 1 row.
```

- But, a common misconception is that `LIMIT` reduces the cost of the SQL Query. The `LIMIT` clause never optimizes the query, it only truncates the query output to show and displays only the "N" rows.

## `CASE` Clause

- `CASE` helps us to filter data based on conditions (like if-else in other programming languages).
- A common use case of `CASE` is when bucketing the rows to better distinguish them!

```sql
-- Let's select characters with 3 different buckets i.e. 
-- level 0-15: Low.
-- level 15-25: Mid.
-- above 25 : Super.

SELECT
  name, level,
  CASE
    WHEN level BETWEEN 0 AND 14 THEN "Low"
    WHEN level BETWEEN 15 AND 24 THEN "Mid"
    ELSE "Super" -- If we remove this line, SQL will put NULL because it's not specified.
  END AS level_category
FROM fantasy_dataset.character;
```

## Working with Aggregations

- Using simple aggregation functions in the `SELECT` statement! | [Docs](https://cloud.google.com/bigquery/docs/reference/standard-sql/aggregate_functions)
- This way works on aggregating whole data.

```sql
SELECT SUM(level), AVG(level), MIN(level), MAX(level), COUNT(level), MAX(last_active) as time,
STRING_AGG(name, "-") as names -- functions for all data types.
FROM `fantasy_dataset.character`;

SELECT COUNT(*) AS Alives -- Count of is_alive.
FROM fantasy_dataset.character
WHERE is_alive = TRUE;
```