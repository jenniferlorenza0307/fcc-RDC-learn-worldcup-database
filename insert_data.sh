 #! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# TRUNCATE TABLE
echo "$($PSQL "TRUNCATE TABLE games, teams;")"

# READ games.csv
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $YEAR == "year" ]];
  then :
  else 

    # 1. INSERT TO TABLE "teams"
    # 1.1 For WINNER team
    # get team_id from "teams" table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    # echo $WINNER_ID
    # check if a team is already listed on "teams" table
    if [[ -z $WINNER_ID ]];
    then
      # insert if team is not yet listed there
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")"
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    fi

    # 1.2 For OPPONENT team
    # get team_id from "teams" table
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    if [[ -z $OPPONENT_ID ]];
    then 
      # insert if team is not yet listed there
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")"
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    fi

    # 2. INSERT TO TABLE "games"
    echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")"

  fi
done