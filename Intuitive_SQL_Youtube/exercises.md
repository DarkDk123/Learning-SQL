# SQL Exercises

We have Learned a lot till now, this SQL exercises are categorised based & ordered on the concepts learned.

This exercises can be solved after completion of each section or at the last (As i'm doing it!).


## [PostgreSQL Exercises](https://pgexercises.com/)

It is a good and simple platform to exercise our **SQL Skills**.

We'll complete the exercises there, as the following order!

1. [Basic Exercises](https://pgexercises.com/questions/basic/)
2. [Joins & Subqueries]()
3. [Aggregations Part 1 & 2]()


## Let's get started : 

###  Basic Exercises

1.  Retrieve everything from a table

    > How can you retrieve all the information from the cd.facilities table? 
  
    ```sql 
    SELECT * FROM cd.facilities;
    ```


2. Retrieve specific columns from a table

    > You want to print out a list of all of the facilities and their cost to members. How would you retrieve a list of only facility names and costs? 

   ```sql
   SELECT name, membercost
   FROM cd.facilities;
   ```

3. Control which rows are retrieved

    > How can you produce a list of facilities that charge a fee to members? 

   ```sql
   SELECT *
   FROM cd.facilities
   WHERE membercost > 0;
   ```

4. Control which rows are retrieved - Part 2

    > How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in question. 

   ```sql
   SELECT facid, name, membercost, monthlymaintenance
   FROM cd.facilities
   WHERE membercost > 0 AND membercost < monthlymaintenance/50;
   ```

5. Basic string searches

    > How can you produce a list of all facilities with the word **'Tennis'** in their name? 

   ```sql
   SELECT * 
   FROM cd.facilities
   WHERE name LIKE '%Tennis%';
   ```

6. Matching against multiple possible values

    > How can you retrieve the details of facilities with `ID` **1** and **5**? Try to do it **without** using the `OR` operator. 

   ```sql
   SELECT *
   FROM cd.facilities
   WHERE facid IN (1, 5);
   ```

7. Classify results into buckets

    > How can you classify facilities as 'expensive' or 'cheap' based on whether their `monthlymaintenance` cost is greater than 100?

   ```sql
   SELECT
       name,
       CASE
           WHEN monthlymaintenance > 100 THEN 'expensive'
           ELSE 'cheap'
       END AS cost
   FROM
       cd.facilities;
   ```

8. Working with dates

    > How can you retrieve the `memid`, `surname`, `firstname`, and `joindate` of members who joined on or after September 1, 2012?

   ```sql
   SELECT 
       memid, surname, firstname, joindate
   FROM
       cd.members
   WHERE joindate >= '2012-09-01';
   ```

9. Removing duplicates, and ordering results

    > How can you retrieve distinct surnames of members, order them alphabetically, and limit the result to the first 10 surnames?

   ```sql
   SELECT DISTINCT surname
   FROM cd.members
   ORDER BY surname
   LIMIT 10;
   ```

10. Combining results from multiple queries

    > You, for some reason, want a combined list of all surnames and all facility names. Yes, this is a contrived example :-). Produce that list! 

    ```sql
    SELECT surname AS name
    FROM cd.members
    UNION DISTINCT
    SELECT name
    FROM cd.facilities;
    ```

11. Simple aggregation

    > You'd like to get the signup date of your last member. How can you retrieve this information?

    ```sql
    SELECT MAX(joindate) AS latest
    FROM cd.members;
    ```

12. More aggregation

    > You'd like to get the first and last name of the last member(s) who signed up - not just the date. How can you do that?

    ```sql
    SELECT 
        firstname, surname, joindate
    FROM
        cd.members
    WHERE
        joindate = (SELECT MAX(joindate) FROM cd.members);
    ```

