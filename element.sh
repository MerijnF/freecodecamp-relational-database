#!/bin/bash
if [[ -z $1 ]]
then 
  echo Please provide an element as an argument.
else
  ELEMENT=$(psql --username=freecodecamp --dbname=periodic_table -t --no-align -c "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number::text = '$1' OR symbol = '$1' OR name = '$1';")
  if [[ -z $ELEMENT ]]
  then 
    echo I could not find that element in the database.
  else 
    IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< $ELEMENT
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
