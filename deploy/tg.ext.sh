#! /usr/bin/env bash

R=$RANDOM"0000"; RANDOM_PORT=33${R:0:3}
PORT=${1:-$RANDOM_PORT}
RAND_ID=$(openssl rand -hex 16)
echo $RAND_ID

NAME="MPROTO-$PORT"
docker run -d --name $NAME --restart=always -p$PORT:443 -e SECRET=${RAND_ID} telegrammessenger/proxy:latest

SERVER="${3:-$(curl http://ipecho.net/plain)}"
URL="tg://proxy?server=$SERVER&port=$PORT&secret=$RAND_ID"
echo $URL

#DAYS="${2:-365d}"

MSG="mproto://$SERVER:$PORT Expired @ "$(date +"%Y-%m-%d")

curl -i -X POST -H "Content-Type: application/json" -d "{ \"chat_id\": -1001336023411, \"text\": \"[$MSG]($URL)\", \"parse_mode\": \"Markdown\" }" "https://api.telegram.org/bot767586102:AAEadFW8WMPSwcRoqcSUWLQC0aQ4PUd9ppI/sendMessage"

nohup echo $(sleep 2d; docker rm -f $NAME) &
