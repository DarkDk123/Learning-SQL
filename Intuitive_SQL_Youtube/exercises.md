# SQL Exercises

We have Learned a lot till now, this SQL exercises are categorised based & ordered on the concepts learned.

This exercises can be solved after completion of each section or at the last (As i'm doing it!).


## [PostgreSQL Exercises](https://pgexercises.com/)

It is a good and simple platform to exercise our **SQL Skills**.

We'll complete the exercises there, as the following order!

1. [Basic Exercises](https://pgexercises.com/questions/basic/)
2. [Joins & Subqueries](https://pgexercises.com/questions/joins/)
3. [Aggregations Part 1 & 2](https://pgexercises.com/questions/aggregates/)


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

### Joins & Subqueries

13. Retrieve the start times of members' bookings

    > How can you produce a list of the start times for bookings by members named 'David Farrell'? 

    ```sql
    SELECT
	    b.starttime
    FROM
    	cd.bookings b INNER JOIN cd.members m
    	ON b.memid = m.memid
    WHERE
    	concat(m.firstname, ' ', m.surname) = 'David Farrell';
    ```

14. Work out the start times of bookings for tennis courts 

    > How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.


    ```sql

        SELECT
        	bs.starttime as start, fs.name
        FROM
        	cd.bookings bs INNER JOIN
        	cd.facilities fs
        ON
            bs.facid = fs.facid
        WHERE
        	date_trunc('day', bs.starttime) = '2012-09-21' -- Or use DATE() Function!
        	AND fs.name LIKE 'Tennis Court %'
        ORDER BY bs.starttime;
        	
    ```


15. Produce a list of all members who have recommended another member

    > How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname). 


    ```sql

        SELECT
        	DISTINCT ref.firstname, ref.surname
        FROM
        	cd.members AS mems INNER JOIN
        	cd.members AS ref
        ON mems.recommendedby = ref.memid
        ORDER BY
        	surname, firstname;
        	
    ```

16. Produce a list of all members, along with their recommender
    
    > How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname). 

    ```sql
    SELECT
    	mems.firstname AS memfname,
    	mems.surname AS memsname,
    	ref.firstname AS recfname,
    	ref.surname AS recsname
    FROM
    	cd.members mems LEFT JOIN
    	cd.members ref

    ON	mems.recommendedby = ref.memid
    ORDER BY memsname, memfname;
    ```


17. Produce a list of all members who have used a tennis court.

    > How can you produce a list of all members who have used a tennis court? Include in your output the name of the court, and the name of the member formatted as a single column. Ensure no duplicate data, and order by the member name followed by the facility name. 

    ```sql

    SELECT
    	DISTINCT CONCAT(mems.firstname, ' ', mems.surname) AS member,
    	fc.name as facility
    FROM
    	cd.members mems JOIN
    	cd.bookings bs 
    ON 	mems.memid = bs.memid

    JOIN cd.facilities fc
    ON bs.facid = fc.facid

    WHERE
    	fc.name LIKE 'Tennis Court%'
    ORDER BY
    	member, facility;	

    ```

18. Produce a list of costly bookings

    > How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user is always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. Order by descending cost, and do not use any subqueries.

    `This was really tough!! I love ❣️ this feeling!!`

    `At first, in misunderstanding, i did it as there isn't a member account for guest! using multiple "CASE" clauses`.

    ```sql

    SELECT
    	(mems.firstname || ' ' || mems.surname) AS member,
    	fc.name AS facility,
        CASE
    		WHEN bs.memid = 0 THEN fc.guestcost * bs.slots
    		ELSE fc.membercost * bs.slots
    	END AS cost
    FROM
    	cd.members mems JOIN
    	cd.bookings bs
    ON mems.memid = bs.memid
    
    JOIN cd.facilities fc
    ON bs.facid = fc.facid
    
    WHERE 
    	DATE(bs.starttime) = '2012-09-14' AND (
    	  (mems.memid = 0 AND fc.guestcost * bs.slots > 30) OR
    	  (mems.memid != 0 AND fc.membercost * bs.slots > 30)
    	)
    ORDER BY
    	cost DESC;
    ```



19. Produce a list of all members, along with their recommender, using no joins. 

    > How can you output a list of all members, including the individual who recommended them (if any), without using any joins? Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered. 

    ```sql

    SELECT DISTINCT
    	(firstname || ' ' || surname) AS member,
    	( -- A correlated sub-query!
    	 SELECT
    	  	firstname || ' ' || surname AS recommender
    	  FROM
    	  	cd.members ref
    	  WHERE ref.memid = members.recommendedby
    	)
    FROM
    	cd.members;
    ```

20. Produce a list of costly bookings, using a subquery

    > The `Produce a list of costly bookings (exe:18)` exercise contained some messy logic: we had to calculate the booking cost in both the WHERE clause and the CASE statement. Try to simplify this calculation using subqueries. For reference, the question was:



    ```sql

    -- Using Common Table Expression instead of a subquery!
    WITH all_bookings AS (
      SELECT
    	  mems.firstname || ' ' || mems.surname AS member,
    	  fc.name as facility,
    	  bs.slots * (
    		CASE
    		  WHEN mems.memid = 0 THEN fc.guestcost
    		  ELSE fc.membercost
    		END
    	   ) AS cost
      FROM 
    	  cd.members mems JOIN
    	  cd.bookings bs
    	  ON mems.memid = bs.memid
    	  JOIN cd.facilities fc
    	  ON bs.facid = fc.facid
      WHERE
    	  DATE(bs.starttime) = '2012-09-14'
    )

    -- filtering expensive bookings
    SELECT *
    FROM all_bookings
    WHERE cost > 30;
    ```
