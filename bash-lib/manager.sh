#! /usr/bin/env bash

CUR_DIR=$HOME/.lteam18.auto.bash-lib

man.install(){
    curl "$PREFIX/$i" > $CUR_DIR/$i
}

man.install.all(){
    for i in $@; do
        install $i
    done
}

man.install.default(){
    install_all index.sh lxlib.sh chalk.sh color.sh
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
    if [ "Darwin" == $(uname) ]; then
        exist_or_append "$HOME/.bashrc" "source $CUR_DIR/index.sh"
        echo "You are using mac. If you need build profile, please involke 'build_profile'"
    else
        exist_or_append "$HOME/.bashrc" "source $CUR_DIR/index.sh"
    fi
}
