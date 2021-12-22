-- Запити для вибірки даних
--
SELECT COUNT(*) 
FROM football_venue;
--
SELECT COUNT(DISTINCT fk_team_id) 
FROM player_mast;
--
SELECT COUNT(*) 
FROM goal_details;
--
SELECT COUNT(*) 
FROM match_mast 
WHERE results='WIN';
--
SELECT COUNT(*) 
FROM match_mast 
WHERE results='DRAW';
--
SELECT play_date "Beginning Date"
FROM match_mast
WHERE match_number=1;
--
SELECT COUNT(*) 
FROM goal_details 
WHERE goal_type='O';
--
SELECT COUNT(*) 
FROM match_mast 
WHERE results='WIN' 
AND play_stage='G';
--
SELECT COUNT(DISTINCT match_number) 
FROM penalty_shootout;
--
SELECT COUNT(*) 
FROM match_mast 
WHERE decided_by='P' AND play_stage='R';
--
SELECT match_number,COUNT(*) 
FROM goal_details 
GROUP BY match_number 
ORDER BY match_number;
--
SELECT match_number, play_date, goal_score 
FROM  match_mast
WHERE stop1_second=0;
--
SELECT COUNT(DISTINCT(match_number))
FROM match_details
WHERE win_lose='D' 
AND goal_score=0 AND play_stage='G';
--
SELECT COUNT(goal_score) 
FROM match_details 
WHERE win_lose='W' 
AND decided_by<>'P'
AND goal_score=1;
--
SELECT COUNT(*) as "Player Replaced"
FROM player_in_out
WHERE in_out='I';
--
SELECT COUNT(*) as "Player Replaced"
FROM player_in_out
WHERE in_out='I' 
AND play_schedule='NT';
--
SELECT COUNT(*) as "Player Replaced"
FROM player_in_out
WHERE in_out='I' 
AND play_schedule='ST';
--
SELECT COUNT(*) as "Player Replaced"
FROM player_in_out
WHERE in_out='I'
AND play_schedule='NT'
AND play_half=1;
--
SELECT COUNT(DISTINCT match_number) 
FROM match_details 
WHERE win_lose='D' 
AND goal_score=0;
--
SELECT COUNT(*) 
FROM  player_in_out 
WHERE play_schedule='ET'
AND in_out='I';
--
SELECT play_half,play_schedule,COUNT(*) 
FROM player_in_out 
WHERE in_out='I'
GROUP BY play_half,play_schedule
ORDER BY play_half,play_schedule,count(*) DESC;
--
SELECT COUNT(*) AS "Number of Penalty Kicks"
FROM penalty_shootout;
--
SELECT COUNT(*) AS "Goal Scored by Penalty Kicks"
FROM penalty_shootout
WHERE score_goal='Y';
--
SELECT COUNT(*) AS "Goal missed or saved by Penalty Kicks"
FROM penalty_shootout
WHERE score_goal='N';
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
SELECT COUNT(*) 
FROM player_booked
WHERE play_schedule='ST';
--
SELECT COUNT(*)
FROM player_booked
WHERE play_schedule='ET';
-- Запити з підзапитами для вибірки даних
--
SELECT match_number,country_name
FROM match_details a, football_country b
WHERE a.fk_team_id=b.country_id
AND a.match_number=1;
--
SELECT country_name as Team 
FROM football_country 
WHERE country_id in (
SELECT fk_team_id 
FROM match_details 
WHERE play_stage='F' and win_lose='W');
--
SELECT match_number, play_stage, goal_score, audence 
FROM match_mast 
WHERE audence=(
SELECT max(audence) 
FROM match_mast);
--
SELECT match_number 
FROM match_details 
WHERE fk_team_id=(
SELECT country_id 
FROM football_country 
WHERE country_name='Germany') 
OR fk_team_id=(
SELECT country_id 
FROM football_country 
WHERE country_name='Poland') 
GROUP BY match_number 
HAVING COUNT(DISTINCT fk_team_id)=2;
--
SELECT match_number, play_stage, play_date, results, goal_score
FROM match_mast
WHERE match_number 
IN(
SELECT match_number 
FROM match_details 
WHERE fk_team_id=(
	SELECT country_id 
	FROM football_country 
	WHERE country_name='Portugal') OR fk_team_id=(
		SELECT country_id 
		FROM football_country 
		WHERE country_name='Hungary') 
GROUP BY match_number 
HAVING COUNT(DISTINCT fk_team_id)=2);
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
SELECT player_name 
FROM player_mast 
WHERE player_id=(
  SELECT player_id 
  FROM goal_details 
    where match_number=(SELECT match_number FROM match_details 
WHERE fk_team_id=(
SELECT country_id FROM football_country 
WHERE country_name='Hungary') 
or fk_team_id=(SELECT country_id FROM football_country 
WHERE country_name='Portugal') 
GROUP BY match_number HAVING COUNT(DISTINCT fk_team_id)=2) 
    AND fk_team_id=(SELECT fk_team_id
FROM football_country a, football_team b
WHERE a.country_id=b.fk_team_id AND country_name='Portugal') 
    AND goal_time=(
      SELECT max(goal_time) 
      FROM goal_details 
        WHERE match_number=(SELECT match_number FROM match_details 
WHERE fk_team_id=(
SELECT country_id FROM football_country 
WHERE country_name='Hungary') 
or fk_team_id=(SELECT country_id FROM football_country 
WHERE country_name='Portugal') 
GROUP BY match_number HAVING COUNT(DISTINCT fk_team_id)=2) AND fk_team_id=(
SELECT fk_team_id
FROM football_country a, football_team b
WHERE a.country_id=b.fk_team_id AND country_name='Portugal'))
                );
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
--
SELECT match_number,play_date,stop2_second
FROM match_mast a
WHERE (2-1) = (
SELECT COUNT(DISTINCT(b.stop2_second))
FROM match_mast b
WHERE b.stop2_second > a.stop2_second);
--
SELECT country_name 
FROM football_country 
WHERE country_id=(
SELECT fk_team_id 
FROM match_details 
WHERE play_stage='F'
AND fk_team_id<>(
SELECT country_id 
FROM football_country 
WHERE country_name='Portugal'));
--
SELECT playing_club, COUNT(playing_club) 
FROM player_mast  GROUP BY playing_club 
HAVING COUNT (playing_club)=( 
SELECT MAX(mycount) 
FROM ( 
SELECT playing_club, COUNT(playing_club) mycount 
FROM player_mast 
GROUP BY playing_club) pm);
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
SELECT a.player_name,a.jersey_number,d.country_name
FROM player_mast a, goal_details b, goal_details c, football_country d
WHERE a.player_id=b.player_id AND a.fk_team_id=d.country_id AND 
a.player_id=(
SELECT b.player_id 
FROM goal_details b
WHERE b.goal_type='P' AND b.match_number=(
SELECT MIN(c.match_number) 
FROM goal_details c
WHERE c.goal_type='P' AND c.play_stage='G'))
GROUP BY player_name,jersey_number,country_name;
--
SELECT player_name 
FROM player_mast 
WHERE player_id=(
SELECT fk_player_goal_keeper 
FROM penalty_goal_keeper 
WHERE match_number=(
SELECT match_number 
FROM penalty_goal_keeper
WHERE fk_team_id=(
SELECT country_id 
FROM football_country 
WHERE country_name='Italy') 
OR fk_team_id=(
SELECT country_id 
FROM football_country 
WHERE country_name='Germany') 
GROUP BY match_number 
HAVING COUNT(DISTINCT fk_team_id)=2
) 
AND fk_team_id=(
SELECT country_id 
FROM football_country 
WHERE country_name='Italy')
);
--
SELECT COUNT(player_id) 
FROM goal_details 
WHERE fk_team_id=
(
SELECT country_id 
FROM football_country
WHERE country_name='Germany'
);
--
SELECT player_name, jersey_number, playing_club 
FROM player_mast 
WHERE fk_position_to_play='GK' AND fk_team_id=(
SELECT country_id 
FROM football_country
WHERE country_name='England');
--
SELECT player_name, jersey_number, fk_position_to_play, age
FROM player_mast 
WHERE playing_club='Liverpool'
AND fk_team_id=(
SELECT country_id
FROM football_country
WHERE country_name='England'
);
--
SELECT a.player_name, b.goal_time, b.goal_half, c.country_name
FROM player_mast a, goal_details b,football_country c
WHERE a.player_id=b.player_id
AND b.fk_team_id=c.country_id
AND match_number=50
AND goal_time= (
SELECT MAX(goal_time) 
FROM  goal_details 
WHERE match_number=50);
--
SELECT player_name
FROM player_mast
WHERE player_id IN (
SELECT fk_player_captain 
FROM match_captain
WHERE  fk_team_id=(
SELECT fk_team_id
FROM match_details
WHERE play_stage='F' AND win_lose='W'));
--
SELECT COUNT(*)+11 as "Number of players shared fields" 
FROM player_in_out 
WHERE match_number=(
SELECT match_number 
FROM match_mast 
WHERE play_stage='F')
AND in_out='I' 
AND fk_team_id=(
SELECT country_id 
FROM football_country 
WHERE country_name='France');
--
SELECT player_name,jersey_number 
FROM player_mast 
WHERE player_id IN(
SELECT fk_player_goal_keeper 
FROM match_details 
WHERE  play_stage='G' and fk_team_id IN(
SELECT country_id 
FROM football_country 
WHERE country_name='Germany'));
--
SELECT country_name 
FROM football_country 
WHERE country_id=(
SELECT fk_team_id 
FROM match_details 
WHERE play_stage='F' AND win_lose='L'
AND fk_team_id<>(
SELECT country_id 
FROM football_country 
WHERE country_name='Portugal'));
--
SELECT a.country_name, COUNT(b.*) shots 
FROM football_country a, penalty_shootout b
WHERE b.fk_team_id=a.country_id
GROUP BY a.country_name
having COUNT(b.*)=(
SELECT MAX(shots) FROM (
SELECT COUNT(*) shots 
FROM penalty_shootout
GROUP BY fk_team_id) inner_result);
--
SELECT c.country_name,a.player_name, a.jersey_number,COUNT(b.*) shots 
FROM player_mast a, penalty_shootout b, football_country c
WHERE b.player_id=a.player_id
AND b.fk_team_id=c.country_id
GROUP BY c.country_name,a.player_name,a.jersey_number
HAVING COUNT(b.*)=(
SELECT MAX(shots) FROM (
SELECT COUNT(*) shots 
FROM penalty_shootout
GROUP BY player_id) inner_result);
--
SELECT match_number,
       COUNT(*) shots
FROM penalty_shootout
GROUP BY match_number
HAVING COUNT(*)=
  (SELECT MAX(shots)
   FROM
     (SELECT COUNT(*) shots
      FROM penalty_shootout
      GROUP BY match_number) inner_result);
--
SELECT b.match_number,
       a.country_name
FROM penalty_shootout b,
     football_country a
WHERE b.fk_team_id=a.country_id
  AND match_number=
    (SELECT match_number
     FROM penalty_shootout
     GROUP BY match_number
     HAVING COUNT(*)=
       (SELECT MAX(shots)
        FROM
          (SELECT COUNT(*) shots
           FROM penalty_shootout
           GROUP BY match_number) inner_result))
GROUP BY b.match_number,
         a.country_name;
--
SELECT a.match_number,
       b.player_name,
       a.kick_number
FROM penalty_shootout a,
     player_mast b
WHERE a.player_id=b.player_id
  AND kick_number=7
  AND match_number=
    (SELECT match_number
     FROM penalty_shootout
     WHERE fk_team_id =
         (SELECT country_id
          FROM football_country
          WHERE country_name='Portugal' )
     GROUP BY match_number)
GROUP BY match_number,
         player_name,
         pk_kick_id;
--
SELECT match_number,
       play_stage
FROM match_mast
WHERE match_number=
    (SELECT match_number
     FROM penalty_shootout
     WHERE pk_kick_id=23);
--
SELECT venue_name
FROM football_venue
WHERE venue_id IN
    (SELECT venue_id
     FROM match_mast
     WHERE match_number IN
         (SELECT DISTINCT match_number
          FROM penalty_shootout));
--
SELECT play_date
FROM match_mast
WHERE match_number IN
    (SELECT DISTINCT match_number
     FROM penalty_shootout);
--
SELECT min(goal_time) AS "Most quickest goal after 5 minutes"
FROM
  (SELECT match_number,
          goal_time
   FROM goal_details
   WHERE goal_time>5
   GROUP BY match_number,
            goal_time
   ORDER BY goal_time) hh;
-- Запити з JOIN для вибірки даних
--
SELECT venue_name, city
FROM football_venue a
JOIN football_city b ON a.pk_city_id=b.pk_city_id
JOIN match_mast d ON d.venue_id=a.venue_id 
AND d.play_stage='F';
--
SELECT match_number,country_name,goal_score
FROM match_details a
JOIN football_country b
ON a.fk_team_id=b.country_id
WHERE decided_by='N'
ORDER BY match_number;
--
SELECT player_name,count(*),country_name
FROM goal_details a
JOIN player_mast b ON a.player_id=b.player_id
JOIN football_country c ON a.fk_team_id=c.country_id
WHERE goal_schedule = 'NT'
GROUP BY player_name,country_name
ORDER BY count(*) DESC;
--
SELECT player_name,country_name,count(player_name)
FROM goal_details gd
JOIN player_mast pm ON gd.player_id =pm.player_id
JOIN football_country sc ON pm.fk_team_id = sc.country_id
GROUP BY country_name,player_name HAVING COUNT(player_name) >= ALL
  (SELECT COUNT(player_name)
   FROM goal_details gd
   JOIN player_mast pm ON gd.player_id =pm.player_id
   JOIN football_country sc ON pm.fk_team_id = sc.country_id
   GROUP BY country_name,player_name);
--
SELECT player_name,jersey_number,country_name
FROM goal_details a
JOIN player_mast b ON a.player_id=b.player_id
JOIN football_country c ON a.fk_team_id=c.country_id
WHERE play_stage='F';
--
SELECT country_name
FROM football_country a
JOIN football_city b ON a.country_id=b.country_id
JOIN football_venue c ON b.pk_city_id=c.pk_city_id
GROUP BY country_name;
--
SELECT a.player_name,a.jersey_number,b.country_name,c.goal_time,
c.play_stage,c.goal_schedule, c.goal_half 
FROM player_mast a
JOIN football_country b
ON a.fk_team_id=b.country_id
JOIN goal_details c
ON c.player_id=a.player_id
WHERE pk_goal_id=1;
--
SELECT b.referee_name, c.country_name 
FROM match_mast a
NATURAL JOIN referee_mast b 
NATURAL JOIN football_country c
WHERE match_number=1;
--
SELECT b.referee_name, c.country_name 
FROM match_mast a
NATURAL JOIN referee_mast b 
NATURAL JOIN football_country c
WHERE play_stage='F';
--
SELECT assistant_referee_name, country_name 
FROM assistant_referee_mast a
JOIN football_country b
ON a.country_id=b.country_id
JOIN match_details c
ON a.pk_assistant_referee_id=c.fk_assistant_referee
WHERE match_number=1;
--
SELECT assistant_referee_name, country_name 
FROM assistant_referee_mast a
JOIN football_country b
ON a.country_id=b.country_id
JOIN match_details c
ON a.pk_assistant_referee_id=c.fk_assistant_referee
WHERE play_stage='F';
--
SELECT a.venue_name, b.city
FROM football_venue a
JOIN football_city b ON a.pk_city_id=b.pk_city_id
JOIN match_mast c ON a.venue_id=c.venue_id
WHERE match_number=1;
--
SELECT a.venue_name, b.city, a.aud_capacity, c.audence
FROM football_venue a
JOIN football_city b ON a.pk_city_id=b.pk_city_id
JOIN match_mast c ON a.venue_id=c.venue_id
WHERE play_stage='F';
--
SELECT a.venue_name, b.city, count(c.match_number)
FROM football_venue a
JOIN football_city b ON a.pk_city_id=b.pk_city_id
JOIN match_mast c ON a.venue_id=c.venue_id
GROUP BY venue_name,city
ORDER BY venue_name;
--
SELECT match_number, country_name, player_name, 
booking_time as "sent_off_time", play_schedule, jersey_number
FROM player_booked a
JOIN player_mast b
ON a.player_id=b.player_id
JOIN football_country c
ON a.fk_team_id=c.country_id
AND  a.sent_off='Y'
AND match_number=(
	SELECT MIN(match_number) 
	from player_booked)
ORDER BY match_number,play_schedule,play_half,booking_time;
--
SELECT country_name as "Team" ,team_group, goal_for
FROM football_team
JOIN football_country 
ON football_team.fk_team_id=football_country.country_id
AND goal_for=1;
--
SELECT country_name, COUNT(*)
FROM football_country 
JOIN player_booked
ON football_country.country_id=player_booked.fk_team_id
GROUP BY country_name
ORDER BY COUNT(*) DESC;
--
SELECT venue_name, count(venue_name)
FROM goal_details
JOIN football_country
ON goal_details.fk_team_id=football_country.country_id
JOIN match_mast ON goal_details.match_number=match_mast.match_number
JOIN football_venue ON match_mast.venue_id=football_venue.venue_id
GROUP BY venue_name
ORDER BY COUNT(venue_name) DESC;
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
--
SELECT a.player_name, a.jersey_number, a.fk_position_to_play, a.age, b.country_name
FROM player_mast a 
JOIN football_country b
ON a.fk_team_id=b.country_id
WHERE a.playing_club='Lyon'
AND a.fk_team_id IN (
SELECT b.country_id 
FROM football_country b
WHERE b.country_id IN (
SELECT c.fk_team_id 
FROM match_details c 
WHERE c.play_stage='F'
));
--
SELECT country_name
FROM match_details a
JOIN football_country b
ON a.fk_team_id=b.country_id
WHERE play_stage='S';
--
SELECT country_name, player_name, jersey_number, fk_position_to_play 
FROM match_captain a
JOIN football_country b ON a.fk_team_id=b.country_id
JOIN player_mast c ON a.fk_player_captain=c.player_id
WHERE match_number IN(48,49);
--
SELECT match_number,country_name, player_name, jersey_number, fk_position_to_play 
FROM match_captain a
JOIN football_country b ON a.fk_team_id=b.country_id
JOIN player_mast c ON a.fk_player_captain=c.player_id
ORDER BY match_number;
--
SELECT a.match_number,c.player_name as "Captain", 
d.player_name as "Goal Keeper",e.country_name
FROM match_captain a
NATURAL JOIN match_details b
JOIN football_country e ON b.fk_team_id=e.country_id
JOIN player_mast c ON a.fk_player_captain=c.player_id
JOIN player_mast d ON b.fk_player_goal_keeper=d.player_id;
--
SELECT a.player_name, b.country_name
FROM player_mast a 
JOIN match_mast c ON c.fk_player_of_match=a.player_id
AND c.play_stage='F'
JOIN football_country b
ON a.fk_team_id=b.country_id;
--
SELECT match_number,country_name,player_name,jersey_number,time_in_out
FROM player_in_out a
JOIN player_mast b ON a.player_id=b.player_id
JOIN football_country c ON b.fk_team_id=c.country_id
WHERE a.in_out='I'
AND a.play_schedule='NT'
AND a.play_half=1
ORDER BY match_number;
--
SELECT match_number,play_date,country_name,
player_name AS "Player of the Match",jersey_number
FROM match_mast a
JOIN player_mast b ON 
a.fk_player_of_match=b.player_id
JOIN football_country c ON 
b.fk_team_id=c.country_id;
--
SELECT match_number,
       country_name,
       player_name
FROM penalty_shootout a
JOIN player_mast b ON a.player_id=b.player_id
JOIN football_country c ON b.fk_team_id=c.country_id
WHERE pk_kick_id=26;
--
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
--
SELECT match_number,
       country_name,
       player_name,
       jersey_number
FROM match_captain a
JOIN football_country b ON a.fk_team_id=b.country_id
JOIN player_mast c ON a.fk_player_captain=c.player_id
AND fk_position_to_play='GK'
ORDER BY match_number;
--
SELECT count(DISTINCT player_name)
FROM match_captain a
JOIN football_country b ON a.fk_team_id=b.country_id
JOIN player_mast c ON a.fk_player_captain=c.player_id
AND fk_position_to_play='GK';
--
SELECT a.country_name,c.player_name,COUNT(b.*) Booked 
FROM football_country a
JOIN player_booked b ON a.country_id=b.fk_team_id
JOIN player_mast c ON b.player_id=c.player_id
GROUP BY a.country_name,c.player_name
ORDER BY a.country_name,Booked DESC;
--
SELECT c.player_name,COUNT(b.*) Booked 
FROM football_country a
JOIN player_booked b ON a.country_id=b.fk_team_id
JOIN player_mast c ON b.player_id=c.player_id
GROUP BY c.player_name
having COUNT(b.*)=(
SELECT MAX(mm) FROM (
SELECT COUNT(*) mm 
FROM player_booked 
GROUP BY player_id) inner_result);
--
SELECT a.country_name,COUNT(b.*) Booked 
FROM football_country a
JOIN player_booked b ON a.country_id=b.fk_team_id
GROUP BY a.country_name
ORDER BY Booked DESC;
--
SELECT match_number, Booked FROM (
SELECT match_number,COUNT(*) Booked 
FROM player_booked  
GROUP BY match_number) M1 where Booked=(
SELECT MAX(MX1) 
FROM (SELECT match_number,COUNT(*) MX1 
FROM player_booked  
GROUP BY match_number) M2);
--
SELECT a.match_number,
       b.country_name,
       c.assistant_referee_name
FROM match_details a
JOIN assistant_referee_mast c ON a.fk_assistant_referee=c.pk_assistant_referee_id
JOIN football_country b ON c.country_id=b.country_id
ORDER BY a.match_number;
--
SELECT country_name,
       count(DISTINCT match_number)
FROM match_details a
JOIN assistant_referee_mast c ON a.fk_assistant_referee=c.pk_assistant_referee_id
JOIN football_country b ON c.country_id=b.country_id
GROUP BY country_name
ORDER BY count(*) DESC;
--
SELECT country_name,
       count(DISTINCT match_number)
FROM match_details a
JOIN assistant_referee_mast c ON a.fk_assistant_referee=c.pk_assistant_referee_id
JOIN football_country b ON c.country_id=b.country_id
GROUP BY country_name
HAVING count(DISTINCT match_number)=
  (SELECT max(mm)
   FROM
     (SELECT count(DISTINCT match_number) mm
      FROM match_details a
      JOIN assistant_referee_mast c ON a.fk_assistant_referee=c.pk_assistant_referee_id
      JOIN football_country b ON c.country_id=b.country_id
      GROUP BY country_name) hh);
--
SELECT a.match_number,
       b.country_name,
       c.referee_name
FROM match_mast a
JOIN referee_mast c ON a.referee_id=c.referee_id
JOIN football_country b ON c.country_id=b.country_id
ORDER BY a.match_number;
--
SELECT country_name,
       count(match_number)
FROM match_mast a
JOIN referee_mast c ON a.referee_id=c.referee_id
JOIN football_country b ON c.country_id=b.country_id
GROUP BY country_name
ORDER BY count(match_number) DESC;
--
SELECT country_name,
       count(match_number)
FROM match_mast a
JOIN referee_mast c ON a.referee_id=c.referee_id
JOIN football_country b ON c.country_id=b.country_id
GROUP BY country_name
HAVING count(match_number)=
  (SELECT max(mm)
   FROM
     (SELECT count(match_number) mm
      FROM match_mast a
      JOIN referee_mast c ON a.referee_id=c.referee_id
      JOIN football_country b ON c.country_id=b.country_id
      GROUP BY country_name) hh);
--
SELECT c.referee_name,
       b.country_name,
       count(a.match_number)
FROM match_mast a
JOIN referee_mast c ON a.referee_id=c.referee_id
JOIN football_country b ON c.country_id=b.country_id
GROUP BY c.referee_name,
         b.country_name;
--
SELECT c.referee_name,
       b.country_name,
       count(a.match_number)
FROM match_mast a
JOIN referee_mast c ON a.referee_id=c.referee_id
JOIN football_country b ON c.country_id=b.country_id
GROUP BY c.referee_name,
         b.country_name
HAVING count(a.match_number) =
  (SELECT max(mm)
   FROM
     (SELECT count(a.match_number) mm
      FROM match_mast a
      JOIN referee_mast c ON a.referee_id=c.referee_id
      JOIN football_country b ON c.country_id=b.country_id
      GROUP BY c.referee_name,
               b.country_name) hh);
--
SELECT c.referee_name,
       b.country_name,
       d.venue_name,
       count(a.match_number)
FROM match_mast a
JOIN referee_mast c ON a.referee_id=c.referee_id
JOIN football_country b ON c.country_id=b.country_id
JOIN football_venue d ON a.venue_id=d.venue_id
GROUP BY c.referee_name,
         country_name,
         venue_name
ORDER BY referee_name;
--
SELECT c.referee_name,
       count(b.match_number)
FROM player_booked a
JOIN match_mast b ON a.match_number=b.match_number
JOIN referee_mast c ON b.referee_id=c.referee_id
GROUP BY referee_name
ORDER BY count(b.match_number) DESC;
--
SELECT c.referee_name,
       count(b.match_number)
FROM player_booked a
JOIN match_mast b ON a.match_number=b.match_number
JOIN referee_mast c ON b.referee_id=c.referee_id
GROUP BY referee_name
HAVING count(b.match_number)=
  (SELECT max(mm)
   FROM
     (SELECT count(b.match_number) mm
      FROM player_booked a
      JOIN match_mast b ON a.match_number=b.match_number
      JOIN referee_mast c ON b.referee_id=c.referee_id
      GROUP BY referee_name) hh);
--
SELECT country_name,
       player_name,
       fk_position_to_play,
       age,
       playing_club
FROM player_mast a
JOIN football_country b ON a.fk_team_id=b.country_id
WHERE jersey_number=10
ORDER BY country_name;
--
SELECT player_name,
       jersey_number,
       country_name,
       age,
       playing_club
FROM goal_details a
JOIN player_mast b ON a.player_id=b.player_id
JOIN football_country c ON a.fk_team_id=c.country_id
WHERE fk_position_to_play='DF'
ORDER BY player_name;
--
SELECT player_name,
       jersey_number,
       country_name,
       age,
       fk_position_to_play,
       playing_club
FROM goal_details a
JOIN player_mast b ON a.player_id=b.player_id
JOIN football_country c ON a.fk_team_id=c.country_id
WHERE goal_type='O'
ORDER BY player_name;
--
SELECT match_number,
       play_stage,
       country_name,
       penalty_score
FROM match_details a
JOIN football_country b ON a.fk_team_id=b.country_id
WHERE decided_by='P'
ORDER BY match_number;
--
SELECT country_name,
       fk_position_to_play,
       count(*) AS "Number of goals"
FROM goal_details a
JOIN player_mast b ON a.player_id=b.player_id
JOIN football_country c ON a.fk_team_id=c.country_id
GROUP BY country_name,
         fk_position_to_play
ORDER BY country_name;
--
SELECT match_number,
       country_name,
       player_name,
       jersey_number,
       time_in_out
FROM player_in_out a
JOIN player_mast b ON a.player_id=b.player_id
JOIN football_country c ON a.fk_team_id=c.country_id
WHERE time_in_out=
    (SELECT max(time_in_out)
     FROM player_in_out)
  AND in_out='I';