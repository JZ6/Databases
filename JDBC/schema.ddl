/*
-- A Schema for renting cars 

Constraints enforced by the schema: 
1. Customer emails must be in a valid form, i.e. at least one character before ONE '@' followed by
 at least one '.' with at least one character before and after it
2. Reservation status must be one of the valid options 
3. Each must provide some name, and age which must be over 17 (the legal driving age in Canada)
4. Each customer can only register once with a given email 
5. Each station must reside at a unique address
6. Each reservation can only have one car attached to it
7. Each reservation's start date must come before its end dates
8. Each car must be unique (as denoted by their unique license numbers)

Constraints that could not be enforced: 
1. Two customers should not be able to rent the same car during the same period of time; 
to enforcee this we would need to inspect all other reservations in the system and their respective cars
2. No reservation can be changed more than once; to enforce this we would need to be able to 
inspect whether the previous_reservation tuple has a null value in its previous_reservation attribute
3. Every reservation needs at least one customer in the customer_reservation table
4. If the reservation is confirmed its dates must be in the future, if ongoing they must be current and if completed
they must be in the past
*/

DROP SCHEMA IF EXISTS schema CASCADE;
CREATE SCHEMA schema;
SET SEARCH_PATH to schema; 

-- Types --


CREATE DOMAIN Status as VARCHAR(9)
 NOT NULL
 constraint validStatus
   check (value in ('Confirmed', 'Ongoing', 'Completed', 'Cancelled'));

CREATE DOMAIN Email as VARCHAR(50)
  NOT NULL 
  constraint validEmail
	check (value ~ '^[^@]+@[^@]+\.[^@]+$');

CREATE DOMAIN City as VARCHAR(30)
 NOT NULL
 constraint validCity
   check (value in ('Toronto', 'Montreal', 'Ottawa'));



-- Tables -- 
 

-- This table records all customers of the service
CREATE TABLE customer(
  --The full name of the customer
  name VARCHAR(50) NOT NULL,
  -- Age of customer in years; Age must be a positive integer  
  age INT  check (age > 17) NOT NULL,
  -- This attribute identifies customers by their unique email address
  -- Constraint: Must be in the correct form for an email, i.e. x@x.x
  email Email primary key
 );

-- Car models 
CREATE TABLE model(
  id INT primary key, 
  -- The full name of the model  
  name VARCHAR(50) NOT NULL,
  -- Vehicle type; Constraint: must be in vehicle type table? 
  type VARCHAR(20) NOT NULL, 
  -- model number 
  model INT NOT NULL, 
  -- Number of seats in the vehicle 
  -- Constraint: The number of seats needs to be reasonable for a car 
  capacity INT check (1 < capacity and capacity < 11) NOT NULL
);


-- Rental stations 
CREATE TABLE station(
  code INT primary key, 
  name VARCHAR (50) NOT NULL,
  address VARCHAR (50) NOT NULL,
  -- Postal code; Must have 6 characters 
  area_code CHAR(6) UNIQUE NOT NULL,
  city City,
  UNIQUE (address, area_code, city)
);


-- Cars 
CREATE TABLE car(
  id INT primary key, 
  -- license plate number 
  license CHAR(7) NOT NULL UNIQUE, 
  -- rental station foreign key for station
  station_code INT REFERENCES station, 
  -- model number foreign key for model 
  model_id INT REFERENCES model
); 



-- Reservations 
CREATE TABLE reservation(
  id INT primary key,
  -- Date reservation was created 
  from_date TIMESTAMP NOT NULL ,
  -- Date reservation ended; 
  -- Constraint: Must be after from_date 
  to_date TIMESTAMP NOT NULL check (to_date >= from_date),
  -- This attribute refers to the car used in the rental 
  car_id INT REFERENCES car,
  -- References the previous reservation after a change is made; can be null if there is no previous reservation 
  -- Constraint: You can only change each reservation once, so the same previous reservation cannot be referenced by multiple new reservation
  prev_reservation INT REFERENCES reservation(id) UNIQUE, 
  -- This attribute describes the status of the reservation; can be: confirmed, ongoing, completed, cancelled 
  status Status  
); 


-- Customers on each reservation 
CREATE TABLE customer_reservation(
  customer_email VARCHAR(50) REFERENCES customer, 
  reservation_id INT REFERENCES reservation, 
  primary key (customer_email, reservation_id)
); 
