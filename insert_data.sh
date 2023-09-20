#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS=',' read YEAR ROUND WIN OPP WIN_GOALS OPP_GOALS
do
  if [[ $YEAR != year ]]
  then
    WIN_ID=$($PSQL "SELECT name FROM teams WHERE name='$WIN'")
    if [[ -z $WIN_ID ]]
    then
      INSERT_WIN=$($PSQL "INSERT INTO teams(name) VALUES('$WIN')")
      if [[ $INSERT_WIN == 'INSER 0 1' ]]
      then
        echo "Inserted to teams(a winner): $WIN_ID"
      fi
    fi

    OPP_ID=$($PSQL "SELECT name FROM teams WHERE name='$OPP'")
    if [[ -z $OPP_ID ]]
    then
      INSERT_OPP=$($PSQL "INSERT INTO teams(name) VALUES('$OPP')")
      if [[ $INSERT_OPP == 'INSERT 0 1' ]]
      then
        echo "Inserted to teams(a loser): $WIN_ID"
      fi    
    fi

  fi

done

# echo $($PSQL "SELECT team_id FROM teams")
cat games.csv | while IFS=',' read YEAR ROUND WIN OPP WIN_GOALS OPP_GOALS
do
  if [[ $YEAR != year ]]
  then
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WIN_GOALS, $OPP_GOALS)")
    echo "Inserted into games $WIN ($WIN_GOALS-$OPP_GOALS) $OPP "
  fi
done
