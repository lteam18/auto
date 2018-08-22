CUR_DIR=$(dirname ${BASR_SOURCE[0]})

INCLUDE=(
    chalk.sh
    color.sh
    lxlib.sh
)

for i in ${INCLUDE[@]}; do
    source $CUR_DIR/$i
done

for i in $(cat $CUR_DIR/user.list); do
    echo $i
done
