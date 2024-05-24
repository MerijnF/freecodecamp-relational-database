#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# empty database 
echo $($PSQL "TRUNCATE TABLE games, teams;")

# loop over the csv file
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #skip first row;
  if [[ $YEAR != "year" ]]
  then
  # insert winner
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  if [[ -z $WINNER_ID ]]
  then
    INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
    if [[ $INSERT_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted team $WINNER
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi
  # insert opponent
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ -z $OPPONENT_ID ]]
  then
    INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
    if [[ $INSERT_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted team $OPPONENT
    fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi
  # insert game
  INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done
