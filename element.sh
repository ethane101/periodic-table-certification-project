#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ $# -eq 0 ]]
then
  echo "Please provide an element as an argument."
else
  # check if a number is provided
  if (( $1 ))
  then
    # only possibility is it is referring to an atomic number
    
    if [[ -z "$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1;")" ]]
    then
      echo "I could not find that element in the database." # default error message
    else
    # info needed: number, name, symbol, type name, mass, melting/boiling point, 
      ELEMENT_NAME="$($PSQL "SELECT name FROM elements WHERE atomic_number=$1;")"
      ELEMENT_SYMBOL="$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1;")"
      ELEMENT_TYPE_ID="$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$1;")"
      ELEMENT_TYPE="$($PSQL "SELECT type FROM types WHERE type_id=$ELEMENT_TYPE_ID;")"
      ELEMENT_MASS="$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1;")"
      ELEMENT_MELTING="$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1;")"
      ELEMENT_BOILING="$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1;")"
      echo "The element with atomic number $1 is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING celsius and a boiling point of $ELEMENT_BOILING celsius."
    fi
  else
    # input is not a number, either: invalid, symbol, or element name
    ELEMENT_NUMBER="$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1';")"
    if [[ -z $ELEMENT_NUMBER ]]
    then
      ELEMENT_NUMBER="$($PSQL "SELECT atomic_number FROM elements WHERE name='$1';")"
      if [[ -z $ELEMENT_NUMBER ]]
      then
        echo "I could not find that element in the database."
      else
        # info needed: number, name, symbol, type name, mass, melting/boiling point, 
        ELEMENT_SYMBOL="$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ELEMENT_NUMBER;")"
        ELEMENT_TYPE_ID="$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ELEMENT_NUMBER;")"
        ELEMENT_TYPE="$($PSQL "SELECT type FROM types WHERE type_id=$ELEMENT_TYPE_ID;")"
        ELEMENT_MASS="$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ELEMENT_NUMBER;")"
        ELEMENT_MELTING="$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ELEMENT_NUMBER;")"
        ELEMENT_BOILING="$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ELEMENT_NUMBER;")"
        echo "The element with atomic number $ELEMENT_NUMBER is $1 ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $1 has a melting point of $ELEMENT_MELTING celsius and a boiling point of $ELEMENT_BOILING celsius."
      fi
    else
      # info needed: number, name, symbol, type name, mass, melting/boiling point, 
      ELEMENT_NAME="$($PSQL "SELECT name FROM elements WHERE atomic_number=$ELEMENT_NUMBER;")"
      ELEMENT_TYPE_ID="$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ELEMENT_NUMBER;")"
      ELEMENT_TYPE="$($PSQL "SELECT type FROM types WHERE type_id=$ELEMENT_TYPE_ID;")"
      ELEMENT_MASS="$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ELEMENT_NUMBER;")"
      ELEMENT_MELTING="$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ELEMENT_NUMBER;")"
      ELEMENT_BOILING="$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ELEMENT_NUMBER;")"
      echo "The element with atomic number $ELEMENT_NUMBER is $ELEMENT_NAME ($1). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING celsius and a boiling point of $ELEMENT_BOILING celsius."
    fi
  fi
fi