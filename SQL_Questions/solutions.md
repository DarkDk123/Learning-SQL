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


#### Questions on `Basic Joins`

## 6. [Replace Employee ID With The Unique Identifier](https://leetcode.com/problems/replace-employee-id-with-the-unique-identifier/description/?envType=study-plan-v2&envId=top-sql-50)


Performing a Left Join to get all employees regardless of their Unique Ids.

```sql
SELECT
    unique_id,
    name
-- Needs left join to get all the employees!
FROM
    Employees e LEFT JOIN EmployeeUNI eu
    ON e.id = eu.id;
```

## 7. [Product Sales Analysis - I](https://leetcode.com/problems/product-sales-analysis-i/description/?envType=study-plan-v2&envId=top-sql-50)

Here, we need to perform an Inner Join to Combine the data of both tables!

```sql
SELECT
    product_name, year, price
FROM
    Sales s INNER JOIN Product p
    USING(product_id); -- Can use `USING` when col name is same
    -- ON s.product_id = p.product_id; 
```

## 8. [Customers Who Ran away](https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/?envType=study-plan-v2&envId=top-sql-50)

😁 To find the customers who visited but didn't make any transaction.

**Solution 1:** With Joining the tables as **Left Exclusion Join**

```sql
SELECT
    customer_id,
    COUNT(*) AS count_no_trans
FROM
    Visits v LEFT JOIN Transactions t
    ON v.visit_id = t.visit_id
WHERE
    t.visit_id IS NULL -- Filter rows (Exclusive Left JOIN)
GROUP BY
    customer_id; -- Group to count visits!
```

**Solution 2:** Using a *subquery* to check ***non-membership*** of visit ids!

```sql
SELECT
    customer_id,
    COUNT(*) AS count_no_trans
FROM
    Visits
WHERE
    -- Filter visits not having any transactions!
    visit_id NOT IN (SELECT visit_id FROM transactions)
GROUP BY
    customer_id;
```

## 9. [Rising Temperature](https://leetcode.com/problems/rising-temperature/description/?envType=study-plan-v2&envId=top-sql-50)


**Solution 1:** Here, we need to self join the table with itself, on a condition that gives all days along with it's exact previous days, and then by filtering days having more temperature than day before, we solved the question.


```sql
SELECT
    t.id AS id
FROM
    Weather t JOIN Weather y
    ON t.recordDate = (y.recordDate + 1) -- Self Join
WHERE
    t.temperature > y.temperature; -- Filter days!
```

**Solution 2:** We can also utilize **Common Table Expression** and **LAG** Function for calculating temperature differences!

As this solution has unnecessary lengthy, still windows functions can be understood by this!!

```sql
-- Common Table Expression
WITH temperatures AS (
    SELECT
        id,
        recordDate AS tDate, -- Date to verify consecutive days
        LAG(recordDate) OVER(ORDER BY recordDate) AS yDate,
        temperature AS today,
        LAG(temperature) OVER(ORDER BY recordDate) AS yesterday -- Getting exact previous days
    FROM
        Weather
)

SELECT id
FROM temperatures   
WHERE today > yesterday AND tDate = yDate + 1; -- Filter data
```

## 10. [Average Time of Process per machine](https://leetcode.com/problems/average-time-of-process-per-machine/description/?envType=study-plan-v2&envId=top-sql-50)

This is a problem that i struggled so long before! But now after little brainstorming i solved it!

```sql
SELECT
    a1.machine_id,
    -- Average of processes per machine!
    ROUND(
        AVG(a2.timestamp - a1.timestamp), 3
    ) AS processing_time
FROM
    Activity a1 JOIN Activity a2
    -- This is a lot
    ON a1.machine_id = a2.machine_id AND
    a1.process_id = a2.process_id AND
    a1.timestamp < a2.timestamp
GROUP BY
    a1.machine_id;
```

I also found a very good solution by [Mathieu Soysal](https://leetcode.com/u/MathieuSoysal/), that doesn't requires to ***self join*** the table. Here's it:

```sql
SELECT
    machine_id,
    ROUND(
        AVG(
        CASE 
            WHEN activity_type = 'start' THEN -timestamp 
            ELSE timestamp
        END)::decimal * 2  -- Decimal for postgreSQL & multiply by 2 to round correctly!
        , 3) AS processing_time
FROM
    Activity
GROUP BY
    machine_id;
```

## 11. [Employee Bonus](https://leetcode.com/problems/employee-bonus/description/?envType=study-plan-v2&envId=top-sql-50)

Joining the table on ***empID***.

```sql
SELECT
    name, bonus
FROM
    Employee LEFT JOIN Bonus
    USING(empId) -- When col name is same!
WHERE
    bonus < 1000 OR bonus IS NULL;
```

## 12. [Students and Examinations](https://leetcode.com/problems/students-and-examinations/description/?envType=study-plan-v2&envId=top-sql-50)

A good question 💡 again!

```sql
SELECT DISTINCT
    s.student_id,
    s.student_name,
    sb.subject_name,
    COALESCE(e.attended_exams, 0) AS attended_exams -- Fill 0 for Null values!
FROM
    Students s CROSS JOIN Subjects sb -- Get all subjects for each student.
    LEFT JOIN (
        -- Counting attendence in given exams!
        SELECT student_id, subject_name, COUNT(*) AS attended_exams
        FROM Examinations
        GROUP BY student_id, subject_name
    ) AS e
    ON s.student_id = e.student_id AND sb.subject_name = e.subject_name
ORDER BY
    s.student_id, sb.subject_name;
```

Also, we can ***left join*** first, then apply ***Group By*** to count ***attended_exams***!

```sql
SELECT DISTINCT
    s.student_id,
    s.student_name,
    sb.subject_name,
    COALESCE(COUNT(e.student_id), 0) AS attended_exams -- Fill 0 for Null values!
FROM
    Students s CROSS JOIN Subjects sb -- Get all subjects for each student.
    LEFT JOIN Examinations AS e
    ON s.student_id = e.student_id AND sb.subject_name = e.subject_name
GROUP BY
    s.student_id, s.student_name, sb.subject_name
ORDER BY
    s.student_id, sb.subject_name;
```

## 13. [Managers with at Least 5 Direct Reports](https://leetcode.com/problems/managers-with-at-least-5-direct-reports/description/?envType=study-plan-v2&envId=top-sql-50)

This needs a `self join` to get all the employees of all the Managers, then filtering them based on total Employees!

```sql
SELECT
    m.name
FROM
    Employee e JOIN Employee m
    ON e.managerId = m.id -- Self join to get employees-manager pairs
GROUP BY
    m.id, m.name
HAVING
    COUNT(e.id) >= 5; -- Managers with at least 5 employees.
```