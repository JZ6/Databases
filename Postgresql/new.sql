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
DROP VIEW IF EXISTS winners CASCADE;
DROP VIEW IF EXISTS incumbentWinners CASCADE;
DROP TABLE IF EXISTS countryElections CASCADE;
DROP VIEW IF EXISTS countryIncumbentCounts CASCADE;
DROP VIEW IF EXISTS countryPms CASCADE;
DROP VIEW IF EXISTS PmCounts;

-- Define views for your intermediate steps here.

-- count per country(country, eid x eid, pm_isIncumbent) x country, count(repeatedPm)

CREATE VIEW winners AS
  SELECT
    election.id                              AS eid,
    cabinet_party.party_id                   AS pid,
    election.previous_parliament_election_id AS lastEid
  FROM election
    JOIN cabinet
      ON election.id = cabinet.election_id
    JOIN cabinet_party
      ON cabinet.id = cabinet_party.cabinet_id
  WHERE cabinet_party.pm = TRUE;

CREATE VIEW incumbentWinners AS
  SELECT DISTINCT
    w1.eid,
    w1.pid,
    w2.pid AS lastPid
  FROM winners AS w1
    JOIN winners AS w2
      ON w1.lastEid = w2.eid
  WHERE w1.pid = w2.pid;

CREATE TABLE countryElections AS
  SELECT
    name        AS country,
    election.id AS eid
  FROM country, election
  WHERE country.id = country_id;

ALTER TABLE countryElections
  ADD party_isIncumbent BOOLEAN;

UPDATE countryElections
SET party_isIncumbent =
countryElections.eid IN
(SELECT incumbentWinners.eid
 FROM incumbentWinners);

CREATE VIEW countryIncumbentCounts AS
  SELECT
    country,
    count(eid)      AS nEletions,
    sum(CASE WHEN party_isIncumbent
      THEN 1
        ELSE 0 END) AS nIncumbent
  FROM countryElections
  GROUP BY country;

-- count how many PMs have been elected more than once per country
-- country(cid) x cabinet(eid, cid, PMname) x cabinet_party(cabid, pm=T/F)
CREATE VIEW countryPms AS
  SELECT
    cabinet.election_id                                                 AS eid,
    cabinet.id                                                          AS cabid,
    country.name                                                        AS country,
    regexp_replace(cabinet.name :: TEXT, '([A-Za-z]*?)[ IXV?]+$', '\1') AS PMname,
    pm
  FROM country
    JOIN cabinet
      ON country.id = cabinet.country_id
    JOIN cabinet_party
      ON cabinet.id = cabinet_party.cabinet_id;

CREATE VIEW PmCounts AS
  SELECT
    country,
    PMname,
    count(PMname) AS countPM
  FROM countryPms
  WHERE pm = TRUE
  GROUP BY country, PMname;

-- the answer to the query
INSERT INTO q4
  SELECT
    cic.country,
    nEletions,
    nIncumbent,
    count(CASE WHEN countPM > 1
      THEN 1
          ELSE 0 END) AS rRepPM
  FROM countryIncumbentCounts AS cic
    JOIN PmCounts
      ON cic.country = PmCounts.country
  GROUP BY cic.country, nEletions, nIncumbent;

