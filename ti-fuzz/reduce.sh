#!/bin/bash

set -ex

echo "WARNING: classify.sh should be run first before reducing"
echo "WARNING: '-squirrel' should be provided to the reducer, and arguments provided to the shell will be forwarded to the reducer"
echo "WARNING: classified/*-err can only be reduced manually because you should provide '-mysql-err' and '-tidb-err' to the reducer"

RES=$(pwd)/classified

META_DIFF_1=$RES/metainfo-diff-col-type
META_DIFF_2=$RES/metainfo-diff-col-name
META_DIFF_3=$RES/metainfo-diff-row-num
META_DIFF_4=$RES/metainfo-diff-col-num
DATA_DIFF=$RES/data-diff

DIR_LIST=($META_DIFF_1 $META_DIFF_2 $META_DIFF_3 $META_DIFF_4 $DATA_DIFF)

for i in $DIR_LIST
do
    mkdir -p ${i}-to-reduce
    
    for j in $i/*.output
    do
        cp ${j%.*} ${i}-to-reduce
    done

    for j in ${i}-to-reduce
    do
        go run github.com/pragmatwice/go-squirrel/reducer/main -input $j $@
    done
done
