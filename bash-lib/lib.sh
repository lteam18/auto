#! /usr/bin/env bash

# Extract useful methods from "lxlib.sh", originated in el-logic

# Dependency: fswatch, rsync
watch_sync() {
	local dst=$1
	shift
	local last=0
	fswatch -0 $@ | while read -d "" event; do
		echo "$event $RANDOM\n"
		local current=$(date +%s)
		local diff=$(($current - $last))
		echo "$current $last $diff"
		if [ "$diff" -gt 3 ]; then
			echo "More than 3"
			echo "$@\n"
			echo "$dst\n"
			rsync -ahP --delete $@ $dst
			last=$current
		fi

	done
}

# From lxlib join
#RESULT=$(IFS=':'; echo "${M[*]}")
string.join() {
	local sep=$1
	shift
	local ANS=""
	#  for ((i=0;i<${#array[@]};i++)) do
	for ARG in "$@"; do
		ANS="$ANS$sep$ARG"
	done
	echo ${ANS:1}
}
