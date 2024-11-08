# SQL 50 Questions

All the questions under this **LeetCode study plan**, organized according to their subheading *(topics)*. 

#### Questions on `Select`

## 1. [Recyclable and Low Fat Products](https://leetcode.com/problems/recyclable-and-low-fat-products/description/?envType=study-plan-v2&envId=top-sql-50)

Just using a `WHERE` clause will help to filter the data!

```sql

-- Write your PostgreSQL query statement below
SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';  -- Both conditions are true!

```

## 2. [Find Customer Referee](https://leetcode.com/problems/find-customer-referee/description/?envType=study-plan-v2&envId=top-sql-50) 

Using `WHERE` clause isn't enough, here we test for `NULL` values too, using `IS` identity operator.


```sql
-- Write your PostgreSQL query statement below
SELECT "name"
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL;
```

## 3. [Big Countries](https://leetcode.com/problems/big-countries/?envType=study-plan-v2&envId=top-sql-50)


```sql
-- Write your PostgreSQL query statement below
SELECT
    name, area, population
FROM
    World
WHERE -- Get big countries
    area >= 3000000 OR population >= 25000000;
```

## 4. [Article Views - I](https://leetcode.com/problems/article-views-i/description/?envType=study-plan-v2&envId=top-sql-50)

Selecting all rows where author is the viewer, then showing `distinct` author_id's only.

```sql

-- Write your PostgreSQL query statement below
SELECT DISTINCT -- Only Distinct id's
    author_id AS id
FROM
    Views
WHERE
    author_id = viewer_id -- Same author and viewer
ORDER BY
    id;
```

## 5. [Invalid Tweets](https://leetcode.com/problems/invalid-tweets/description/?envType=study-plan-v2&envId=top-sql-50)

We need to use a ***String Function*** here to check the length of tweet ***content***.


```sql 

-- Write your PostgreSQL query statement below
SELECT
    tweet_id
FROM
    Tweets
WHERE
    LENGTH(content) > 15; -- String Function in postgres
```


