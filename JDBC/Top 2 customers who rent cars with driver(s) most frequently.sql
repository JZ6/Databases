-- Q2
SET SEARCH_PATH TO schema;

-- Drop views 
DROP VIEW IF EXISTS shared_reservations CASCADE;
DROP VIEW IF EXISTS num_shared_reservations CASCADE;
DROP VIEW IF EXISTS result CASCADE;

-- Reservations that have multiple drivers 
CREATE VIEW shared_reservations AS
	SELECT c1.customer_email as email, c1.reservation_id as id
	FROM customer_reservation c1 
	WHERE c1.reservation_id = ANY 
		(SELECT c2.reservation_id 
		FROM customer_reservation c2
		GROUP BY c2.reservation_id
		HAVING count(*) > 1); 

-- Customers and the number of reservations they've shared
CREATE VIEW num_shared_reservations AS 
	SELECT  email as customer_email, 
		count(*) as num_shared
	FROM shared_reservations
	GROUP BY email;  

-- Generate a row number over the highest number of shared ratios
CREATE VIEW result AS
	SELECT  customer_email, 
		num_shared,
		row_number() OVER (ORDER BY num_shared DESC, customer_email) as rownum
	FROM num_shared_reservations;

-- Top 2 customers who rent cars with other drivers most frequently
SELECT customer_email FROM result WHERE rownum <= 2; 
