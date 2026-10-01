#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~ Quite's Beauty Center ~~~\n"

MAIN_MENU() {
echo How can we help your beauty?
echo -e "\n1) Haircut\n2) Beard Trim\n3) Manicure and pedicure\n4) Laser session\n"
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
[1-4]) CUSTOMER_IDENTIFICATION ;;
*) MAIN_MENU ;;
esac
}

CUSTOMER_IDENTIFICATION() {
echo -e "\n~~ Setting an appointment ~~\n"
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]]
then
  echo -e "\nYou are not registered. Please, enter your name:"
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
echo -e "\nHello $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g'),\nWhat time would you like your $(echo $SERVICE_NAME | sed -E 's/^ *| *$//g') appointment?"
read SERVICE_TIME
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
if [[ $INSERT_APPOINTMENT == 'INSERT 0 1' ]]
then
  echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -E 's/^ *| *$//g') at $(echo $SERVICE_TIME | sed -E 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."
fi
}

MAIN_MENU