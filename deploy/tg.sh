#! /usr/bin/env bash

PORT=${1:?"Please provide port in first argument"}
GENERATE_ID=$(openssl rand -hex 16)
RAND_ID=${2:-$GENERATE_ID}

NAME="MPROTO-$PORT"
docker run -d --ulimit nofile=98304:98304 --name $NAME --restart=always -p$PORT:443 -e SECRET=${RAND_ID} telegrammessenger/proxy:latest

SERVER="${3:-$(curl http://ipecho.net/plain)}"
URL="tg://proxy?server=$SERVER&port=$PORT&secret=$RAND_ID"
echo $URL

MSG="Random: mproto://$SERVER:$PORT"

curl -i -X POST -H "Content-Type: application/json" -d "{ \"chat_id\": -1001336023411, \"text\": \"[$MSG]($URL)\", \"parse_mode\": \"Markdown\" }" "https://api.telegram.org/bot767586102:AAEadFW8WMPSwcRoqcSUWLQC0aQ4PUd9ppI/sendMessage"
