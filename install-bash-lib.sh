#! /usr/bin/env bash

LT_AUTO_REPO="https://lteam18.github.io/auto/bash-lib"

CUR_DIR=$HOME/.lteam18.auto.bash-lib
mkdir -p $CUR_DIR
curl "$LT_AUTO_REPO/manager.sh" > $CUR_DIR/manager.sh

source $CUR_DIR/manager.sh

man.install.default

man.build.bashrc
