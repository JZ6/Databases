SET SEARCH_PATH TO parlgov;
DROP TABLE IF EXISTS q7 CASCADE;

-- You must not change this table definition.

DROP TABLE IF EXISTS q7 CASCADE;
CREATE TABLE q7 (
  partyId     INT,
  partyFamily VARCHAR(50)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS grouped_results CASCADE;
DROP VIEW IF EXISTS election_winners CASCADE;
DROP VIEW IF EXISTS all_winners CASCADE;
DROP VIEW IF EXISTS alliance_winners CASCADE;
DROP VIEW IF EXISTS ep_elections CASCADE;
DROP VIEW IF EXISTS won_before CASCADE;
DROP VIEW IF EXISTS potential_parties CASCADE;
DROP VIEW IF EXISTS between_eps CASCADE;

-- create table with alliance ids fixed
CREATE VIEW grouped_results  AS
  SELECT
    id,
    election_id,
    party_id,
    votes,
    alliance_id,
    CASE
    WHEN alliance_id IS NULL
      THEN id
    ELSE alliance_id
    END AS a_id
  FROM election_result;

-- get  all of the  winning  parties  based on the  cabinet
CREATE VIEW election_winners  AS
  SELECT
    election.id            AS election_id,
    cabinet_party.party_id AS party_id,
    election.e_date        AS e_date
  FROM election
    JOIN cabinet
      ON election.id = cabinet.election_id
    JOIN cabinet_party
      ON cabinet.id = cabinet_party.cabinet_id
  WHERE cabinet_party.pm = TRUE;

-- get all alliance ids of winning parties
CREATE VIEW alliance_winners AS
  SELECT DISTINCT
    g2.election_id AS election_id,
    g2.a_id        AS a_id,
    g2.party_id    AS party_id
  FROM grouped_results g2
    JOIN election_winners e ON
                              g2.party_id = e.party_id
                              AND g2.election_id = e.election_id;

-- get all parties that served as a winning party or member of a winning party and the date they won
CREATE VIEW all_winners AS
  SELECT DISTINCT
    g.election_id AS election_id,
    e.e_date      AS e_date,
    g.party_id    AS party_id,
    g.a_id        AS a_id,
    e.country_id
  FROM grouped_results g
    JOIN alliance_winners a ON g.a_id = a.a_id
                               AND g.election_id = a.election_id
    JOIN election e ON g.election_id = e.id;

-- find all dates of EP election including prev EP election
CREATE VIEW ep_elections AS
  SELECT
    e1.country_id,
    e1.id                      AS election_id,
    e1.e_date                  AS e_date,
    e1.previous_ep_election_id AS prev_ep,
    e2.e_date                  AS prev_date
  FROM election e1 LEFT JOIN election e2 ON e1.previous_ep_election_id = e2.id AND e1.country_id = e2.country_id
  WHERE e1.e_type = 'European Parliament';

-- get all parties that won an election before the date of the first EP
CREATE VIEW won_before AS
  SELECT
    a.party_id,
    a.e_date
  FROM all_winners a
  WHERE a.e_date < (SELECT min(e.e_date)
                    FROM ep_elections e);

CREATE VIEW potential_parties AS
  SELECT *
  FROM all_winners
  WHERE party_id = SOME (SELECT party_id
                         FROM won_before)
  ORDER BY party_id;

-- this view gives the distinct EP election days
CREATE VIEW ep_periods AS
  SELECT DISTINCT e_date
  FROM ep_elections;

-- we need to check that potential parties won an election between EVERY interval of distinct EPs
CREATE VIEW between_eps AS
  SELECT
    party_id,
    count(DISTINCT ep_elections.e_date) AS wins,
    ep_elections.country_id
  FROM potential_parties, ep_elections
  WHERE potential_parties.e_date <= ep_elections.e_date
        AND potential_parties.e_date >= ep_elections.prev_date
        AND potential_parties.country_id = ep_elections.country_id
  GROUP BY party_id,ep_elections.country_id;

-- the answer to the query
INSERT INTO q7
  SELECT
    between_eps.party_id AS partyID,
    family               AS partyFamily
  FROM between_eps, party_family, ep_elections
  WHERE between_eps.party_id = party_family.party_id
        AND between_eps.country_id = ep_elections.country_id
        AND wins = (select count(ep_elections.prev_ep) + 1 from ep_elections);
