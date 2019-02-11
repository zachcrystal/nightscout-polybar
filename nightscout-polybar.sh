#!/bin/bash

URL= # Add your Nightscout URL here
USEMMOL=true # true if you use mmol/l units. false if you use mg/dl

read -r -a RESULTARRAY <<< "$(curl --silent $URL/api/v1/entries/current)"

TIMESTAMP=${RESULTARRAY[0]}
TIMESTAMP=${TIMESTAMP//\.[0-9][0-9][0-9]/} 
EPOCH=$(date +%s -d "$TIMESTAMP") # Convert timestamp to epoch time
EPOCHNOW=$(date +%s) # Convert current time to epoch time
TIMEDIFF=$(((EPOCHNOW - EPOCH)/60)) #calculate the difference

BG=${RESULTARRAY[2]}
if $USEMMOL ; then
  BG=$(echo "scale=1; $BG / 18" | bc)
fi

case ${RESULTARRAY[3]} in
  FortyFiveUp)
    TREND='↗'
    ;;
  FortyFiveDown)
    TREND='↘'
    ;;
  SingleUp)
    TREND='↑'
    ;;
  SingleDown)
    TREND='↓'
    ;;
  Flat)
    TREND='→'
    ;;
  DoubleUp)
    TREND='⇈'
    ;;
  DoubleDown)
    TREND='⇊'
    ;;
  *)
    TREND=${RESULTARRAY[3]}
    ;;
esac

echo " $BG $TREND (${TIMEDIFF}m ago)"
