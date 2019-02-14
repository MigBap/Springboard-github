/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
SELECT name
FROM Facilities
WHERE membercost > 0


/* Q2: How many facilities do not charge a fee to members? */
SELECT COUNT(*)
FROM Facilities
WHERE membercost = 0


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost > 0
AND membercost < (0.2 * monthlymaintenance)


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT *
FROM Facilities
WHERE facid IN (1, 5)


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
SELECT name, monthlymaintenance,
        CASE WHEN monthlymaintenance > 100 THEN 'expensive'
        ELSE 'cheap' END AS 'cheap_or_expensive'
FROM Facilities


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
SELECT firstname, surname
FROM Members
WHERE joindate = (SELECT MAX(joindate) FROM Members)



/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT facilities.name AS facility_name,
        concat(members.firstname, ' ', members.surname) AS member_name
FROM Bookings bookings
JOIN Facilities facilities ON bookings.facid = facilities.facid
JOIN Members members ON bookings.memid = members.memid
WHERE facilities.name LIKE 'Tennis Court%'
GROUP BY facility_name, member_name
ORDER BY member_name


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
SELECT facilities.name AS facility_name,
        CASE WHEN members.memid = 0 THEN 'GUEST'
        ELSE concat(members.firstname, ' ', members.surname) END AS name,
        CASE WHEN members.memid = 0 THEN facilities.guestcost * bookings.slots
        ELSE facilities.membercost * bookings.slots END AS respective_cost   
FROM Bookings bookings
JOIN Facilities facilities ON bookings.facid = facilities.facid
JOIN Members members ON bookings.memid = members.memid
WHERE bookings.starttime LIKE '2012-09-14%'
HAVING respective_cost > 30
ORDER BY respective_cost DESC


/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT sub.facility_name,
        sub.name,
        sub.respective_cost
    FROM(
          SELECT facilities.name AS facility_name,
                  CASE WHEN members.memid = 0 THEN 'GUEST'
                  ELSE concat(members.firstname, ' ', members.surname) END AS name,
                  CASE WHEN members.memid = 0 THEN facilities.guestcost * bookings.slots
                  ELSE facilities.membercost * bookings.slots END AS respective_cost   
          FROM Bookings bookings
          JOIN Facilities facilities ON bookings.facid = facilities.facid
          JOIN Members members ON bookings.memid = members.memid
          WHERE bookings.starttime LIKE '2012-09-14%'
         ) sub
HAVING respective_cost > 30
ORDER BY respective_cost DESC



/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
SELECT sub.facility_name,
        sub.revenue
    FROM(
          SELECT facilities.name AS facility_name,                
          CASE WHEN bookings.memid = 0 THEN facilities.guestcost * bookings.slots 
          ELSE facilities.membercost * bookings.slots END AS revenue                         
          FROM Bookings bookings
          JOIN Facilities facilities ON bookings.facid = facilities.facid 
          GROUP BY facility_name               
         ) sub
WHERE revenue < 1000
ORDER BY revenue DESC   













SELECT sub.facility_name,
        sub.respective_cost, 
        sub.nr_facid_0,
        sub.nr_facid_1,
        sub.nr_facid_2,
        sub.nr_facid_3,
        sub.nr_facid_4,
        sub.nr_facid_5,
        sub.nr_facid_6,
        sub.nr_facid_7,
        sub.nr_facid_8
    FROM(
          SELECT facilities.name AS facility_name,
                  CASE WHEN bookings.memid = 0 THEN facilities.guestcost
                  ELSE facilities.membercost END AS respective_cost,
                                           
                  CASE WHEN bookings.facid = 0 THEN COUNT(bookings.facid = 0) END AS nr_facid_0,
                  CASE WHEN bookings.facid = 1 THEN COUNT(bookings.facid = 1) END AS nr_facid_1,
                  CASE WHEN bookings.facid = 2 THEN COUNT(bookings.facid = 2) END AS nr_facid_2,
                  CASE WHEN bookings.facid = 3 THEN COUNT(bookings.facid = 3) END AS nr_facid_3,
                  CASE WHEN bookings.facid = 4 THEN COUNT(bookings.facid = 4) END AS nr_facid_4,
                  CASE WHEN bookings.facid = 5 THEN COUNT(bookings.facid = 5) END AS nr_facid_5,
                  CASE WHEN bookings.facid = 6 THEN COUNT(bookings.facid = 6) END AS nr_facid_6,
                  CASE WHEN bookings.facid = 7 THEN COUNT(bookings.facid = 7) END AS nr_facid_7,
                  CASE WHEN bookings.facid = 8 THEN COUNT(bookings.facid = 8) END AS nr_facid_8
                                                                 
          FROM Bookings bookings
          JOIN Facilities facilities ON bookings.facid = facilities.facid 
          ) sub                              
WHERE revenue < 1000
GROUP BY facility_name
ORDER BY revenue DESC   
        





