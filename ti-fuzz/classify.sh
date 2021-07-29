#!/bin/bash

set -ex

CRASHERS=$(pwd)/crashers

RES=$(pwd)/classified

mkdir -p $RES

BOTH_ERR=$RES/both-err
ONE_SIDE_ERR=$RES/one-side-err
META_DIFF_1=$RES/metainfo-diff-col-type
META_DIFF_2=$RES/metainfo-diff-col-name
META_DIFF_3=$RES/metainfo-diff-row-num
META_DIFF_4=$RES/metainfo-diff-col-num
DATA_DIFF=$RES/data-diff

mkdir -p $BOTH_ERR $ONE_SIDE_ERR $META_DIFF_1 $META_DIFF_2 $META_DIFF_3 $META_DIFF_4 $DATA_DIFF

copyCrasher() {
    basename=$(basename $1)
    hash=${basename%.*}

    cp $1 $2/$basename
    cp ${1%.*} $2/$hash
    cp ${1%.*}.quoted $2/$hash.quoted
}

for i in $CRASHERS/*.output
do
    if grep -q "\[both err\]" $i
    then
        copyCrasher $i $BOTH_ERR
    elif grep -q "\[one side err\]" $i
    then
        copyCrasher $i $ONE_SIDE_ERR
    elif grep -q "\[metainfo diff (1)]" $i
    then
        copyCrasher $i $META_DIFF_1
    elif grep -q "\[metainfo diff (2)]" $i
    then
        copyCrasher $i $META_DIFF_2
    elif grep -q "\[metainfo diff (3)]" $i
    then
        copyCrasher $i $META_DIFF_3
    elif grep -q "\[metainfo diff (4)]" $i
    then
        copyCrasher $i $META_DIFF_4
    elif grep -q "\[data diff\]" $i
    then
        copyCrasher $i $DATA_DIFF
    fi
done
