SET SEARCH_PATH TO parlgov;
DROP TABLE IF EXISTS q3 CASCADE;

-- You must not change this table definition.

CREATE TABLE q3 (
  country                 VARCHAR(50),
  num_dissolutions        INT,
  most_recent_dissolution DATE,
  num_on_cycle            INT,
  most_recent_on_cycle    DATE
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS parlimentary_elections CASCADE;
DROP VIEW IF EXISTS on_cycle_num CASCADE;
DROP VIEW IF EXISTS dissolution_num CASCADE;
DROP VIEW IF EXISTS most_recent_diss CASCADE;
DROP VIEW IF EXISTS most_recent_cyleCASCADE;

-- Define views for your intermediate steps here.

CREATE VIEW parlimentary_elections AS
  SELECT
    election_cycle,
    e_date,
    previous_parliament_election_id,
    country_id,
    election.id AS election_id
  FROM election, country
  WHERE e_type = 'Parliamentary election' AND country_id = country.id;

CREATE VIEW on_cycle_num AS

  SELECT DISTINCT
    count(a.previous_parliament_election_id) AS num_on_cycle,
    a.country_id
  FROM parlimentary_elections a, parlimentary_elections b
  WHERE a.country_id = b.country_id AND
        a.previous_parliament_election_id = b.election_id AND
        (EXTRACT(YEAR FROM a.e_date) - EXTRACT(YEAR FROM b.e_date)) = a.election_cycle
  GROUP BY a.country_id;

CREATE VIEW dissolution_num AS

  SELECT DISTINCT
    count(a.previous_parliament_election_id) AS num_dissolutions,
    a.country_id
  FROM parlimentary_elections a, parlimentary_elections b
  WHERE a.country_id = b.country_id AND
        a.previous_parliament_election_id = b.election_id AND
        (EXTRACT(YEAR FROM a.e_date) - EXTRACT(YEAR FROM b.e_date)) <> a.election_cycle
  GROUP BY a.country_id;

CREATE VIEW most_recent_diss AS
  SELECT DISTINCT
    max(a.e_date) AS most_recent_dissolution,
    a.country_id
  FROM parlimentary_elections a, parlimentary_elections b
  WHERE a.country_id = b.country_id AND
        a.previous_parliament_election_id = b.election_id AND
        (EXTRACT(YEAR FROM a.e_date) - EXTRACT(YEAR FROM b.e_date)) <> a.election_cycle
  GROUP BY a.country_id;

CREATE VIEW most_recent_cyle AS
  SELECT DISTINCT
    max(a.e_date) AS most_recent_on_cycle,
    a.country_id
  FROM parlimentary_elections a, parlimentary_elections b
  WHERE a.country_id = b.country_id AND
        a.previous_parliament_election_id = b.election_id AND
        (EXTRACT(YEAR FROM a.e_date) - EXTRACT(YEAR FROM b.e_date)) = a.election_cycle
  GROUP BY a.country_id;

-- the answer to the query
INSERT INTO q3
  SELECT
    name AS country,
    num_dissolutions,
    most_recent_dissolution,
    num_on_cycle,
    most_recent_on_cycle
  FROM on_cycle_num, dissolution_num, most_recent_diss, most_recent_cyle, country
  WHERE country.id = on_cycle_num.country_id
        AND country.id = dissolution_num.country_id
        AND country.id = most_recent_diss.country_id
        AND country.id = most_recent_cyle.country_id;