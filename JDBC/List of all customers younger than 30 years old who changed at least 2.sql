-- Q4
SET SEARCH_PATH TO schema;

-- Drop views 
DROP VIEW IF EXISTS young_customers CASCADE;
DROP VIEW IF EXISTS young_reservations CASCADE;
DROP VIEW IF EXISTS changed CASCADE;
DROP VIEW IF EXISTS recently_changed CASCADE;
DROP VIEW IF EXISTS recent_and_young CASCADE;
DROP VIEW IF EXISTS result CASCADE;

-- Customers under 30 years old 
CREATE VIEW young_customers AS 
	SELECT email 
	FROM customer 	
	WHERE age < 30; 

-- Reservations by customers under 30 
CREATE VIEW young_reservations AS 
	SELECT * 
	FROM customer_reservation 
	WHERE customer_email = ANY (SELECT * FROM young_customers);

-- Changed reservations 
CREATE VIEW changed AS 
	SELECT * 
	FROM reservation r
	WHERE r.id = ANY (SELECT r2.prev_reservation FROM reservation r2); 

-- Reservations changed in the last 18 months  
CREATE VIEW recently_changed AS
	SELECT id 
	FROM changed 
	WHERE age(from_date) <= '540 days';

-- Recent reservations by young customers 
CREATE VIEW recent_and_young AS 
	SELECT y.reservation_id as id, y.customer_email as email
	FROM recently_changed r JOIN young_reservations y
	ON r.id = y.reservation_id;

-- All customers younger than 30 years old who changed at least 2 reservations in the past 18 months 
CREATE VIEW result AS 
	SELECT email 
	FROM recent_and_young
	GROUP BY email 
	HAVING count(*) >= 2; 

SELECT * FROM result ORDER BY email; 


