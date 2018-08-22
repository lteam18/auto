#!/bin/bash

# enable lx-doc-test

LX_LIB_PATH=`dirname ${BASH_SOURCE[0]}`

#Configure Path

################
### exist_or
################

exist_or(){  [ -e "$1" ] || eval "$2 $1"; }
exist_or_append(){
  local filename="$1"
  local string_to_append="$2"
  grep -F --quiet "$string_to_append" "$filename" || echo "$string_to_append" >> "$filename"
  echo "$filename"
}

exist_or_mkdir(){  [ -e "$1" ] || mkdir "$1"; }
exist_or_mkdirp(){  [ -e "$1" ] || mkdir -p "$1"; }
exist_or_gitclone(){  [ -e "$1" ] || git clone "$2" "$1"; }

################
### apt-get quick
################

#alias sapt_ud="sudo apt-get update"
sapt_ud(){ sudo apt-get install update; }

#alias sapt_ins="sudo apt-get install"
sapt_ins(){ sudo apt-get install "$@"; }

#alias sapt_ins_y="sudo apt-get install -y"
sapt_ins_y(){ sudo apt-get install -y "$@"; }

sapt_ins_y_onebyone(){
  for i in "$@"; do
    sapt_ins_y "$i"
  done
}

################
### directory quick
################

dir_recovery(){
  pushd .
  eval "$*"
  pod .
}

with_dir(){
  pushd .
  cd "$1"
  shift
  eval "$*"
  popd
}


# In mysgit, it fails [[ $i =~ [0-9] ]]
match()
{
  local ans=$(echo $1 | grep -E "$2" | wc -l)
  if [ $ans == 0 ]; then
    return 1
  else
    return 0
  fi
  [ $ans == 0 ] && return 0 || return 1
}

_success_or_retry()
{
  while true;
  do
    eval $1
    if (( $? == 0 )); then
      return
    fi
    wait `sleep ${2:-1}`
  done
}


# usage 1: success_or_retry - 1 <<< "echo hi"
# suage 2: success_or_retry - 1 <<A
# echo hi
# A
success_or_retry() {
  local code=$(cat $1)
  _success_or_retry "$code" $2
}


get_pid() {
  if [ $# -lt 1 ] ; then
      return 1
  fi
  PSOPTS="-ef"
  /bin/ps $PSOPTS | grep "$1" | grep -v grep | awk '{ print $2; }'
}

run_after_pid() {
  while true;
  do
    lines=`ps -p $1 | wc -l`
    if (( $lines == 1 )); then
      eval $2
      return
    fi
    wait `sleep ${3:-1}`
  done
}

agrep(){
  awk "/$1/{printf \"[match] \"} {print \$0}"
}

#mcd(){ mkdir $1 && cd $_; }

alias mcd=mkdir_cd

mkdir_cd(){
  mkdir $1
  cd $1
}

###

exit_if_fail(){
  if [ $1 -ne 0 ] ; then
      echo "Not successful. Existing."; exit 1;
  fi
}

# TODO: Return 0 for true, 1 for false
yes_or_no(){
  echo "$1 (y/n)? \c"
  read RESPONSE
  case $RESPONSE in
      [yY]|[yY][eE][sS]) RESPONSE=y ;;
      [nN]|[nN][oO]) RESPONSE=n ;;
      *) yes_or_no $1 ;;
  esac
}

#> abc(){ _o1=$1/$1//$1; }
#> _1=(1 2 3)
#> map abc
#> echo ${_o1[*]}
#= 1/1//1 2/2//2 3/3//3
map(){
  declare -a ret
  for idx in ${!_1[@]};
  do
    # echo ${_1[$idx]}
    $1 ${_1[$idx]}
    # echo $map_fout
    ret[$idx]=$_o1;
  done
  _o1=${ret[@]}
}

# map_fin
# map_fout
# map(){
#   idx=0
#   for i in ${map_in[@]};
#   do
#     echo $idx
#     echo ${map_in[$idx]}
#     $1
#     map_out[$idx]=$map_fout
#     let idx++
#   done
# }

print_arr(){
  for e in ${_1[@]};
  do
    echo $e
  done
}

#declare -a TEMP_FILES
clean_up_temp_file(){
  for temp in ${TEMP_FILES[@]}; do
    rm $temp 2> /dev/null
    echo "Cleaned up "$temp;
  done
  TEMP_FILES=()
}

get_name(){
  len=${#0}
  let len=len-2
  _o1=${0:1:$len}
}

gen_random_temp(){
  get_name
  _o1=$_o1.$$.$RANDOM
  TEMP_FILES=(${TEMP_FILES[@]} $_o1)
}

# Storage file for displaying cal and date command output
gen_random_temp
TEMP_FILE=$_o1

trap "clean_up_temp_file" SIGHUP SIGINT SIGTERM SIGCHLD


#RESULT=$(IFS=':'; echo "${M[*]}")
join(){
  local ANS=""
#  for ((i=0;i<${#array[@]};i++)) do
  for ARG in "$@"
  do
    ANS=$ANS:$ARG
  done
  echo ${ANS:1}
}

#penv(){
#  old=$IFS
#  IFS=:
#  printf "%s\n" $1
#  IFS=$old
#}

penv()
{
  local IFS=:
  #eval printf "%s\\\n" \$${1:-PATH}
  printf "%s\n" ${1:-$PATH}
}

path(){
  env $PATH
}


### This function is ugly.
### Python version will be much pretty
### I think Python(much prefered) or Perl should be the glue language
### shell is not suitable for this. Bug is hidden
doctest(){
  all=`cat $1 | grep "^#[=>] "`;
  (
    source $1
    IFS=$'\n'
    let idx=0;
    all_lines=(${all})

    # for line_id in ${!all_lines[@]};
    line_id=0
    line_num=${#all_lines[@]}
    while [ $line_id -lt $line_num ]
    do
      line=${all_lines[$line_id]}
      echo $line

      if [[ $line == \#\>* ]]; then
        eval "${line:3}" | cat > result.txt
      fi

      expected_result=""

      while true
      do
        let line_id++
        [ $line_id -lt $line_num ] || break;
        line=${all_lines[$line_id]}
        [[ $line == \#\=* ]] || break;

        if [[ $expected_result == "" ]]; then
          expected_result=${line:3}
        else
          expected_result=$expected_result$'\n'${line:3}
        fi
      done

      run_result=`cat result.txt`

      if [[ "$run_result" == "$expected_result" ]]; then
        echo "Match"
      else
        echo "Not Match"
        echo "EXPECTED: "
        echo $expected_result
        echo "INSTEAD:"
        echo $run_result
      fi
    done

  )

}

get_start_script_path() {

#    __name__=${BASH_SOURCE[@]}
   __name__=${BASH_SOURCE[0]}
    if [ -z __name__ ]; then
        echo "Should not happend!!!"
        exit 1
    fi

}

alias ps?="ps -ef | grep"
alias ?ps="ps -ef | grep "
#alias file?="find . -name "
# file?  is wrong
function ?file(){
  find ${2:-.} -name "$1"
}

#?(){ echo "scale=${2:-0};$1" | bc; }
?bc(){ echo "$*" | bc -l; }

backup(){ cp $1{,.bak}; }

#until !!; do :; done
keep_retry() { until !!; do sleep ${1:-0}; done; }

_col(){
    local str=""
    for i in "$*"; do
        str="\$$i,"$str
    done
    str="{print ${str:0:${#str}-1}}"
    #str=\'$str\'
    #echo "here "$str
    #awk $(echo -e $str)
    awk $'$str'
}

_col1(){
    local str=""
    for i in "$@"; do
        str=$str"\$$i,"
    done
    str=${str:0:${#str}-1}
    echo $str
    awk -v q="$str" '{print q}'
}

# ll | awk '{print $1 $3 $8}'
# ll | cols 1 3 8
cols(){
    local str=""
    for i in "$@"; do
        #if [[ $i =~ [0-9]+-[0-9]+  ]];
        if match $i "[0-9]+-[0-9]+";
        then
            sep="-"
            A=${i/$sep*}
            B=${i/*$sep}
            for j in `seq $A $B`; do
                str=$str"\$$j,"
            done
            continue
        fi
        if [ $i -lt 0 ];then
            str=$str"\$(NF$i),"
        else
            str=$str"\$$i,"
        fi
    done
    str=${str:0:${#str}-1}
    awk "{print $str }"
}

# ll | awk 'NR==3 {print $0}'
# ll | rows 3
rows(){
    local str=""
    for i in "$@"; do
        #if [[ $i =~ [0-9]+-[0-9]+  ]];
        if match $i "[0-9]+-[0-9]+" ;
        then
            sep="-"
            A=${i/$sep*}
            B=${i/*$sep}
            str=$str" NR>=$A && NR<=$B ||"
        else
            str=$str" NR==$i ||"
        fi
    done

    str=${str:0:${#str}-2}
    awk "$str {print \$0}"
}

cd_file(){
    [ -f $1 ] && echo -e "It is a file:\n$1\nEnter basedir instead:\n$(dirname $1)"  && cd $(dirname $1) && return
    [ -d $1 ] && cd $1 && return
}

ifint(){
    local number=$1
# lesson: regex need no ""
    [[ "$number" =~ ^[0-9]+$ ]] && return 0 || return 1
}

read_num(){
    local content=""
    while [ 1 ];
    do
        read -p "input a num: " content
        if ifint $content;
        then
            echo $content
            return
        fi
    done
}

lsdup(){
  md5sum "${1:-.}"/* | sort | awk '{ if (prev==$1){ print $2 }; prev=$1 }'
}

cpall(){
  for i in **/*; do
    [ ! -f "$i" ] &&\
      cp "$i" "${1:?"Please provide destination folder path."}/${i//\//-}"; 
  done
}

bcdi(){
    local curdir=$(pwd)
    echo $curdir
    local arr=($(IFS='/'; echo ${curdir[*]}))

    local result=$(IFS=$'\n'; echo "${arr[*]}")
    # TIP: the quote of result make a difference
    cat -n <<< "$result"

    local index=$(read_num)
    if [ -n "$index" ];
    then
        cd "/$(IFS=$'/'; echo "${arr[*]:0:$index}")"
    else
        echo "Impossible."
    fi;
}

# change swap line using dos2unix or unix2dos

# We don't know: awk '{$1=$1}1' 1.txt

x(){
    local a=""
    for i in `seq $1`; do
        a="$a$2" #meet problem when we deal with space
    done
    echo $a
}

redirect_to_same_file(){
  local tmp=mktemp
  $1 $2 > $tmp
  local d=$(diff $2 $tmp | wc -l)
  if [ $d != 0 ]; then
    cat $tmp > $2
  fi
  rm $tmp
}

lsfiles(){
  ls -al | grep -E "^-" | awk '{ print $9 }'
}

#source `dirname ${BASH_SOURCE[0]}`/lxgit.sh

value(){
  local str=$(cat "$1" | grep -e "^$2=" | head -n 1)
  echo ${str:${#2}+1}
}

kv(){
  echo "$2=$3" >> "$1"
}

rm_key(){
  cat "$1" | grep -v "^$2=" > "$1"
}

get_abs_path(){
    local a=$(pwd)
    local base=$(basename "$1")
    local dir=$(dirname "$1")
    cd "$dir"
    echo "$(pwd)/$base"
    cd "$a"
}

get_invoke_script_path(){
    local path=${BASH_SOURCE[${#BASH_SOURCE[*]}-1]}
    #echo "$(get_abs_path "$path")"
    get_abs_path "$path"
}

EDWIN_LEE_CURRENT_SHELL_SCRIPT=$(get_invoke_script_path)
refresh_me(){
    local A=$EDWIN_LEE_CURRENT_SHELL_SCRIPT
    source "$EDWIN_LEE_CURRENT_SHELL_SCRIPT"
    EDWIN_LEE_CURRENT_SHELL_SCRIPT=$A
}

complete_fun_generate(){
  local a=$(cat <<E_COMPLETE
$1(){
    local cmd="\${1##*/}";

    local word=\${COMP_WORDS[COMP_CWORD]};
    if [[ \$word == "" ]]; then
        COMPREPLY=(\$(IFS=$'\n'; __CMD));
    else
        COMPREPLY=(\$(IFS=$'\n'; __CMD | grep \$word));
    fi
}
E_COMPLETE
)
#   eval $a;
    eval ${a//__CMD/$2}
}

# originally, we want to invent join in shell
# It turns out to be select. We use code generation technique
# Notice, only version 4 support regex like a{3} for aaa matching
slct(){
    key=$1
    shift
    local local_awk=""
    for i in $*; do
        #local_awk="$local_awk \$$key==\"$i\"{print \$0}"
        local_awk="$local_awk \$$key~/$i/{print \$0}"
    done
#    echo $local_awk
    awk "$local_awk"
}

out(){
    for i in $*; do
        echo $i
    done
}

el_enc(){    echo "$1" | base64 | rev | base64 | base64 ; }

el_dec(){    echo "$1" | base64 -d | base64 -d | rev | base64 -d; }

is_ip(){
   [[ "$1" =~ [0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}+.[0-9]{1,3} ]]
}

ls_all_files(){
   find . $1 | awk '{ print substr($0, 3) }'
}

# Log Faility, from learn_typescript/init_project.sh

COLP(){
  tput setaf "$1"
  shift
  echo -ne "$@"
  tput sgr0
}

COLBP(){
  tput setaf "$1"
  tput bold
  shift
  echo -ne "$@"
  tput sgr0
}

ERROR(){ COLBP 1 "$@"; }
WARN() { COLBP 3 "$@"; }
INFO() { COLBP 2 "$@"; }
FINE() { COLBP 4 "$@"; }

RUN_CMD_WITH_INFO(){
  if [ $# -ne 1 ]; then
    local INFO=$1
    shift 1
  else
    local INFO="Executing Command: $1"
  fi
  INFO "======================\n"
  INFO "$INFO\n"
  INFO "======================\n"
  eval "$@"
}


interval(){
  INTERVAL=${2:-"1"}  # update interval in seconds

  local sw=true
  trap 'sw=false;' INT

  if [ -z "$1" ]; then
    echo
    echo "usage: $0 [cmd] [interval=1]"
    echo
    echo "e.g. $0 \"ls\" 2"
    echo
    exit
  fi

  while $sw
  do
      echo "-----------------------"
      tput setaf "2"
      tput setab "1"
      tput bold
      echo "COMMAND: " $1
      tput sgr0
      echo "-----------------------"
      eval "$1"
      echo "-----------------------"
      sleep $INTERVAL 1>/dev/null 2>&1 &
      wait $!
  done
}

lsync(){
  INTERVAL=${1:-"2"}  # update interval in seconds
  shift
  local sw=true
  trap 'sw=false;' INT

  while $sw
  do
      rsync -ahP $@ --delete
      sleep $INTERVAL 1>/dev/null 2>&1 &
      wait $!
  done
}

watch_sync(){
  local dst=$1
  shift
  local last=0
  fswatch -0 $@ | while read -d "" event; do \
    echo "$event $RANDOM\n"
    local current=$(date +%s)
    local diff=$(($current-$last))
    echo "$current $last $diff"
    if [ "$diff" -gt 3 ];
    then
      echo "More than 3"
      echo "$@\n"
      echo "$dst\n"
      rsync -ahP --delete $@ $dst
      last=$current
    fi
    
  done
}

