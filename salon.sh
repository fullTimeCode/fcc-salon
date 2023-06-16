#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


echo -e "\n~~~~~ MY SALON ~~~~~"




MAIN_MENU() {
  echo -e "\nWelcome to My Salon, how can I help you?"
  SERVICE_MENU
  # read serice_id
  read SERVICE_ID_SELECTED
  
  MIN_SERVICE_ID=$($PSQL "SELECT MIN(service_id) FROM services")
  MAX_SERVICE_ID=$($PSQL "SELECT MAX(service_id) FROM services")
  

  if [[ $SERVICE_ID_SELECTED -ge $MIN_SERVICE_ID &&  $SERVICE_ID_SELECTED -le $MAX_SERVICE_ID ]]
  then
    # get the name of the selected service 
    SELECTED_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE' ")
     
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      # insert customer in customers table 
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (phone, name) values ('$CUSTOMER_PHONE','$CUSTOMER_NAME')") 
      
      # 
      MAKE_APPOINTMENT

    else 

      MAKE_APPOINTMENT
      
   fi


  else
    echo "Invalid id"
    SERVICE_MENU
  fi
}

SERVICE_MENU() {
  AVAILABLE_SERVICES=$($PSQL "SELECT * FROM SERVICES ORDER BY service_id")

  # display available services
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID  BAR  SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
}


MAKE_APPOINTMENT(){
   # get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE' ")
  # get appointment time from customer 
  echo -e "\nWhat time would you like your$SELECTED_SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  # insert the row into appointments table
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO appointments (customer_id , service_id, time) values ($CUSTOMER_ID, $SERVICE_ID_SELECTED,'$SERVICE_TIME')") 

  if [[ -n $INSERT_CUSTOMER_RESULT ]]
  then
  echo "I have put you down for a $SELECTED_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU