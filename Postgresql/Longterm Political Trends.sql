SET SEARCH_PATH TO parlgov;
DROP TABLE IF EXISTS q1 CASCADE;

-- You must not change this table definition.

CREATE TABLE q1 (
  century           VARCHAR(2),
  country           VARCHAR(50),
  left_right        REAL,
  state_market      REAL,
  liberty_authority REAL
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS election_winners CASCADE;
DROP VIEW IF EXISTS no_alliance_parties CASCADE;
DROP VIEW IF EXISTS allied_parties CASCADE;
DROP VIEW IF EXISTS avgs CASCADE;
DROP VIEW IF EXISTS each_country CASCADE;
DROP VIEW IF EXISTS result CASCADE;

-- Define views for your intermediate steps here.

-- get all of the winning parties based on the cabinet. From Handout Listing 1
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

-- no_alliance_parties
CREATE VIEW no_alliance_parties AS
  (SELECT
     id       AS result_id,
     party_id AS partyid
   FROM election_result
   WHERE alliance_id IS NULL)

  EXCEPT

  (SELECT
     id       AS result_id,
     party_id AS partyid
   FROM election_result
   WHERE id = ANY
         (SELECT alliance_id
          FROM election_result));

-- All allied parties
CREATE VIEW allied_parties AS
  (SELECT
     election_id,
     party_id AS partyid,
     alliance_id
   FROM election_result
   WHERE alliance_id IS NOT NULL)

  UNION

  (SELECT
     election_id,
     party_id AS partyid,
     alliance_id
   FROM election_result
   WHERE id = ANY
         (SELECT alliance_id
          FROM election_result));

-- Average positions
CREATE VIEW avgs AS
  (SELECT
     alliance_id,
     avg(left_right)        AS left_right,
     avg(state_market)      AS state_market,
     avg(liberty_authority) AS liberty_authority
   FROM allied_parties, party_position
   WHERE party_id = partyid
   GROUP BY election_id, alliance_id)

  UNION

  (SELECT
     result_id AS alliance_id,
     left_right,
     state_market,
     liberty_authority
   FROM no_alliance_parties, party_position
   WHERE party_id = partyid);

-- Turn year into century
ALTER TABLE election
  ADD century VARCHAR(2);

UPDATE election
SET century = 21
WHERE extract(YEAR FROM e_date) > 2000;

UPDATE election
SET century = 20
WHERE extract(YEAR FROM e_date) <= 2000;

-- For each country
CREATE VIEW each_country AS
  SELECT
    century,
    country_id,
    election_result.id AS result_id,
    alliance_id
  FROM election, election_winners, election_result
  WHERE election_result.party_id = election_winners.party_id
        AND election_winners.election_id = election.id
        AND election_winners.election_id = election_result.election_id;

-- Result avgs
CREATE VIEW result AS
  SELECT
    century,
    country_id,
    avg(left_right)        AS left_right,
    avg(state_market)      AS state_market,
    avg(liberty_authority) AS liberty_authority
  FROM each_country, avgs
  WHERE avgs.alliance_id IN (each_country.alliance_id, each_country.result_id)
  GROUP BY country_id, century;

-- Add names
INSERT INTO q1
  SELECT
    century,
    name AS country,
    left_right,
    state_market,
    liberty_authority
  FROM country, result
  WHERE id = country_id;

