-- Q3
SET SEARCH_PATH TO schema;

-- Drop views 
DROP VIEW IF EXISTS rentals CASCADE;
DROP VIEW IF EXISTS toronto_models CASCADE;
DROP VIEW IF EXISTS result CASCADE;

-- Reservations started and completed in the year 2017
CREATE VIEW rentals AS 
	SELECT r.id as reservation, c.model_id as model_id, station_code as station
	FROM reservation r JOIN car c ON r.car_id = c.id
	WHERE r.status = 'Completed' and 
		EXTRACT (YEAR from r.from_date) = '2017' and 
		EXTRACT (YEAR from r.to_date) = '2017'; 

-- The number of times each model was rented in Toronto 
CREATE VIEW toronto_models AS
	SELECT m.name as name, count(*) as num_rented
	FROM rentals r JOIN station s ON r.station = s.code 
		JOIN model m ON r.model_id = m.id
	WHERE s.city = 'Toronto' 
	GROUP BY m.name;

-- Generate a row number over the most frequently rented cars
CREATE VIEW result AS 
	SELECT 	name,
		num_rented, 
		row_number() OVER (ORDER BY num_rented DESC, name) as rownum
	FROM toronto_models;

-- Model name of car most frequently rented in Toronto in 2017 
SELECT name
FROM result 
WHERE rownum <= 1;
