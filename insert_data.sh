#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
echo $($PSQL "TRUNCATE teams,games")
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    if [[ $YEAR != 'year' ]]
      then
        TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        if [[ -z $TEAM_ID ]]
          then
            INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
            if [[ $INSERT_WINNER = "INSERT 0 1" ]]
              then
                echo Inserted $WINNER into teams.
            fi
        fi
    fi
  done

  cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    if [[ $YEAR != 'year' ]]
      then
        TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        if [[ -z $TEAM_ID ]]
          then
            INSERT_OPPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
            if [[ $INSERT_OPPONENT = "INSERT 0 1" ]]
              then
                echo Inserted $OPPONENT into teams.
            fi
        fi
    fi
  done

  cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
    do
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      if [[ $YEAR != 'year' ]]
        then
          GAME_ID=$($PSQL "SELECT game_id FROM games WHERE round='final'")
          if [[ -z $GAME_ID ]]
            then
              INSERT_TEAMS=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")
              if [[ $INSERT_TEAMS =  "INSERT 0 1" ]]
                then
                  echo Inserted into games: $YEAR $ROUND
              fi
          fi
      fi
    done
