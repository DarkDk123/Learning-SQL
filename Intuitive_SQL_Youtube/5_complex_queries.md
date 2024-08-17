A GoogleSQL (Bigquery) Script.

## SQL Subqueries - Query inside a Query

Used whenever we need multiple queries to perform a single query.

### 1. Find characters whose experience is between the min and max of the experience column.

```sql
SELECT name, experience
FROM fantasy_dataset.character
WHERE experience > (
  -- Select minimum - 2100
  SELECT MIN(experience) FROM fantasy_dataset.character
)
AND
experience < (
  -- Select maximum - 15000
  SELECT MAX(experience) FROM fantasy_dataset.character
);
```

### 2. Find the difference between a character's experience and their mentor's!

```sql
SELECT concat("(", id, ") ", name) AS char_id_name, mentor_id,
(
  SELECT experience
  FROM fantasy_dataset.character
  WHERE id = char.mentor_id
) - experience as exp_difference, 
FROM `fantasy_dataset.character` AS char
WHERE mentor_id IS NOT NULL
ORDER BY id;
```

- Here, we learn to select a column using subqueries also! We can also use "join" here (we'll learn about that later).
- These syntax doesn't allow multiple columns, but there is a "STRUCT" to select multiple columns using these syntax.

### Explanation:

- **Correlated Subquery :** Used in Example 2, where it computes dynamically for individual rows.
- **Un-correlated Subquery :** Used in Example 1, executes only once, giving a constant value.

## Nested Queries
A nested query, also known as a subquery, is a query within another query. The inner query is executed first, and its results are used by the outer query.

```sql
SELECT * 
FROM (
  SELECT name, level,
    CASE -- let's say for some usecase!
      WHEN class = "Mage" THEN level * 0.5
      WHEN class IN ("Archer", "Warrior") THEN level * 0.75
      ELSE level * 1.5
    END AS power_level
  FROM fantasy_dataset.character
)
WHERE power_level >= 15; -- This was hard to do without nested queries!
```

- **Nested Query vs Subquery:** 
  - Nested queries use the results of an inner query in the outer query (a type of Subquery).
  - Subqueries return a single value or a set of values, used in a `WHERE`, `FROM`, or `SELECT` clause (broader term).

## Common Table Expressions (CTEs)

A tool to manage complexity in queries! CTEs help us to create "temporary Tables/Views" in our SQL script for easier use. CTEs provide a cleaner look to subqueries!

### Example: Rewriting the above query as a CTE

```sql
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

SELECT *
FROM power_level_table -- Using that alias here, for a clean-readable syntax.
WHERE power_level >= 15;
```

- **CTE Benefits:** 
  - Provide a cleaner look.
  - Reusability.
  - More useful in complex queries instead of subqueries.

---