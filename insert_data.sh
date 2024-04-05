#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Clear all data in teams and game instanly
echo $($PSQL "TRUNCATE teams, games;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != winner && $OPPONENT != opponent ]] # By pass head column for teams
  then
    # get team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

    # if data team winner or opponent not found
    if [[ -z $WINNER_ID ]]
    then
      # insert data team winner
      INSERT_WINNER_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      if [[ $INSERT_WINNER_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams by winner, $WINNER 
      fi
    fi

    if [[ -z $OPPONENT_ID ]]
    then
      # insert data team opponent 
      INSERT_OPPONENT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      if [[ $INSERT_OPPONENT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams by opponent, $OPPONENT 
      fi
    fi

    # get new winner id or team_id of winner inserted success
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")

    # get new opponent id or team_id of opponent inserted success
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

    # get game id
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE round='$ROUND' AND (winner_id='$WINNER_ID' AND opponent_id='$OPPONENT_ID');")

    if [[ -z $GAME_ID ]]
    then
      # if game id not found then insert it
      INSERTED_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID);")
      if [[ $INSERTED_GAMES_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into games successfully $ROUND - $WINNER VS $OPPONENT GOALS: $WINNER_GOALS - $OPPONENT_GOALS
      fi
    fi

  fi
done
