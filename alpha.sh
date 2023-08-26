#!/bin/bash

SERVICE="./build/bladebit"
PCA="xch1q898yrj02vh0n2gtf6wzf2ddgly9gdn9r6ngqf7lfvwnfp7yrmgqc5twpl"
FPK="a5ea9d6e960ad6724ba1eeca9abcbb17f587142169db6a380d57b09189d8c1aab5ca2f2acf1d2b5e4007c499cdc543c6"

while [ true ]
do
    $SERVICE -n 9999 -c $PCA -f $FPK ramplot /root/hall/plot
done
