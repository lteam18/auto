#! /usr/bin/env bash

LT_AUTO_REPO="https://lteam18.github.io/auto/bash-lib"
CUR_DIR=$HOME/.lteam18.auto.bash-lib

man.install(){
    curl "$LT_AUTO_REPO/$i" > $CUR_DIR/$i
}

man.install.all(){
    for i in $@; do
        man.install $i
    done
}

man.source.url(){
    local RF=/tmp/$RANDOM
    curl "$1" > $RF
    source $RF
    rm $RF
}

man.source.auto(){
    man.source.url "$LT_AUTO_REPO/$1"
}

man.install.default(){
    man.install.all index.sh lib.sh lxlib.sh chalk.sh color.sh
}

exist_or_append(){
  local filename="$1"
  local string_to_append="$2"
  grep -F --quiet "$string_to_append" "$filename" || echo "$string_to_append" >> "$filename"
  echo "$filename"
}

man.build.profile(){
    exist_or_append "$HOME/.bash_profile" "[ -f ~/.bashrc ] && source ~/.bashrc"
}

man.build.bashrc(){
    exist_or_append "$HOME/.bashrc" "source $CUR_DIR/index.sh"
    if [ "Darwin" == $(uname) ]; then
        echo "You are using mac. If you need build profile, please involke 'man.build.profile'"
    fi
}
