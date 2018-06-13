#! /bin/bash

source /dev/stdin <<< "$(curl --insecure https://edwinjhlee.github.io/lib/chalk.sh)";

# init
RUN_CMD_WITH_STEP 1 "npm install"\
  npm init -y

# Dev
RUN_CMD_WITH_STEP 2 "Install Dev Dependent Packages"\
  npm install @types/node typescript ts-node ts-lint typescript-formatter --save-dev

# Lib
RUN_CMD_WITH_STEP 3 "Install Production Dependent Packages"\
  npm install lodash --save

# build
RUN_CMD_WITH_STEP 4 "Init typescript project"\
  node_modules/.bin/tsc --init -t es6

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
