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

### Aggregations - Part 1

21. Count the number of facilities 

    > For our first foray into aggregates, we're going to stick to something simple. We want to know how many facilities exist - simply produce a total count. 



    ```sql
    SELECT COUNT(*)
    FROM cd.facilities;
    ```


22. Count the number of expensive facilities

    > Produce a count of the number of facilities that have a cost to guests of 10 or more. 

    ```sql
    SELECT
    	COUNT(*)
    FROM
    	cd.facilities
    WHERE
    	guestcost >= 10;
    ```

23. Count the number of recommendations each member makes. 

    > Produce a count of the number of recommendations each member has made. Order by member ID.

    ```sql

    SELECT
	    ref.memid AS recommendedBy,
    	COUNT(*) as "count"
    FROM
    	cd.members mems JOIN
    	cd.members ref
    	ON mems.recommendedby = ref.memid
    GROUP BY
    	ref.memid
    ORDER BY
    	recommendedBy;
    
    -- Joining isn't required, we can also group by recommendedBy only, while dropping NULL rows!
    ```

24. List the total slots booked per facility

    > Produce a list of the total number of slots booked per facility. For now, just produce an output table consisting of facility id and slots, sorted by facility id.

    ```sql
    SELECT
    	facid,
    	SUM(slots) AS "Total Slots"
    FROM
    	cd.bookings
    GROUP BY
    	facid
    ORDER BY
    	facid;
    ```

25. List the total slots booked per facility in a given month.

    > Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots. 

    ```sql
    SELECT
     	facid,
     	SUM(slots) AS "Total Slots"
     FROM
     	cd.bookings
     WHERE
     	TO_CHAR(starttime, 'YYYY-MM') = '2012-09'
     GROUP BY
     	facid
     ORDER BY "Total Slots";
    ```

26. List the total slots booked per facility per month

    > Produce a list of the total number of slots booked per facility per month in the year of 2012. Produce an output table consisting of facility id and slots, sorted by the id and month. 

    ```sql
    SELECT
    	facid,
    	EXTRACT(MONTH FROM starttime) AS month,
    	SUM(slots) AS "Total Slots"
    FROM
    	cd.bookings
    WHERE
    	EXTRACT(YEAR FROM starttime) = 2012
    GROUP BY
    	facid, EXTRACT(MONTH FROM starttime) -- OR "month"
    ORDER BY
    	facid, month;

    ```

27. Find the count of members who have made at least one booking

    >  Find the total number of members (including guests) who have made at least one booking. 

    ```sql
    SELECT
    	COUNT(DISTINCT memid)
    FROM
    	cd.bookings;

    ```

28. List facilities with more than 1000 slots booked

    >  Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and slots, sorted by facility id. 

    ```sql
    SELECT
    	facid,
    	SUM(slots) as "Total Slots"
    FROM
    	cd.bookings
    GROUP BY
    	facid
    HAVING
    	SUM(slots) > 1000
    ORDER BY
    	facid;

    ```

29. Find the total revenue of each facility

    > Produce a list of facilities along with their total revenue. The output table should consist of facility name and revenue, sorted by revenue. Remember that there's a different cost for guests and members! 

    ```sql
    SELECT
    	fc.name AS name, -- Selectable because it's as unique as facid!
    	SUM(
    	  bs.slots * (
    		CASE
    			WHEN bs.memid = 0 THEN fc.guestcost
    			ELSE fc.membercost
    		END
    	    )
    	) AS revenue
    FROM
    	cd.bookings bs JOIN
    	cd.facilities fc
    	ON bs.facid = fc.facid
    GROUP BY
    	fc.facid -- fc.name is also applicable!
    ORDER BY
    	revenue;
    ```

30. Find facilities with a total revenue less than 1000

    > Produce a list of facilities with a total revenue less than 1000. Produce an output table consisting of facility name and revenue, sorted by revenue. Remember that there's a different cost for guests and members! 

    ```sql
    -- Create a Common Table!
    WITH revenues AS (
       SELECT
        	fc.name AS name, -- Selectable because it's as unique as facid!
        	SUM(
        	  bs.slots * (
        		CASE
        			WHEN bs.memid = 0 THEN fc.guestcost
        			ELSE fc.membercost
        		END
        		)
        	) AS revenue
        FROM
        	cd.bookings bs JOIN
        	cd.facilities fc
        	ON bs.facid = fc.facid
        GROUP BY
        	fc.facid -- fc.name is also applicable!
        ORDER BY
        	revenue
    )

    -- Selecting from revenues.
    SELECT * FROM revenues WHERE revenue < 1000;
    ```

31. Output the facility id that has the highest number of slots booked

    > Output the facility id that has the highest number of slots booked. For bonus points, try a version without a LIMIT clause. This version will probably look messy! 

    ```sql
    SELECT
    	facid, SUM(slots) AS "Total Slots"
    FROM
    	cd.bookings
    GROUP BY
    	facid
    ORDER BY
    	"Total Slots" DESC
    LIMIT 1;

    -- This is good, but in a tie, it gives only one result!
    -- Now, without using `Limit` clause

    WITH total_slots AS (
      SELECT
    	facid, SUM(slots) AS "Total Slots"
      FROM
    	  cd.bookings
      GROUP BY
    	  facid
      ORDER BY
    	  "Total Slots" DESC
    )

    
    -- Querying on above table...
    SELECT *
    FROM total_slots
    WHERE "Total Slots" = (SELECT MAX("Total Slots") FROM total_slots);
    ```

    `Look 👀, Just how perfect a "Common Table Expression" feels like!!`

32. List the total slots booked per facility per month, part 2

    > `Produce a list of the total number of slots booked per facility per month in the year of 2012.` In this version, include output rows containing totals for all months per facility, and a total for all months for all facilities. The output table should consist of facility id, month and slots, sorted by the id and month. When calculating the aggregated values for all months and all facids, return null values in the month and facid columns. 

    ```sql
    -- First answer in our mind can be concatenating multiple queries using "UNION ALL"
    -- But, it looks complex! let's see other solutions

    SELECT
    	facid,
    	EXTRACT(MONTH FROM starttime) AS month,
    	SUM(slots) AS slots
    FROM
    	cd.bookings
    WHERE
    	EXTRACT(YEAR FROM starttime) = 2012
    GROUP BY
        -- ROLLUP is the catch, it generates multiple grouping sets.
    	ROLLUP(facid, EXTRACT(MONTH FROM starttime)) -- OR "month"
    ORDER BY
    	facid, month;


    -- I was familiar with the grouping set syntax like!
    -- Replacing GROUP BY with this:
    GROUP BY GROUPING SETS(
    	(facid, EXTRACT(MONTH FROM starttime)), -- OR "month"
      	(facid),
      	()
     ) -- It's equal to "ROLLUP(facid, month)"
    ```

33. List the total hours booked per named facility 

    > Produce a list of the total number of hours booked per facility, remembering that a slot lasts half an hour. The output table should consist of the facility id, name, and hours booked, sorted by facility id. Try formatting the hours to two decimal places. 

    ```sql
    
    SELECT
    	fc.facid, fc.name,
    	ROUND(SUM(slots)/2.0, 2) AS "Total Hours"
    FROM
    	cd.bookings bs JOIN
    	cd.facilities fc
    	ON bs.facid = fc.facid
    GROUP BY
    	fc.facid, fc.name
    ORDER BY
    	fc.facid;

    ```

34. List each member's first booking after September 1st 2012

    > Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID. 

    ```sql
    SELECT
    	mems.surname,
    	mems.firstname,
    	mems.memid,
    	MIN(bs.starttime) AS starttime
    FROM
    	cd.members mems JOIN
    	cd.bookings bs
    	ON mems.memid = bs.memid
    WHERE
    	bs.starttime > '2012-09-01'
    GROUP BY
    	mems.memid, mems.surname, mems.firstname -- These are equally common!
    ORDER BY
    	memid;
    ```

### Aggregations - Part 2

35. Produce a list of member names, with each row containing the total member count 

    > Produce a list of member names, with each row containing the total member count. Order by join date, and include guest members

    ```sql
    SELECT
    	COUNT(*) OVER(),
    	firstname,
    	surname

    FROM
    	cd.members
    ORDER BY
    	joindate;
    ```

36. Produce a numbered list of members

    > Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining. Remember that member IDs are not guaranteed to be sequential. 

    ```sql
    SELECT
    	ROW_NUMBER() OVER(ORDER BY joindate),
    	firstname, surname
    FROM
    	cd.members
    ORDER BY
    	joindate;
    ```

37. Output the facility id that has the highest number of slots booked, again 

    > Output the facility id that has the highest number of slots booked. Ensure that in the event of a tie, all tieing results get output.

    ```sql
    -- Using the same solution from above (Exercise:31)
    WITH total_slots AS (
      SELECT
    	facid, SUM(slots) AS "Total Slots"
      FROM
    	  cd.bookings
      GROUP BY
    	  facid
      ORDER BY
    	  "Total Slots" DESC
    )


    -- Querying on above table...
    SELECT *
    FROM total_slots
    WHERE "Total Slots" = (SELECT MAX("Total Slots") FROM total_slots);
    ```

38. Rank members by (rounded) hours used.

    > Produce a list of members (including guests), along with the number of hours they've booked in facilities, rounded to the nearest ten hours. Rank them by this rounded figure, producing output of first name, surname, rounded hours, rank. Sort by rank, surname, and first name. 

    ```sql
    SELECT
    	mems.firstname, mems.surname,
    	ROUND(SUM(bs.slots)/2, -1) AS hours,
    	RANK() OVER(ORDER BY ROUND(SUM(bs.slots)/2, -1) DESC) AS rank -- Rank rows!
    	
    FROM
    	cd.members mems JOIN
    	cd.bookings bs
    	ON mems.memid = bs.memid
    GROUP BY
    	mems.firstname, mems.surname
    ORDER BY
    	rank, surname, firstname;
    ```

39. Find the top three revenue generating facilities

    > Produce a list of the top three revenue generating facilities (including ties). Output facility name and rank, sorted by rank and facility name. 

    ```sql
    WITH top_facilities AS (
      SELECT
    	fc.name AS name,
    	RANK() OVER(ORDER BY SUM(slots * 
    							 CASE
    							 	WHEN bs.memid=0 THEN fc.guestcost
    							 	ELSE fc.membercost
    							 END
    							) DESC) AS rank
    	  
      FROM
    	  cd.facilities fc JOIN
    	  cd.bookings bs
    	  ON fc.facid = bs.facid
      GROUP BY
    	  fc.name
      ORDER BY
    	  rank, name
    )


    -- Filtering Top 3 facilities
    SELECT * FROM top_facilities WHERE rank <= 3;
    ```

40. Classify facilities by value

    > Classify facilities into equally sized groups of high, average, and low based on their revenue. Order by classification and facility name. 

    ```sql
    WITH fac_class AS (
      SELECT
    	fc.name,
    	NTILE(3) OVER(ORDER BY SUM(slots * 
        							 CASE
        							 	WHEN bs.memid=0 THEN fc.guestcost
        							 	ELSE fc.membercost
        							 END
        							) DESC) AS revenue
      FROM
    	  cd.facilities fc JOIN
    	  cd.bookings bs
    	  ON fc.facid = bs.facid
      
      GROUP BY
    	  fc.name
      ORDER BY
    	  revenue, name
    )


    SELECT
    	name,
    	CASE
    		WHEN revenue = 1 THEN 'high'
    		WHEN revenue = 2 THEN 'average'
    		ELSE 'low'
    	END AS revenue

    FROM
    	fac_class;
    ```

41. Calculate the payback time for each facility

    > Based on the 3 complete months of data so far, calculate the amount of time each facility will take to repay its cost of ownership. Remember to take into account ongoing monthly maintenance. Output facility name and payback time in months, order by facility name. Don't worry about differences in month lengths, we're only looking for a rough value here! 

    ```sql
    -- monthly_revenue = (slots*cost) For the Month
    -- monthly_meaintenance = cost to keep it running
    -- initial_outlay = Cost of ownership for each facility
    -- monthly_profit = monthly_revenue - monthly_maintenance

    -- payback_time = initial_outlay/monthly_profit


    -- Let's start with profit statistics
    WITH profit_data AS (
      SELECT
    	fc.facid,
    	fc.name,
    	SUM(bs.slots *
    	  	 CASE
    	  	 	 WHEN bs.memid=0 THEN fc.guestcost
    		 	 ELSE fc.membercost
    	  	 END)/COUNT(DISTINCT EXTRACT(MONTH FROM starttime)) - monthlymaintenance AS avg_monthly_profit,
    	COUNT(DISTINCT EXTRACT(MONTH FROM starttime)) AS total_months,
    	fc.initialoutlay AS buy_price
      FROM
    	  cd.bookings bs JOIN
    	  cd.facilities fc
    	  ON bs.facid = fc.facid
      WHERE
      	EXTRACT(YEAR FROM starttime) = 2012 -- dropping 2013
      GROUP BY
    	  fc.facid, fc.name, fc.initialoutlay
    )


    -- Get what we need!
    SELECT
    	name,
    	buy_price/avg_monthly_profit AS months
    FROM
    	profit_data
    ORDER BY
    	name;


    ```

42. Calculate a rolling average of total revenue

    > For each day in August 2012, calculate a rolling average of total revenue over the previous 15 days. Output should contain date and revenue columns, sorted by the date. Remember to account for the possibility of a day having zero revenue. This one's a bit tough, so don't be afraid to check out the hint! 

    ```sql
    WITH rolling_avg_revenue AS (
      SELECT
    	DATE(starttime) as date,
      	
      -- Rolling AVG revenue over 15 rows window!
    	AVG(SUM(bs.slots *
        	  	 CASE
        	  	 	 WHEN bs.memid=0 THEN fc.guestcost
        		 	 ELSE fc.membercost
        	  	 END)) OVER(ORDER BY DATE(starttime)
    						ROWS BETWEEN 14 PRECEDING AND CURRENT ROW
    					   ) as revenue
      FROM
    	  cd.bookings bs JOIN
    	  cd.facilities fc
    	  ON bs.facid = fc.facid
      GROUP BY
    	  DATE(starttime)
    )


    -- Filter for August 2012
    SELECT *
    FROM rolling_avg_revenue
    WHERE TO_CHAR(date, 'YYYY-MM') = '2012-08';
    ```