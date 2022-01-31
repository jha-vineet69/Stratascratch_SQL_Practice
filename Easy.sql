----------------------------------------- Day 1 ----------------------------------------------
-- Apartments in New York City and Harlem
-- Find the search details of 50 apartment searches the Harlem neighborhood of New York City.
 SELECT * 
 FROM airbnb_search_details
 WHERE neighbourhood = 'Harlem';

-- Find all searches for accommodations with an equal number of bedrooms bathrooms
-- Find all searches for accommodations  WHERE the number of bedrooms is equal to the number of bathrooms.
SELECT * 
FROM airbnb_search_details
WHERE bedrooms = bathrooms;

-- Number Of Bathrooms And Bedrooms
-- Find the average number of bathrooms and bedrooms for each city’s property types. Output the result along with the city name and the property type.
SELECT AVG(bathrooms) AS avg_bathrooms, AVG(bedrooms) AS avg_bedrooms, city, property_type
FROM airbnb_search_details
GROUP BY city, property_type;

SELECT DISTINCT city, property_type, 
AVG(bathrooms) OVER(PARTITION BY city, property_type) AS average_bath,
AVG(bedrooms) OVER(PARTITION BY city, property_type) AS average_bed
FROM airbnb_search_details;

-- Cheapest Properties
-- Find the price of the cheapest property for every city
SELECT DISTINCT(city), MIN(price) OVER(PARTITION BY city) AS Cheapest_Property
FROM airbnb_search_details;

SELECT city, MIN(price) AS Cheapest_Property
FROM airbnb_search_details
GROUP BY city; 

-- 3 Bed Minimum
-- Find the average number of beds in each neighborhood that has at least 3 beds in total.
-- Output results along with the neighborhood name and sort the results based on the number of average beds in descending order.
SELECT neighbourhood, AVG(beds) AS avg_beds
FROM airbnb_search_details
GROUP BY neighbourhood
HAVING SUM(beds)>=3
ORDER BY avg_beds DESC;

-- Find the average score for grades A, B, and C
-- Find the average score for grades A, B, and C.
-- Output the results along with the corresponding grade (ex: 'A', AVG(score)).
SELECT grade, AVG(score) AS Avg_Score
FROM los_angeles_restaurant_health_inspections
GROUP BY grade
ORDER BY grade;

-- 'BAKERY' Owned Facilities
-- Find the owner_name and the pe_description of facilities owned by 'BAKERY'  WHERE low-risk cases have been reported.
SELECT DISTINCT(owner_name), pe_description 
FROM los_angeles_restaurant_health_inspections
WHERE owner_name LIKE '%BAKERY%' and pe_description like '%LOW RISK%';

-- Number Of Unique Facilities And Inspections Per Municipality
-- Count the number of unique facilities per municipality zip code along with the number of inspections. 
-- Output the result along with the number of inspections per each municipality zip code. 
-- Sort the result based on the number of inspections in descending order.
SELECT facility_zip, COUNT(DISTINCT facility_id), COUNT(serial_number) AS num_inspections
FROM los_angeles_restaurant_health_inspections
GROUP BY  facility_zip
ORDER BY num_inspections;

-- Find the number of inspections per day
-- Find the number of inspections per day.
-- Output the result along with the date of the activity.
-- Order results based on the activity date in the ascending order.
SELECT activity_date, COUNT(serial_number) AS Num_Inspections
FROM los_angeles_restaurant_health_inspections
GROUP BY activity_date
ORDER BY activity_date;

-- Customer Details
-- Find the details of each customer regardless of whether the customer made an order. 
-- Output the customer's first name, last name, and the city along with the order details.
-- You may have duplicate rows in your results due to a customer ordering several of the same items. 
-- Sort records based on the customer's first name and the order details in ascending order.
SELECT first_name, last_name, city, order_details
FROM customers c
LEFT JOIN orders o
ON c.id = o.cust_id
ORDER BY 1, 4;

-- Employees With Bonuses
-- Find employees whose bonus is less than $150.
-- Output the first name along with the corresponding bonus.
SELECT first_name, bonus 
FROM employee
WHERE bonus<150;

-- Number of Employees Per Department
-- Find the number of employees in each department.
-- Output the department name along with the corresponding number of employees.
-- Sort records based on the number of employees in descending order.
SELECT department, COUNT(id) AS Num_Employees
FROM employee
GROUP BY department
ORDER BY Num_Employees;

-- Not Referred Employees
-- Find employees that are not referred by the manager id 1.
-- Output the first name of the employee.
SELECT first_name
FROM employee
WHERE manager_id <> 1;

-- Average Salaries
-- Compare each employee's salary with the average salary of the corresponding department.
-- Output the department, first name, and salary of employees along with the average salary of that department.
SELECT department, first_name, salary,
AVG(salary) OVER (PARTITION BY department) AS Avg_Dept_salary 
FROM employee;

-- Sales Dept Salaries
-- Find employees in the Sales department who achieved a target greater than 150.
-- Output first names of employees.
-- Sort records by the first name in descending order.
SELECT first_name 
FROM employee
WHERE department = 'Sales' AND target>150
ORDER BY 1;

-- Popularity of Hack
-- Meta/Facebook has developed a new programing language called Hack.To measure the popularity of Hack they ran a survey with their employees. 
-- The survey included data on previous programing familiarity AS well AS the number of years of experience, age, gender and most importantly satisfaction with Hack. 
-- Due to an error location data was not collected, but your supervisor demands a report showing average popularity of Hack by office location. 
-- Luckily the user IDs of employees completing the surveys were stored.
-- Based on the above, find the average popularity of the Hack per office location.
-- Output the location along with the average popularity.
SELECT location, AVG(popularity) 
FROM facebook_employees AS fe
LEFT JOIN
facebook_hack_survey AS fhs
ON fe.id = fhs.employee_id
GROUP BY location;

-- Guest Or Host Kindness
-- Find whether hosts or guests give higher review scores based on their average review scores. 
-- Output the higher of the average review score rounded to the 2nd decimal spot (e.g., 5.11).
SELECT  FROM_type, ROUND(AVG(review_score) , 2) AS Avg_Review_Score
FROM airbnb_reviews
GROUP BY  FROM_type
ORDER BY avg_review_score DESC LIMIT 1;


-- Gender With Generous Reviews
-- Write a query to find which gender gives a higher average review score when writing reviews AS guests. 
-- Use the ` FROM_type` column to identify guest reviews. Output the gender and their average review score.
SELECT gender, AVG(review_score) AS avg_review_score
FROM airbnb_guests
LEFT JOIN airbnb_reviews
ON(airbnb_guests.guest_id=airbnb_reviews. FROM_user)
WHERE  FROM_type='guest'
GROUP BY gender
ORDER BY avg_review_score DESC LIMIT 1;

-- Total AdWords Earnings
-- Find the total AdWords earnings for each business type. Output the business types along with the total earnings.
SELECT business_type, SUM(adwords_earnings)
FROM google_adwords_earnings
GROUP BY business_type;

-- Total Cost Of Orders
-- Find the total cost of each customer's orders. Output customer's id, first name, and the total order cost. Order records by customer's first name alphabetically.
SELECT c.id, c.first_name, SUM(o.total_order_cost)
FROM customers AS c
JOIN orders AS o
ON c.id = o.cust_id
GROUP BY c.first_name,c.id
ORDER BY c.first_name;

-- Finding Updated Records
-- We have a table with employees and their salaries, however, some of the records are old and contain outdated salary information. 
-- Find the current salary of each employee assuming that salaries increase each year. 
-- Output their id, first name, last name, department ID, and current salary. Order your list by employee ID in ascending order.
SELECT DISTINCT id, first_name, last_name, department_id, MAX(salary) OVER(PARTITION BY id) AS current_salary 
FROM ms_employee_salary
ORDER BY id ASC;
 
SELECT id, first_name, last_name, department_id, MAX(salary) AS salary
FROM ms_employee_salary
GROUP BY 1, 2, 3, 4
ORDER BY id ASC;

-- Salaries Differences
-- Write a query that calculates the difference between the highest salaries found in the marketing and engineering departments. Output just the absolute difference in salaries.
SELECT
( SELECT MAX(salary)
  FROM db_employee emp
  JOIN db_dept dept ON emp.department_id = dept.id
  WHERE department = 'marketing') -
( SELECT MAX(salary)
  FROM db_employee emp
  JOIN db_dept dept ON emp.department_id = dept.id
  WHERE department = 'engineering') AS salary_difference;
  
-------------------------------------------- Day 1 ----------------------------------------------
  
  
-------------------------------------------- Day 2 ----------------------------------------------
  
-- Users with Many Searches
-- Count the number of users who made more than 5 searches in August 2021 
SELECT COUNT(user_id)
FROM(
SELECT user_id, COUNT(search_id) AS num_searches
FROM fb_searches
WHERE date BETWEEN '2021-08-01' AND '2021-08-31'
GROUP BY user_id) AS sub
WHERE num_searches > 5;

-- Users Activity Per Month Day
-- Return a distribution of users activity per day of the month
SELECT EXTRACT('day' FROM post_date), COUNT(post_id)
FROM facebook_posts
GROUP BY DATE(post_date)
ORDER BY post_date;

-- Number of Comments Per User in Past 30 days
-- Return the total number of comments received for each user in the last 30 days. 
-- Don't output users who haven't received any comment in the defined time period. Assume today is 2020-02-10.
SELECT user_id, SUM(number_of_comments) 
FROM fb_comments_count
WHERE created_at BETWEEN '2020-02-10'::date - 30 * INTERVAL '1 DAY' AND '2020-02-10'::date
GROUP BY user_id
ORDER BY user_id;

-------------------------------------------- Day 2 ----------------------------------------------

-------------------------------------------- Day 3 ----------------------------------------------

-- Find all wineries which produce wines by possessing aromas of plum, cherry, rose, or hazelnut
-- Find all wineries which produce wines by possessing aromas of plum, cherry, rose, or hazelnut.
-- Output unique winery values only.
SELECT DISTINCT winery 
FROM winemag_p1
WHERE description ILIKE ANY(ARRAY['%plum%', '%cherry%', '%rose%', '%hazelnut%']);

-- Find the most profitable company in the financial sector of the entire world along with its continent
-- Find the most profitable company from the financial sector. Output the result along with the continent 
SELECT company, continent
FROM forbes_global_2010_2014
WHERE sector = 'Financials'
ORDER BY profits DESC LIMIT 1

-- Find libraries who haven't provided the email address in 2016 but their notice preference definition is set to email
-- Find libraries who haven't provided the email address in 2016 but their notice preference definition is set to email.
-- Output the library code.
SELECT home_library_code
FROM library_usage
WHERE circulation_active_year = 2016 
AND provided_email_address = 'FALSE'
AND notice_preference_definition = 'email';

-------------------------------------------- Day 3 ----------------------------------------------

-------------------------------------------- Day 4 ----------------------------------------------

-- Find the base pay for Police Captains
-- Find the base pay for Police Captains.
-- Output the employee name along with the corresponding base pay.
SELECT employeename, basepay FROM sf_public_salaries
WHERE jobtitle ILIKE '%captain%';

-- Find how many times each artist appeared on the Spotify ranking list
-- Find how many times each artist appeared on the Spotify ranking list
-- Output the artist name along with the corresponding number of occurrences.
-- Order records by the number of occurrences in descending order.
SELECT artist, COUNT(position) AS times_appeared
FROM spotify_worldwide_daily_song_ranking
GROUP BY artist
ORDER BY times_appeared DESC;

-- Find all posts which were reacted to with a heart
-- Find all posts which were reacted to with a heart.
SELECT DISTINCT fp.* 
from facebook_posts fp
INNER JOIN facebook_reactions fr
ON fp.post_id = fr.post_id AND reaction = 'heart';

-- Count the number of movies that Abigail Breslin nominated for oscar
-- Count the number of movies that Abigail Breslin was nominated for an oscar.
SELECT COUNT(*) 
FROM oscar_nominees
WHERE nominee = 'Abigail Breslin';

-- Bikes Last Used
-- Find the last time each bike was in use. Output both the bike number and the date-timestamp of the bike's last use (i.e., the date-time the bike was returned). 
-- Order the results by bikes that were most recently used.
SELECT bike_number, MAX(end_time) AS last_used
FROM dc_bikeshare_q1_2012
GROUP BY bike_number
ORDER BY last_used;

-------------------------------------------- Day 4 ----------------------------------------------