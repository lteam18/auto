#! /usr/bin/env bash

if [ -n "$ALL" ]; then
  KOA=true
  TS=true
  WS_CLIENT=true
fi

for i in $T; do eval "$i=true"; done
for i in $F; do eval "$i=false"; done

function prompt(){
  while true
  do
    read -p "${1:?Provide Question}" answer

    # (2) handle the input we were given
    case $answer in
    [yY]* ) echo true; return 0;;
    [nN]* ) echo false; return 1;;
    * )  echo "Please enter Y or N. ";;
    esac
  done
}

KOA=${KOA:-$(prompt "INSTALL Koa?: ")}
TS=${TS:-$(prompt "INSTALL Typescript?: ")}
WS_CLIENT=${WS_CLIENT:-$(prompt "INSTALL webservice client, axios?: ")}

echo "Now we start"
echo -e "=====================\n"

source /dev/stdin <<< "$(curl --insecure https://edwinjhlee.github.io/lib/chalk.sh)";

init_package_json(){
  echo "init package json"
  sed -e "5d" \
  -e '4a\
  \ \ "main": "dist/index.js",'\
  -e '4a\
  \ \ "typings": "src/index.ts",' package.json 1>package.json.bak
  mv package.json.bak package.json
}

# init
RUN_CMD_WITH_STEP 1 "NPM Init"\
  npm init -y >/dev/null &&\
  init_package_json

# Lib
RUN_CMD_WITH_STEP 2 "Install Production Dependent Packages"\
  npm install lodash axios --save

# Dev
$KOA &&\
  RUN_CMD_WITH_STEP 3a "Install Koa Dependent Packages"\
  npm install koa @types/koa koa-router @types/koa-router koa-body --save

# add typescript
$TS &&\
RUN_CMD_WITH_STEP 3b "Install typescript packages and init tsconfig"\
  npm install @types/node typescript ts-node ts-lint typescript-formatter --save-dev &&\
  node_modules/.bin/tsc --init -t es6

$WS_CLIENT &&\
RUN_CMD_WITH_STEP 3c "Init typescript project"\
  npm install axios

# Add ignore

f(){
  cat > .gitignore <<ENDEND
node_modules
build
dist
npm-debug.log
ENDEND
}

RUN_CMD_WITH_STEP 5 "Building .gitignore" f

# add package

# npm run setenv

# setup PATH
# test/commit/release
