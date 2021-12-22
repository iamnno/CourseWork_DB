-- Створення бази даних та користувачів
CREATE USER "FootballChampionshipOwner" WITH PASSWORD 'Football_Championship_Owner';

CREATE DATABASE "FootballChampionshipDB" OWNER "FootballChampionshipOwner";
ALTER DATABASE "FootballChampionshipDB" SET TIMEZONE = 'UTC';

GRANT ALL PRIVILEGES ON DATABASE "FootballChampionshipDB" TO "FootballChampionshipOwner";

CREATE USER "FootballChampionshipReader" WITH PASSWORD 'Football_Championship_Reader';
GRANT CONNECT ON DATABASE "FootballChampionshipDB" TO "FootballChampionshipReader";
GRANT USAGE ON SCHEMA public TO "FootballChampionshipReader";
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "FootballChampionshipReader";
-- Під'єднання до бази даних
\c FootballChampionshipDB
-- Створення таблиць
--
CREATE TABLE IF NOT EXISTS football_country
(
	country_id NUMERIC PRIMARY KEY,
	country_abbreviation VARCHAR(4),
	country_name VARCHAR(40)
);
--
CREATE TABLE IF NOT EXISTS football_city
(
	pk_city_id NUMERIC PRIMARY KEY,
	city VARCHAR(25),
	country_id NUMERIC REFERENCES football_country(country_id)
);
--
CREATE TABLE IF NOT EXISTS football_venue
(
	venue_id NUMERIC PRIMARY KEY,
	venue_name VARCHAR(30),
	fk_city_id NUMERIC REFERENCES football_city(pk_city_id),
	audience_capacity NUMERIC
);
--
CREATE TABLE IF NOT EXISTS football_team
(
	fk_team_id NUMERIC REFERENCES football_country(country_id),
	team_group CHARACTER(1),
	match_played NUMERIC,
	won NUMERIC,
	draw NUMERIC,
	lost NUMERIC,
	goal_for NUMERIC,
	goal_against NUMERIC,
	goal_difference NUMERIC,
	points NUMERIC,
	group_position NUMERIC
);
--
CREATE TABLE IF NOT EXISTS playing_position
(
	pk_position_id VARCHAR(2) PRIMARY KEY,
	position_description VARCHAR(15)
);
--
CREATE TABLE IF NOT EXISTS player_mast
(
	player_id NUMERIC PRIMARY KEY,
	fk_team_id NUMERIC REFERENCES football_country(country_id),
	jersey_number NUMERIC,
	player_name VARCHAR(40),
	fk_position_to_play CHARACTER(2) REFERENCES playing_position(pk_position_id),
	date_of_birth DATE,
	age NUMERIC,
	playing_club VARCHAR(40)
);
--
CREATE TABLE IF NOT EXISTS referee_mast
(
	referee_id NUMERIC PRIMARY KEY,
	referee_name VARCHAR(40),
	country_id NUMERIC REFERENCES football_country(country_id)
);
--
CREATE TABLE IF NOT EXISTS match_mast
(
	match_number NUMERIC PRIMARY KEY,
	play_stage CHARACTER(1),
	play_date DATE,
	results CHARACTER(5),
	decided_by CHARACTER(1),
	goal_score CHARACTER(5),
	venue_id NUMERIC REFERENCES football_venue(venue_id),
	referee_id NUMERIC REFERENCES referee_mast(referee_id),
	audence NUMERIC,
	fk_player_of_match NUMERIC REFERENCES player_mast(player_id),
	stop1_second NUMERIC,
	stop2_second NUMERIC
);
--
CREATE TABLE IF NOT EXISTS coach_mast
(
	pk_coach_id NUMERIC PRIMARY KEY,
	coach_name VARCHAR(40)
);
--
CREATE TABLE IF NOT EXISTS assistant_referee_mast
(
	pk_assistant_referee_id NUMERIC PRIMARY KEY,
	assistant_referee_name VARCHAR(40),
	country_id NUMERIC REFERENCES football_country(country_id)
);
--
CREATE TABLE IF NOT EXISTS match_details
(
	match_number NUMERIC REFERENCES match_mast(match_number),
	play_stage VARCHAR(1),
	fk_team_id NUMERIC REFERENCES football_country(country_id),
	win_lose VARCHAR(1),
	decided_by VARCHAR(1),
	goal_score NUMERIC,
	penalty_score NUMERIC,
	fk_assistant_referee NUMERIC REFERENCES assistant_referee_mast(pk_assistant_referee_id),
	fk_player_goal_keeper NUMERIC REFERENCES player_mast(player_id)
);
--
CREATE TABLE IF NOT EXISTS goal_details
(
	pk_goal_id NUMERIC PRIMARY KEY,
	match_number NUMERIC REFERENCES match_mast(match_number),
	player_id NUMERIC REFERENCES player_mast(player_id),
	fk_team_id NUMERIC REFERENCES football_country(country_id),
	goal_time NUMERIC,
	goal_type CHARACTER(1),
	play_stage CHARACTER(1),
	goal_schedule CHARACTER(2),
	goal_half NUMERIC
);
--
CREATE TABLE IF NOT EXISTS penalty_shootout
(
	pk_kick_id NUMERIC PRIMARY KEY,
	match_number NUMERIC REFERENCES match_mast(match_number),
	fk_team_id NUMERIC REFERENCES football_country(country_id),
	player_id NUMERIC REFERENCES player_mast(player_id),
	score_goal VARCHAR(1),
	kick_number NUMERIC
);
--
CREATE TABLE IF NOT EXISTS player_booked
(
	match_number NUMERIC REFERENCES match_mast(match_number),
	fk_team_id NUMERIC REFERENCES football_country(country_id),
	player_id NUMERIC REFERENCES player_mast(player_id),
	booking_time VARCHAR(40),
	sent_off CHARACTER(1),
	play_schedule CHARACTER(2),
	play_half NUMERIC
);
--
CREATE TABLE IF NOT EXISTS player_in_out
(
	match_number NUMERIC REFERENCES match_mast(match_number),
	fk_team_id NUMERIC REFERENCES football_country(country_id),
	player_id NUMERIC REFERENCES player_mast(player_id),
	in_out CHARACTER(1),
	time_in_out NUMERIC,
	play_schedule CHARACTER(2),
	play_half NUMERIC
);
--
CREATE TABLE IF NOT EXISTS match_captain
(
	match_number NUMERIC REFERENCES match_mast(match_number),
	fk_team_id NUMERIC REFERENCES football_country(country_id),
	fk_player_captain NUMERIC REFERENCES player_mast(player_id)
);
--
CREATE TABLE IF NOT EXISTS team_coaches
(
	fk_team_id NUMERIC REFERENCES football_country(country_id),
	fk_coach_id NUMERIC REFERENCES coach_mast(pk_coach_id)
);
--
CREATE TABLE IF NOT EXISTS penalty_goal_keeper
(
	match_number NUMERIC REFERENCES match_mast(match_number),
	fk_team_id NUMERIC REFERENCES football_country(country_id),
	fk_player_goal_keeper NUMERIC REFERENCES player_mast(player_id)
);
-- Список всіх таблиць
\d
-- Втавлення даних в таблиці
\copy football_country FROM 'C:\Users\User\Desktop\CourseWork\CSV\football_country.csv' DELIMITER ';' CSV
\copy football_city FROM 'C:\Users\User\Desktop\CourseWork\CSV\football_city.csv' DELIMITER ';' CSV
\copy football_venue FROM 'C:\Users\User\Desktop\CourseWork\CSV\football_venue.csv' DELIMITER ';' CSV
\copy football_team FROM 'C:\Users\User\Desktop\CourseWork\CSV\football_team.csv' DELIMITER ';' CSV
\copy referee_mast FROM 'C:\Users\User\Desktop\CourseWork\CSV\referee_mast.csv' DELIMITER ';' CSV
\copy coach_mast FROM 'C:\Users\User\Desktop\CourseWork\CSV\coach_mast.csv' DELIMITER ';' CSV
\copy assistant_referee_mast FROM 'C:\Users\User\Desktop\CourseWork\CSV\assistant_referee_mast.csv' DELIMITER ';' CSV
\copy team_coaches FROM 'C:\Users\User\Desktop\CourseWork\CSV\team_coaches.csv' DELIMITER ';' CSV
\copy playing_position FROM 'C:\Users\User\Desktop\CourseWork\CSV\playing_position.csv' DELIMITER ';' CSV
\copy player_mast FROM 'C:\Users\User\Desktop\CourseWork\CSV\player_mast.csv' DELIMITER ';' CSV
\copy match_mast FROM 'C:\Users\User\Desktop\CourseWork\CSV\match_mast.csv' DELIMITER ';' CSV
\copy match_details FROM 'C:\Users\User\Desktop\CourseWork\CSV\match_details.csv' DELIMITER ';' CSV
\copy penalty_shootout FROM 'C:\Users\User\Desktop\CourseWork\CSV\penalty_shootout.csv' DELIMITER ';' CSV
\copy player_booked FROM 'C:\Users\User\Desktop\CourseWork\CSV\player_booked.csv' DELIMITER ';' CSV
\copy player_in_out FROM 'C:\Users\User\Desktop\CourseWork\CSV\player_in_out.csv' DELIMITER ';' CSV
\copy match_captain FROM 'C:\Users\User\Desktop\CourseWork\CSV\match_captain.csv' DELIMITER ';' CSV
\copy penalty_goal_keeper FROM 'C:\Users\User\Desktop\CourseWork\CSV\penalty_goal_keeper.csv' DELIMITER ';' CSV
\copy goal_details FROM 'C:\Users\User\Desktop\CourseWork\CSV\goal_details.csv' DELIMITER ';' CSV
-- Створення процедури
CREATE OR REPLACE PROCEDURE create_temp_table_football_country()
AS
$$
BEGIN
    CREATE TEMP TABLE IF NOT EXISTS temp_table_football_country AS
    SELECT concat(FC.country_abbreviation, ' ', FC.country_name)
    FROM football_country AS FC;
END;
$$ LANGUAGE plpgsql;

CALL create_temp_table_football_country();
SELECT *
FROM temp_table_football_country;
DROP TABLE IF EXISTS temp_table_football_country;
-- Створення представлення
--
CREATE VIEW "Number of matches played by Germany" AS
SELECT match_number,
       country_name
FROM penalty_shootout a
JOIN football_country c ON a.fk_team_id=c.country_id
WHERE match_number=
    (SELECT match_number
     FROM penalty_shootout
     WHERE pk_kick_id=26)
  AND country_name<>
    (SELECT country_name
     FROM football_country
     WHERE country_id=
         (SELECT fk_team_id
          FROM penalty_shootout
          WHERE pk_kick_id=26))
GROUP BY match_number,
         country_name;
-- Отримання даних з представлення
SELECT * FROM "Number of matches played by Germany";
-- Створення функції
CREATE OR REPLACE FUNCTION check_if_table_exists(schema_name VARCHAR, _table_name VARCHAR)
    RETURNS BOOLEAN
AS
$$
SELECT EXISTS(
               SELECT
               FROM information_schema.tables
               WHERE table_schema = schema_name
                 AND table_name = _table_name
           );
$$ LANGUAGE sql;
-- Перевірка роботи функції
SELECT check_if_table_exists('public', 'football_country');
-- Запити для вибірки даних
--
SELECT c.match_number,a.country_name AS "Team", 
b.player_name, b.jersey_number, c.score_goal ,c.kick_number
FROM football_country a, penalty_shootout c, player_mast b
WHERE c.fk_team_id=a.country_id
AND c.player_id=b.player_id;
--
SELECT a.country_name, COUNT(b.*) as "Number of Shots" 
FROM football_country a, penalty_shootout b
WHERE b.fk_team_id=a.country_id
GROUP BY a.country_name;
--
SELECT play_half,play_schedule,COUNT(*) 
FROM player_booked
WHERE play_schedule='NT'
GROUP BY play_half,play_schedule;
--
SELECT play_half,play_schedule,COUNT(*) 
FROM player_in_out 
WHERE in_out='I'
GROUP BY play_half,play_schedule
ORDER BY play_half,play_schedule,count(*) DESC;
--
SELECT COUNT(goal_score) 
FROM match_details 
WHERE win_lose='W' 
AND decided_by<>'P'
AND goal_score=1;
-- Запити з підзапитами для вибірки даних
--
SELECT match_number,country_name, player_name, COUNT(match_number)
FROM goal_details a, football_country b, player_mast c
WHERE a.fk_team_id=b.country_id
AND a.player_id=c.player_id
GROUP BY match_number,country_name,player_name
ORDER BY match_number;
--
SELECT country_name
FROM football_country
WHERE country_id IN(
   SELECT fk_team_id 
   FROM goal_details 
   WHERE match_number=(
     SELECT match_number 
     FROM match_mast 
     WHERE audence=(
       SELECT max(audence) 
       FROM match_mast)
ORDER BY audence DESC));
--
SELECT player_name,jersey_number 
FROM player_mast 
WHERE player_id=(
SELECT player_id 
FROM goal_details 
WHERE goal_type='P' AND match_number=(
SELECT MIN(match_number) 
FROM goal_details 
WHERE goal_type='P' AND play_stage='G'));
--
SELECT MAX(stop2_second) 
FROM match_mast
WHERE stop2_second<>(
SELECT MAX(stop2_second) 
FROM match_mast);
--
SELECT country_name 
FROM football_country 
WHERE country_id IN(
SELECT fk_team_id 
FROM match_details 
WHERE match_number IN(
SELECT match_number 
FROM match_mast 
WHERE stop2_second=(
SELECT max(stop2_second) 
FROM match_mast
WHERE stop2_second<>(
SELECT max(stop2_second) 
FROM match_mast))));
-- Запити з JOIN для вибірки даних
--
SELECT match_details.match_number, football_country.country_name 
FROM match_mast
JOIN match_details 
ON match_mast.match_number=match_details.match_number
JOIN football_country
ON match_details.fk_team_id=football_country.country_id
WHERE stop1_second=0;
--
SELECT country_name,team_group,match_played,
won,lost,goal_for,goal_against
FROM football_team 
JOIN football_country 
ON football_team.fk_team_id=football_country.country_id
WHERE goal_against=(
SELECT MAX(goal_against) 
FROM football_team);
--
SELECT match_details.match_number, football_country.country_name,
match_mast.stop2_second as "Stoppage Time(sec.)" 
FROM match_mast
JOIN match_details 
ON match_mast.match_number=match_details.match_number
JOIN football_country
ON match_details.fk_team_id=football_country.country_id
WHERE stop2_second IN (
SELECT MAX(stop2_second) 
FROM match_mast);
--
SELECT match_number,country_name 
FROM match_details
JOIN football_country ON football_country.country_id=match_details.fk_team_id
WHERE win_lose='D' AND goal_score=0 AND play_stage='G' 
ORDER BY match_number;
--
SELECT a.match_number, c.country_name, a.stop2_second
FROM match_mast a
JOIN match_details b ON a.match_number=b.match_number
JOIN football_country c ON b.fk_team_id=c.country_id
WHERE (2-1) = (
SELECT COUNT(DISTINCT(b.stop2_second))
FROM match_mast b
WHERE b.stop2_second > a.stop2_second);
--
SELECT b.country_name,c.player_name,COUNT(a.fk_player_goal_keeper) count_gk
FROM match_details a
JOIN football_country b ON a.fk_team_id=b.country_id
JOIN player_mast c ON a.fk_player_goal_keeper=c.player_id
GROUP BY b.country_name,c.player_name
ORDER BY country_name,player_name,count_gk DESC;
--
SELECT venue_name, count(venue_name)
FROM goal_details
JOIN football_country
ON goal_details.fk_team_id=football_country.country_id
JOIN match_mast ON goal_details.match_number=match_mast.match_number
JOIN football_venue ON match_mast.venue_id=football_venue.venue_id
GROUP BY venue_name
HAVING COUNT (venue_name)=( 
SELECT MAX(mycount) 
FROM ( 
SELECT venue_name, COUNT(venue_name) mycount
FROM goal_details
JOIN football_country
ON goal_details.fk_team_id=football_country.country_id
JOIN match_mast ON goal_details.match_number=match_mast.match_number
JOIN football_venue ON match_mast.venue_id=football_venue.venue_id
GROUP BY venue_name) gd);
--
SELECT a.country_name,b.player_name,b.jersey_number,b.age 
FROM football_country a
JOIN player_mast b 
ON a.country_id=b.fk_team_id
WHERE b.age IN (
SELECT MAX(age) 
FROM player_mast);
--
SELECT match_number,country_name
FROM match_details a
JOIN football_country b
ON a.fk_team_id=b.country_id
WHERE goal_score=3  AND win_lose='D';
--
SELECT a.country_name as Team , b.team_group,b.match_played, 
b.goal_against, b.group_position 
FROM football_country a
JOIN football_team b
ON a.country_id=b.fk_team_id
WHERE goal_against=4 AND group_position=4
ORDER BY team_group;
