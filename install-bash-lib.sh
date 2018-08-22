#! /usr/env/bin bash

PREFIX="https://lteam18.github.io/auto/bash-lib"

CUR_DIR=$HOME/.lteam18.auto.bash-lib
curl "$PREFIX/manager.sh" > $CUR_DIR/manager.sh

source $CUR_DIR/manager.sh

install_default

build_bashrc
