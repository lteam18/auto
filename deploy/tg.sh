#! /usr/bin/env bash

PORT=${1:-443}
RAND_ID=$(openssl rand -hex 16)
echo $RAND_ID
docker run -d --name "telegram-proxy-$PORT" --restart=always -p$PORT:443 -e SECRET=${RAND_ID} telegrammessenger/proxy:latest


SERVER="${2:-$(curl http://ipecho.net/plain)}"
echo "tg://proxy?server=$SERVER&port=$PORT&secret=$RAND_ID"
