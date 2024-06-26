#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #add each team that participated to the database.
  if [[ $WINNER != winner ]]
  then
    #get team_id for the $WINNER
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'") 
    #check to see if name at ID is null
    if [[ -z $WINNER_ID ]]
    then
      #if so, add $WINNER to database
      TEAM_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi

    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    
    if [[ $OPPONENT != opponent ]]
    then
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      if [[ -z $OPPONENT_ID ]]
      then
        TEAM_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      fi
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
  fi

  if [[ $YEAR != year ]]
  then
    GAME_STATS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done

