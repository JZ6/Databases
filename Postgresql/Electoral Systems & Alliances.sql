SET SEARCH_PATH TO parlgov;
DROP TABLE IF EXISTS q2 CASCADE;

-- You must not change this table definition.

CREATE TABLE q2 (
  country          VARCHAR(50),
  electoral_system VARCHAR(100),
  single_party     INT,
  two_to_three     INT,
  four_to_five     INT,
  six_or_more      INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS election_winners CASCADE;
DROP VIEW IF EXISTS parlimentary_elections CASCADE;
DROP VIEW IF EXISTS no_alliance_parties CASCADE;
DROP VIEW IF EXISTS no_alliance_winners CASCADE;
DROP VIEW IF EXISTS alliance_parties CASCADE;
DROP VIEW IF EXISTS alliance_winners CASCADE;
DROP VIEW IF EXISTS party_leaders CASCADE;
DROP VIEW IF EXISTS leader_winners CASCADE;
DROP VIEW IF EXISTS alliance_winner_parties CASCADE;


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

-- parliamentary elections only
CREATE VIEW parlimentary_elections AS
  SELECT
    election.id AS election_id,
    country.id  AS country_id
  FROM election, country
  WHERE e_type = 'Parliamentary election'
        AND country_id = country.id;

-- no_alliance_parties
CREATE VIEW no_alliance_parties AS
  (SELECT
     id,
     election_id,
     party_id
   FROM election_result
   WHERE alliance_id IS NULL)

  EXCEPT

  (SELECT
     id,
     election_id,
     party_id
   FROM election_result
   WHERE id = ANY
         (SELECT alliance_id
          FROM election_result));

-- no_alliance_parties wins
CREATE VIEW no_alliance_winners  AS
  SELECT DISTINCT
    nap.election_id,
    nap.party_id,
    p_e.country_id
  FROM no_alliance_parties nap, election_winners e_w, parlimentary_elections p_e
  WHERE nap.party_id = e_w.party_id
        AND nap.election_id = e_w.election_id
        AND nap.election_id = p_e.election_id;

-- alliance_parties
CREATE VIEW alliance_parties AS
  SELECT
    id,
    election_id,
    party_id,
    alliance_id
  FROM election_result
  WHERE alliance_id IS NOT NULL;

-- alliance_parties wins
CREATE VIEW alliance_winners AS
  SELECT DISTINCT
    a_p.id,
    a_p.election_id,
    a_p.party_id,
    a_p.alliance_id,
    p_e.country_id
  FROM alliance_parties a_p, election_winners e_w, parlimentary_elections p_e
  WHERE a_p.party_id = e_w.party_id
        AND a_p.election_id = e_w.election_id
        AND a_p.election_id = p_e.election_id;

-- All allied party leaders
CREATE VIEW party_leaders AS
  SELECT
    id,
    election_id,
    party_id
  FROM election_result
  WHERE id = ANY
        (SELECT alliance_id
         FROM election_result);
-- Allied party leaders Wins
CREATE VIEW leader_winners AS
  SELECT DISTINCT
    p_l.id,
    p_l.election_id,
    p_l.party_id,
    p_e.country_id
  FROM party_leaders p_l, election_winners e_w, parlimentary_elections p_e
  WHERE p_l.party_id = e_w.party_id
        AND p_l.election_id = e_w.election_id
        AND p_l.election_id = p_e.election_id;

-- Alliance_parties winner number of parties
CREATE VIEW alliance_winner_parties  AS
  (SELECT
     count(id) + 1 AS party_num,
     alliance_id,
     election_id,
     country_id

   FROM alliance_winners
   GROUP BY alliance_id, election_id, country_id)

  UNION

  (SELECT
     count(election_result.id) + 1 AS party_num,
     leader_winners.id             AS alliance_id,
     leader_winners.election_id,
     leader_winners.country_id
   FROM leader_winners, election_result
   WHERE election_result.alliance_id = leader_winners.id
   GROUP BY leader_winners.ID, leader_winners.election_id, leader_winners.country_id);

INSERT INTO q2
  SELECT
    name as country,
    electoral_system,
    (SELECT DISTINCT count(election_id)
     FROM no_alliance_winners
     WHERE country_id = country.id)                         AS single_party,

    (SELECT DISTINCT count(election_id)
     FROM alliance_winner_parties
     WHERE party_num IN (2, 3) AND country_id = country.id) AS two_to_three,

    (SELECT DISTINCT count(election_id)
     FROM alliance_winner_parties
     WHERE party_num IN (4, 5) AND country_id = country.id) AS four_to_five,

    (SELECT DISTINCT count(election_id)
     FROM alliance_winner_parties
     WHERE party_num > 5 AND country_id = country.id)       AS six_or_more

  FROM country;
