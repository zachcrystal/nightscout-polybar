#!/bin/bash

URL=https://zccgm.herokuapp.com # Add your Nightscout URL here
USEMMOL=true # true if you use mmol/l units. false if you use mg/dl

# read -r -a RESULTARRAY <<< "$(curl --silent $URL/api/v1/entries/current)"
read -r -a BG1 <<< $(curl --silent $URL/api/v1/entries/ | head -n 1)
read -r -a BG2 <<< $(curl --silent $URL/api/v1/entries/ | head -n 2 | tail -n 1)

# TIMESTAMP=${RESULTARRAY[0]}
TIMESTAMP=${BG1[0]//\"} 
TIMESTAMP=${TIMESTAMP//\.[0-9][0-9][0-9]/} 
EPOCH=$(date -d "${TIMESTAMP}" +%s) # Convert timestamp to epoch time
EPOCHNOW=$(date +%s) # Convert current time to epoch time
TIMEDIFF=$(((EPOCHNOW - EPOCH)/60)) #calculate the difference


BG=${BG1[2]}
BGFORDELTA=${BG2[2]}
if $USEMMOL ; then
  BG=$(echo "scale=1; $BG / 18" | bc)
  BGFORDELTA=$(echo "scale=1; $BGFORDELTA / 18" | bc)
fi

case ${BG1[3]//\"} in
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

DELTA=$(echo "scale=1; $BG - $BGFORDELTA" | bc | sed -e 's/^-\./-0./' -e 's/^\./0./')

echo " $BG ($DELTA) $TREND (${TIMEDIFF}m)"
