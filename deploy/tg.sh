#! /usr/bin/env bash

PORT=${1:-443}
RAND_ID=$(openssl rand -hex 16)
echo $RAND_ID

NAME="MPROTO-$PORT"
docker run -d --name $NAME --restart=always -p$PORT:443 -e SECRET=${RAND_ID} telegrammessenger/proxy:latest


SERVER="${2:-$(curl http://ipecho.net/plain)}"
URL="tg://proxy?server=$SERVER&port=$PORT&secret=$RAND_ID"
echo $URL

MSG="$SERVER:$PORT Effect @ "$(date +"%Y-%m-%d")

curl -i -X POST -H "Content-Type: application/json" -d "{ \"chat_id\": -1001336023411, \"text\": \"[$MSG]($URL)\", \"parse_mode\": \"Markdown\" }" "https://api.telegram.org/bot767586102:AAEadFW8WMPSwcRoqcSUWLQC0aQ4PUd9ppI/sendMessage"

nohup echo $(sleep 2d; docker rm -f $NAME) &
