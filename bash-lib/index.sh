CUR_DIR=$(dirname ${BASH_SOURCE[0]})

INCLUDE=(
    chalk.sh
    color.sh
    lxlib.sh
)

for i in ${INCLUDE[@]}; do
    source $CUR_DIR/$i
done

# load user self-defined library
# for i in $(cat $CUR_DIR/user.list 2>/dev/null); do
#     source $CUR_DIR/$i
# done

[ -f user.sh ] && source $CUR_DIR/user.sh
