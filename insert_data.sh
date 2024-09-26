#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Limpiar las tablas
echo $($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY")

# Leer el archivo CSV
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  # Saltar la primera línea
  if [[ $year != "year" ]]
  then
    # Insertar equipos
    # Insertar equipo ganador
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    if [[ -z $winner_id ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$winner')")
      winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    fi

    # Insertar equipo oponente
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    if [[ -z $opponent_id ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
      opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    fi

    # Insertar juego
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)")
  fi
done
