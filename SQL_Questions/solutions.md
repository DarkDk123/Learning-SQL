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

## 14. [Confirmation Rate](https://leetcode.com/problems/confirmation-rate/description/?envType=study-plan-v2&envId=top-sql-50)

The solution i came up with! The round logic may be unintuitive!!

```sql
-- Write your PostgreSQL query statement below

SELECT
    s.user_id,
    -- Doing average manually, i could use Average function!
    ROUND(SUM(CASE
        WHEN action = 'confirmed' THEN 1 ELSE 0
    END) / (COUNT(COALESCE(action, ''))::DECIMAL), 2) AS confirmation_rate
FROM
    Signups s LEFT JOIN Confirmations c
    ON s.user_id = c.user_id
GROUP BY
    s.user_id;
```

Solution 

```sql
-- Write your PostgreSQL query statement below

SELECT
    s.user_id,
    -- Little short, As average function can do the work!!
    ROUND(
        AVG(CASE WHEN action = 'confirmed' THEN 1 ELSE 0 END), 2
    )AS confirmation_rate
FROM
    Signups s LEFT JOIN Confirmations c
    ON s.user_id = c.user_id
GROUP BY
    s.user_id;

```

#### Basic `Aggregate Functions`

## 15. [Not Boring Movies](https://leetcode.com/problems/not-boring-movies/?envType=study-plan-v2&envId=top-sql-50)

Just a filter condition can do the work here!

```sql
SELECT
    *
FROM
    Cinema
WHERE
    id % 2 <> 0 AND description <> 'boring' -- Filter
ORDER BY
    rating DESC;
```

## 16. [Average Selling Price](https://leetcode.com/problems/average-selling-price/?envType=study-plan-v2&envId=top-sql-50)

There is just a **quick logic** in how we join the tables, and then how to calculate the corresponding Average Price of each product.

I got the solution by **try-n-error**, but simply aggregating on each groups of `product_id`, it's solved !

```sql
-- Write your PostgreSQL query statement below
SELECT
    p.product_id,
    COALESCE(ROUND(
        -- Average price of products
        SUM(price * units)/ SUM(units)::DECIMAL, 2
    ), 0) AS average_price
FROM
    Prices p LEFT JOIN UnitsSold u
    ON p.product_id = u.product_id AND
    u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY
    p.product_id;
```

## 17. [Project Employees - I](https://leetcode.com/problems/project-employees-i/description/?envType=study-plan-v2&envId=top-sql-50)

Performing Rounded Average of `experience_years` over each ***project groups***.

```sql
SELECT
    project_id,
    ROUND(
        AVG(experience_years), 2 -- Rounded Average of experience.
    ) AS average_years
FROM
    Project p JOIN Employee e
    USING(employee_id) -- When col name is same!
GROUP BY
    project_id;
```


## 18. [Percentage of Users Attended a Contest](https://leetcode.com/problems/percentage-of-users-attended-a-contest/description/?envType=study-plan-v2&envId=top-sql-50)

Grouping by `contest_id` after joining the tables on `user_id`, Then calculating the percentage of users who attended the contest.

```sql
SELECT
    contest_id,
    ROUND(
        -- This correlated subquery is expensive,
        -- instead join total users from users table (Do yourself!)
        COUNT(r.user_id) / (SELECT COUNT(*) * 1.0 FROM Users) * 100, 2
    ) AS percentage
FROM
    Users u JOIN Register r
    USING(user_id)
GROUP BY
    contest_id
ORDER BY
    percentage DESC, contest_id;
```

## 19. [Queries Quality & Percentage](https://leetcode.com/problems/queries-quality-and-percentage/?envType=study-plan-v2&envId=top-sql-50)


Simple Group by `query_name` is enough for applying aggregate functions.

```sql
-- PostgreSQL

SELECT
    query_name,
    ROUND(AVG(rating/position::DECIMAL), 2) AS quality,
    ROUND(AVG(CASE WHEN (rating < 3) THEN 1 ELSE 0 END) * 100, 2) AS poor_query_percentage
FROM
    Queriess!
WHERE
    query_name IS NOT NULL -- Filtering Null query names!
GROUP BY
    query_name;
```

## 20. [Monthly Transactions - I](https://leetcode.com/problems/monthly-transactions-i/description/?envType=study-plan-v2&envId=top-sql-50)

I prefer to look out on docs for **database specific functions** at the time of need, instead of trying to remember them all.

Here, used a few aggregations over the group.

```sql
SELECT
    TO_CHAR(trans_date, 'YYYY-MM') AS month, -- This func should be explored in docs.
    country,
    COUNT(id) AS trans_count,
    COUNT(CASE WHEN state='approved' THEN 1 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    COALESCE(SUM(CASE WHEN state='approved' THEN amount END), 0) AS approved_total_amount
FROM
    Transactions
GROUP BY
    country, month; -- We can use alias here in some SQLs

```

## 21. [Immediate Food Delivery - II](https://leetcode.com/problems/immediate-food-delivery-ii/?envType=study-plan-v2&envId=top-sql-50)

First, using common table expression to get `order_type` and `first_order_date`, then calculating **percentage** of **Immediate** orders.

```sql
WITH immediate_orders AS (
    SELECT
        customer_id,
        order_date,
        CASE
            WHEN order_date=customer_pref_delivery_date THEN 'immediate' ELSE 'scheduled'
        END AS order_type,
        -- First order per customer!
        MIN(order_date) OVER(PARTITION BY customer_id) AS first_order_date
    FROM    
        Delivery
)

SELECT
    ROUND(
        -- Percentage of immediate orders
        AVG(CASE WHEN (order_type='immediate') THEN 1 ELSE 0 END) * 100, 2
    ) AS immediate_percentage
FROM
    immediate_orders
WHERE
    order_date = first_order_date; -- First Orders!
```


## 22. [Game Play Analysis - IV](https://leetcode.com/problems/game-play-analysis-iv/description/?envType=study-plan-v2&envId=top-sql-50)

Here, getting all users **first log_in date**, then checking how many consecutive \
login dates are there for distinct users. Finally **rounding the fraction**!

```sql
-- Get first log in of every user!!
WITH first_time AS (
    SELECT
        player_id,
        MIN(event_date) AS first_log_in
    FROM
        Activity
    GROUP BY
        player_id
)

-- Fraction of atleast first 2 consecutive plays!
SELECT
    ROUND(
        COUNT(*) FILTER(WHERE a.event_date = f.first_log_in + 1) / 
        COUNT(DISTINCT a.player_id)::NUMERIC, 2
    ) AS fraction
FROM
    Activity a JOIN first_time f
    ON a.player_id = f.player_id;
```

#### Questions on `Sorting & Grouping`

## 23. [Number of Unique subjects Taught by Each Teacher](https://leetcode.com/problems/number-of-unique-subjects-taught-by-each-teacher/description/?envType=study-plan-v2&envId=top-sql-50)


```sql
-- Simple Group By is enough here.

SELECT
    teacher_id,
    COUNT(DISTINCT subject_id) AS cnt
FROM
    Teacher
GROUP BY
    teacher_id;
```

## 24. [User Activity for the past 30 days - I](https://leetcode.com/problems/user-activity-for-the-past-30-days-i/description/?envType=study-plan-v2&envId=top-sql-50)

Filtering by dates first, to get Activities under 30 days, \
then grouping based on dates, that gives us active users each day!!

```sql
-- Write your PostgreSQL query statement below
SELECT
    activity_date AS day,
    COUNT(DISTINCT user_id) AS active_users
FROM
    Activity
WHERE
    -- All activities, under 30 days...
    DATE('2019-07-27') - activity_date BETWEEN 0 AND 29
GROUP BY
    activity_date
ORDER BY
    day;
```

## 25. [Product Sales Analysis - III](https://leetcode.com/problems/product-sales-analysis-iii/description/?envType=study-plan-v2&envId=top-sql-50)

**Solution 1:** Finding first_year for every product, then joining with `Sales` Table, to get the answer. ***(my first solution)***

```sql
SELECT
    s.product_id,
    f.first_year,
    s.quantity,
    s.price
FROM
    (
        -- Subquery to fetch first_year of every Product
        SELECT DISTINCT
            product_id,
            MIN(year) AS first_year
        FROM
            Sales
        GROUP BY
            product_id
    ) AS f JOIN Sales AS s
    ON f.product_id=s.product_id AND f.first_year = s.year;
```

**Solution 2:** Without Joining, we can filter pairs in Subqueries using `WHERE + IN`. This solution is easy, but slower to execute!

```sql
SELECT
    product_id,
    year AS first_year,
    quantity,
    price
FROM
    Sales
WHERE
    (product_id, year) IN (
        -- Subquery to fetch first_year of every Product
        SELECT DISTINCT
            product_id,
            MIN(year) AS first_year
        FROM
            Sales
        GROUP BY
            product_id
    )
```

## 26. [Classes More Than 5 Students](https://leetcode.com/problems/classes-more-than-5-students/description/?envType=study-plan-v2&envId=top-sql-50)

Filtering Groups with `HAVING` Clause.

```sql
SELECT
    class
FROM
    Courses
GROUP BY
    class
HAVING
    COUNT(student) >= 5; -- Filtering Groups (Classes)
```


## 27. [Find Followers Count](https://leetcode.com/problems/find-followers-count/description/?envType=study-plan-v2&envId=top-sql-50)

Simply, Grouping and Ordering.

```sql
SELECT
    user_id,
    COUNT(follower_id) AS followers_count
FROM
    Followers
GROUP BY
    user_id
ORDER BY
    user_id;
```

## 28. [Biggest Single Number](https://leetcode.com/problems/biggest-single-number/description/?envType=study-plan-v2&envId=top-sql-50)

```sql
SELECT
    MAX(num) AS num
FROM
    (
        SELECT
        num
        FROM
            MyNumbers
        GROUP BY
            num
        HAVING
            COUNT(*) = 1
    ) AS t;
```

## 29. [Customers Who Bought All Products](https://leetcode.com/problems/customers-who-bought-all-products/?envType=study-plan-v2&envId=top-sql-50)


```sql
-- Write your PostgreSQL query statement below

SELECT
    customer_id
FROM
    Customer
GROUP BY
    customer_id
HAVING
    COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product)
```

#### Questions on `Advanced Select and Joins`

## 30. [The Number of Employees Which Report to Each Employee](https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/?envType=study-plan-v2&envId=top-sql-50)

Simply Joining the Table with itself `(Self Join)`, grouping it on managers, then selecting the aggregated results !!

```sql
SELECT
    m.employee_id,
    m.name,
    -- Aggregations on manager's employees.
    COUNT(e.employee_id) AS reports_count,
    ROUND(AVG(e.age)) AS average_age
FROM
    Employees e JOIN Employees m
    ON e.reports_to = m.employee_id
GROUP BY
    m.employee_id, m.name -- Grouping on both
ORDER BY
    1;f
```

## 31. [Primary Department for Each Employee](https://leetcode.com/problems/primary-department-for-each-employee/description/?envType=study-plan-v2&envId=top-sql-50)

**Solution 1:** Using UNION ALL, a simple solution.

```sql
SELECT employee_id, department_id
FROM Employee
WHERE primary_flag = 'Y'

UNION ALL

SELECT employee_id, SUM(department_id)
FROM Employee
GROUP BY employee_id
HAVING COUNT(*) = 1;
```

**Solution 2:** But we need to learn Advanced Joins, so let's solve using `Joins`

```sql
SELECT employee_id, department_id
FROM
    Employee e1 JOIN (
        -- Joining department counts!
        SELECT employee_id, COUNT(*) AS cnt
        FROM Employee
        GROUP BY employee_id
    ) USING(employee_id)
WHERE
    primary_flag = 'Y' OR cnt=1;
```

## 32. [Triangle Judgement](https://leetcode.com/problems/triangle-judgement/description/?envType=study-plan-v2&envId=top-sql-50)

Using the **Triangle Inequality Theorem**, checking sum of any ***2 sides exceeds*** the 3rd side.

```sql
SELECT
    *,
    CASE 
        WHEN x+y+z - GREATEST(x, y, z) > GREATEST(x,y,z) THEN 'Yes' ELSE 'No' 
    END AS triangle
FROM triangle;
``` 


## 33. [Consecutive Numbers](https://leetcode.com/problems/consecutive-numbers/?envType=study-plan-v2&envId=top-sql-50)

**Solution 1:** Joining the table with itself thrice on consecutive id's,
then selecting distinct. This isn't an efficient solution cause of joins!!

```sql
-- Joining table with itself three times...
-- Not so efficient...

SELECT DISTINCT
    l1.num AS ConsecutiveNums
FROM
    Logs l1 JOIN Logs l2 ON l1.id+1 = l2.id 
    JOIN Logs l3 ON l2.id +1 = l3.id
WHERE
    l1.num = l2.num AND l2.num = l3.num;

```

**Solution 2 :** Using `Window Functions` to find consecutive numbers.

```sql
-- Using CTE, calculate previous two nums
WITH consecutive AS (
    SELECT
        id,
        num,
        LAG(num, 1) OVER(ORDER BY id) AS l1,
        LAG(num, 2) OVER(ORDER BY id) AS l2
    FROM
        Logs
)

-- Select Distinct Consecutive Numbers
SELECT DISTINCT
    num AS ConsecutiveNums
FROM
    consecutive
WHERE
    num = l1 and l1 = l2;
```

## 34. [Product Price at a Given Date](https://leetcode.com/problems/product-price-at-a-given-date/description/?envType=study-plan-v2&envId=top-sql-50)


```sql
-- Write your PostgreSQL query statement below
WITH mins AS (
    SELECT
        product_id, MAX(change_date) AS "date"
    FROM
        Products p1
    WHERE
        change_date <= '2019-08-16'
    GROUP BY
        product_id
)

SELECT DISTINCT
    p1.product_id,
    CASE
        WHEN p2.date IS NULL THEN 10 ELSE p1.new_price
    END AS price
FROM
    Products p1 LEFT JOIN mins p2
    ON p1.product_id = p2.product_id
WHERE
    p2.date = p1.change_date OR
    p2.date IS NULL;
```

## 35. [Last Person to Fit in the Bus](https://leetcode.com/problems/last-person-to-fit-in-the-bus/description/?envType=study-plan-v2&envId=top-sql-50)
Using Window functions and then Filtering using Where.
```sql
-- Write your PostgreSQL query statement below
WITH total AS (
    SELECT
        turn,
        weight,
        person_name,
        SUM(weight) OVER(ORDER BY turn) AS running_sum
    FROM
        Queue
)

SELECT person_name
FROM total
WHERE running_sum = (SELECT MAX(running_sum) FROM total WHERE running_sum <=1000);
```

## 36. [Count Salary Categories](https://leetcode.com/problems/count-salary-categories/description/?envType=study-plan-v2&envId=top-sql-50)

I know it's more complex than simple `UNION` statements, but i wanted a different solution!

Using this Nested Query with `UNNEST`, `COALESCE` and `CTEs`.

```sql
WITH categories AS (
    SELECT UNNEST(ARRAY['Low Salary', 'Average Salary', 'High Salary']) as category
),
counts AS (
    SELECT 
        category,
        COUNT(*) AS count
    FROM 
        (
            SELECT 
                account_id,
                CASE 
                    WHEN income < 20000 THEN 'Low Salary'
                    WHEN 20000 <= income AND income <= 50000 THEN 'Average Salary'
                    ELSE 'High Salary'
                END AS category
            FROM 
                Accounts
        ) sub
    GROUP BY 
        category
)

-- Querying on them!
SELECT 
    c.category,
    COALESCE(cnt.count, 0) AS accounts_count
FROM 
    categories c
LEFT JOIN 
    counts cnt
ON c.category = cnt.category
ORDER BY 
    c.category;
```

#### Questions on `Subqueries`

## 37. [Employees Whose Manager Left the Company](https://leetcode.com/problems/employees-whose-manager-left-the-company/?envType=study-plan-v2&envId=top-sql-50)

Joining tables with `Left Join`, then filtering on Conditions.

```sql
-- Write your MySQL query statement below

SELECT
    employee_id
FROM
    Employees
WHERE
    salary < 30000 AND
    manager_id NOT IN (SELECT employee_id FROM Employees) -- Filtering with subquery
ORDER BY
    employee_id;
```


## 38. [Exchange Seats](https://leetcode.com/problems/exchange-seats/?envType=study-plan-v2&envId=top-sql-50)

```sql
SELECT
    CASE
        WHEN MOD(id, 2) = 1 AND id+1 <= (SELECT MAX(id) FROM Seat) THEN id+1
        WHEN MOD(id, 2) = 0 THEN id-1
        ELSE id
    END AS id,
    student
FROM
    Seat
ORDER BY
    id;
```

## 39. [Movie Rating](https://leetcode.com/problems/movie-rating/description/?envType=study-plan-v2&envId=top-sql-50)

**Solution 1:**

Using `UNION ALL` to combine results from multiple queries, Joining & grouping to get the required results.

```sql
(
    -- Most Active user
    SELECT u.name as results
    FROM MovieRating r JOIN Users u
    ON r.user_id = u.user_id
    GROUP BY u.user_id, u.name
    ORDER BY COUNT(movie_id) DESC, u.name
    LIMIT 1
)

UNION ALL

(
    -- Most Rated Movie
    SELECT title AS results
    FROM MovieRating r JOIN Movies m
    ON r.movie_id = m.movie_id
    WHERE TO_CHAR(created_at, 'YYYY-MM') = '2020-02'
    GROUP BY m.movie_id, m.title
    ORDER BY AVG(rating) DESC, title
    LIMIT 1
);
```

## 40. [Restaurant Growth](https://leetcode.com/problems/restaurant-growth/?envType=study-plan-v2&envId=top-sql-50)




**Solution 1:** Using **subqueries** in **Select** statement as this section suggest solutions using subqueries.

```sql
-- Write your PostgreSQL query statement below
WITH total AS (
    SELECT
        visited_on,
        (
            SELECT SUM(amount)
            FROM Customer c2
            WHERE c2.visited_on BETWEEN
            c1.visited_on - 6 AND c1.visited_on
        ) AS amount
        
    FROM Customer c1
    WHERE visited_on >= (SELECT MIN(visited_on) + 6 FROM Customer)
    GROUP BY visited_on
)

SELECT
    visited_on,
    amount,
    ROUND(amount/7.0, 2) AS average_amount
FROM
    total
ORDER BY
    visited_on;
```

**Solution 2:** Using Window Functions, by defining specific windows.


```sql 
WITH aggregated AS (
    SELECT
        visited_on,
        SUM(amount) OVER wnd AS amount,
        DENSE_RANK() OVER wnd AS idx
    FROM
        Customer
    -- Window on entire table
    WINDOW wnd AS (
            ORDER BY visited_on
            RANGE BETWEEN '6 day' PRECEDING AND CURRENT ROW
        )
)

SELECT DISTINCT
    visited_on,
    amount,
    ROUND(amount/7::NUMERIC, 2) AS average_amount
FROM aggregated
WHERE idx > 6
ORDER BY visited_on;
```

## 41. [Friend Requests II: Who Has the Most Friends](https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/?envType=study-plan-v2&envId=top-sql-50)

Counting all occurrences of id's in both ***requesting and accepting*** columns.

```sql
SELECT
    id,
    count(id) as num
FROM 
    (
        select requester_id as id from RequestAccepted 
        union all
        select accepter_id as id from RequestAccepted
    ) AS temp
group by id
order by num desc
limit 1
```

## 42. [Investments in 2016](https://leetcode.com/problems/investments-in-2016/?envType=study-plan-v2&envId=top-sql-50)

Using subqueries for :

- Getting `tiv_2015` that are same for **more than 1** policy holders.
- Getting `lat, lon` that are unique & belongs to only one policy holder.

Then filtering the policy holders who belong to the above data, and calculating final aggregated results.

```sql
-- Write your PostgreSQL query statement below
SELECT
    ROUND(
        SUM(tiv_2016)::NUMERIC, 2
    ) AS tiv_2016
FROM
    Insurance
WHERE
    tiv_2015 IN (
        SELECT tiv_2015
        FROM Insurance
        GROUP BY tiv_2015
        HAVING COUNT(pid) > 1

    ) AND
    (lat,lon) IN (
        SELECT lat, lon
        FROM Insurance
        GROUP BY lat, lon
        HAVING COUNT(*) = 1
    )
```

## 43. [Department Top Three Salaries](https://leetcode.com/problems/department-top-three-salaries/description/?envType=study-plan-v2&envId=top-sql-50)

**Solution 1:**

Using subquery to calculate `ranks` of the employees in their department based on salary, then \
filtering out the employees **with top 3 salaries** in their relative **departments !**

```sql
SELECT
    department,
    employee,
    salary
FROM (
    SELECT
        d.name AS department,
        e.name AS employee,
        e.salary AS salary,
        DENSE_RANK() OVER(PARTITION BY d.name ORDER BY e.salary DESC) AS ranks
    FROM employee e 
    LEFT JOIN department d
    ON e.departmentId =d.id
) AS temp
WHERE ranks <=3
```

**Solution 2:**

Here, writing a **correlated subquery**, that gives count of all **distinct salaries** greater than current \
employee's salary in it's corresponding department.

Then we can filter employees based on their salary position in the department !

```sql
SELECT
    d.name AS Department,
    e1.name as Employee,
    salary
FROM
    Employee e1 JOIN Department d
    ON e1.departmentId = d.id
WHERE
    (
        SELECT COUNT(DISTINCT salary)
        FROM Employee e2
        WHERE e2.departmentId = d.id AND
        e2.salary >= e1.salary
    ) <= 3;
```

### Questions on *Advanced String Functions / Regex / Clause*

## 44. [Fix Names in a Table](https://leetcode.com/problems/fix-names-in-a-table/?envType=study-plan-v2&envId=top-sql-50)

```sql
SELECT
    user_id,
    CONCAT(
        UPPER(SUBSTRING(name, 1, 1)), LOWER(SUBSTRING(name, 2))
        -- UPPER(LEFT(name, 1)), LOWER(RIGHT(name, LENGTH(name)-1)) (Slower)
    ) AS name
FROM
    USERS
ORDER BY
    user_id;
```

## 45. [Patients With a Condition](https://leetcode.com/problems/patients-with-a-condition/description/?envType=study-plan-v2&envId=top-sql-50)

USING `LIKE` for simple pattern matching, we can also use `REGEXP` ***(Mysql)***  or `~` ***(PostgreSQL)*** \
to match **regular expressions**.

```sql
SELECT
    *
FROM
    Patients
WHERE
    conditions LIKE 'DIAB1%' OR -- first condition 
    conditions LIKE '% DIAB1%'; -- any other condition starts with it...
```

## 46. [Delete Duplicate Emails](https://leetcode.com/problems/delete-duplicate-emails/?envType=study-plan-v2&envId=top-sql-50)

Deleting from Person Table.

```sql
DELETE FROM Person
WHERE id IN (
    SELECT p2.id -- p2.id (Avoids MIN id)
    FROM Person p1 JOIN Person p2
    ON p1.email = p2.email AND
    p1.id < p2.id
);
```

## 47. [Second Highest Salary](https://leetcode.com/problems/second-highest-salary/?envType=study-plan-v2&envId=top-sql-50)

Smaller than ***max*** salary is the ***2nd max salary***.

```sql
SELECT
    MAX(salary) AS SecondHighestSalary
FROM
    Employee
WHERE
    salary < (SELECT MAX(salary) FROM Employee);
```

## 48. [Group Sold Products By The Date](https://leetcode.com/problems/group-sold-products-by-the-date/description/?envType=study-plan-v2&envId=top-sql-50)

Grouping as obvious, but then using `STRING_AGG` function to aggregate all distinct products. \
In MySQL, it's alternative is `GROUP_CONCAT`.

```sql
SELECT
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    STRING_AGG(DISTINCT product, ',' ORDER BY product) AS products -- PgSQL
FROM
    Activities
GROUP BY
    sell_date
ORDER BY
    sell_date;
```

## 49. [List the Products Ordered in a Period](https://leetcode.com/problems/list-the-products-ordered-in-a-period/description/?envType=study-plan-v2&envId=top-sql-50)

Using `To_CHAR` to extract date in a specific format. Then aggregating data on **groups of each product**. \
There are different functions in different Databases, like MYSQL has DATE_FORMAT

```sql
SELECT
    product_name,
    SUM(unit) AS unit
FROM
    Products p JOIN Orders o
    ON p.product_id = o.product_id
WHERE
    TO_CHAR(order_date, 'YYYY-MM') = '2020-02'
GROUP BY
    p.product_id, product_name
HAVING
    SUM(unit) >= 100;
```


## 50. [Find Users With Valid E-Mails](https://leetcode.com/problems/find-users-with-valid-e-mails/?envType=study-plan-v2&envId=top-sql-50)

Using regex match in PostgreSQL, `~` will match for **case-sensitive RegEx patterns**.

```sql
SELECT
    *
FROM
    Users
WHERE
    mail ~ '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\.com$'
```