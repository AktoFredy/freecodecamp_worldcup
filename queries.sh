#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT (SUM(winner_goals) + SUM(opponent_goals)) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT ROUND((AVG(winner_goals) + AVG(opponent_goals)), 16) from games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM games INNER JOIN teams ON (winner_id=team_id) WHERE YEAR=2018 AND round='Final'")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT DISTINCT t1.name AS team_name FROM games AS g INNER JOIN teams AS t1 ON (g.winner_id = t1.team_id) WHERE YEAR = 2014 AND round = 'Eighth-Final' UNION ALL SELECT DISTINCT t2.name AS team_name FROM games AS g INNER JOIN teams AS t2 ON (g.opponent_id = t2.team_id) WHERE YEAR = 2014 AND round = 'Eighth-Final' ORDER BY team_name ASC")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT(name) FROM games INNER JOIN teams ON(winner_id=team_id) ORDER BY name ASC")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT year, name FROM games INNER JOIN teams ON (winner_id=team_id) WHERE round='Final' ORDER BY game_id DESC")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"
