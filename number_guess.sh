#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
# prompt for username
echo Enter your username:
read USER_NAME
# get user
USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USER_NAME'")
# if not found
if [[ -z $USER_ID ]]
then
# create user
INSERT_USER_RESULT=$($PSQL "INSERT INTO users(name) VALUES('$USER_NAME')")
USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USER_NAME'")
echo Welcome, $USER_NAME! It looks like this is your first time here.
else
# print user stats
NUMBER_OF_GAMES=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id = $USER_ID")
BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM GAMES WHERE user_id = $USER_ID")

echo Welcome back, $USER_NAME! You have played $NUMBER_OF_GAMES games, and your best game took $BEST_GAME guesses.
fi
echo Guess the secret number between 1 and 1000:
NUMBER=$(($RANDOM%1000+1))
GUESSES=0
while (( GUESS != NUMBER ));
do
  ((GUESSES = GUESSES + 1))
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo That is not an integer, guess again:
  else
    if (( GUESS < NUMBER )) 
    then
      echo It\'s higher than that, guess again:
    fi
    if (( GUESS > NUMBER ))
    then
      echo It\'s lower than that, guess again:
    fi
  fi
done

INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, guesses) VALUES ($USER_ID, $GUESSES)")
echo You guessed it in $GUESSES tries. The secret number was $NUMBER. Nice job!
