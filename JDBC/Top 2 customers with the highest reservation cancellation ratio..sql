-- Q1 
SET SEARCH_PATH TO schema;

-- Intermediate steps 
DROP VIEW IF EXISTS cancelled CASCADE;
DROP VIEW IF EXISTS not_cancelled CASCADE;
DROP VIEW IF EXISTS num_cancelled CASCADE;
DROP VIEW IF EXISTS num_not_cancelled CASCADE;
DROP VIEW IF EXISTS num_reservations CASCADE;
DROP VIEW IF EXISTS cancel_ratio CASCADE;
DROP VIEW IF EXISTS result CASCADE;


-- Find cancelled reservations 
-- excluding changed reservations by checking for id prev_reservations
CREATE VIEW cancelled AS 
	(SELECT * 
	FROM reservation  
	WHERE status = 'Cancelled') 
		EXCEPT 
	(SELECT * 
	FROM reservation  
	WHERE status = 'Cancelled'and 
		id = ANY (SELECT prev_reservation from reservation));

-- Find all reservations that weren't cancelled 
CREATE VIEW not_cancelled AS 
	SELECT * 
	FROM reservation 
	WHERE status = 'Confirmed' or 
		status = 'Ongoing' or 
		status = 'Completed';

-- Find number of cancellations for each customer 
CREATE VIEW num_cancelled AS
	SELECT customer_email, count(*) num_cancellations
	FROM cancelled JOIN customer_reservation
	ON id = reservation_id
	GROUP BY customer_email;

-- Find number of reservations not cancelled for each customer
CREATE VIEW num_not_cancelled AS
	SELECT customer_email, count(*) as num_reservations
	FROM not_cancelled JOIN customer_reservation
	ON id = reservation_id
	GROUP BY customer_email;

-- Create formatted table for num of each reservation type 
-- If the customer had no cancelled reservations or no other reservations, then num is 0
CREATE VIEW num_reservations AS 
	SELECT  CASE 	WHEN n2.customer_email is null THEN n1.customer_email
			ELSE n2.customer_email
		END as email,
		CASE 	WHEN n1.num_cancellations is null THEN 0
			ELSE n1.num_cancellations 
		END as num_cancellations,
		CASE 	WHEN n2.num_reservations is null THEN 0 
			ELSE n2.num_reservations
		END as num_reservations
	FROM num_cancelled n1 FULL JOIN num_not_cancelled n2
	ON n1.customer_email = n2.customer_email;

-- Create column for cancel_ratio
CREATE VIEW ratio AS 
	SELECT  email, num_cancellations, num_reservations,
		CASE 	WHEN num_reservations = 0 THEN num_cancellations
			ELSE CAST(num_cancellations as float)/ cast(num_reservations as float)
		END as cancel_ratio
	FROM num_reservations;

-- Generate row number over highest ratios 
CREATE VIEW result AS
	SELECT  email,
		num_cancellations, 
		num_reservations, 
		cancel_ratio,
		row_number() OVER (ORDER BY cancel_ratio DESC, email) as rownum
	FROM ratio;

-- Top 2 customers who rent cars with other drivers most frequently
SELECT email, cancel_ratio
FROM result 
WHERE rownum <= 2; 



