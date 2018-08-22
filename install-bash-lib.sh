LIBS=(
    index.sh
    chalk.sh
    color.sh
    # lib.sh
    # alias.sh
)

PREFIX="https://lteam18.github.io/auto/bash-lib"

CUR_DIR=$HOME/.lteam18.auto.bash-lib

mkdir $CUR_DIR

for i in ${LIBS[@]}; do
    curl "$PREFIX/$i" > $CUR_DIR/$i
done

exist_or_append(){
  local filename="$1"
  local string_to_append="$2"
  grep -F --quiet "$string_to_append" "$filename" || echo "$string_to_append" >> "$filename"
  echo "$filename"
}

if [ "Darwin" == $(uname) ]; then
    exist_or_append "$HOME/.bashrc" "source $CUR_DIR/index.sh"
    echo "You are using mac. If you need build profile, please involke 'build_profile'"
else
    echo hi
fi

build_profile(){
    exist_or_append "$HOME/.bash_profile" "[ -f ~/.bashrc ] && source ~/.basrc"
}

export -f build_profile
