SET SEARCH_PATH TO parlgov;
DROP TABLE IF EXISTS q4 CASCADE;

-- You must not change this table definition.


CREATE TABLE q4 (
  country          VARCHAR(50),
  num_elections    INT,
  num_repeat_party INT,
  num_repeat_pm    INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS election_winners CASCADE;
DROP VIEW IF EXISTS election_nums CASCADE;

-- Define views for your intermediate steps here.
CREATE VIEW election_winners AS
  SELECT
    election.id AS election_id,
    cabinet_party.party_id
  FROM election
    JOIN cabinet
      ON election.id = cabinet.election_id
    JOIN cabinet_party
      ON cabinet.id = cabinet_party.cabinet_id
  WHERE cabinet_party.pm = TRUE;


CREATE VIEW election_nums AS
  SELECT
    count(election.id) as num_elections,
    country_id
  FROM election
  WHERE e_type = 'Parliamentary election'
  GROUP BY country_id;

-- the answer to the query 
INSERT INTO q4
  SELECT
    name as country,
    num_elections,
    1 as num_repeat_party,
    1 as num_repeat_pm
  FROM country,election_nums WHERE country.id = country_id;

