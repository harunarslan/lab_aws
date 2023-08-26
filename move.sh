#!/bin/bash

mkdir -p /root/hall/plot
mkdir -p /root/hall/up1
mkdir -p /root/hall/up2
mkdir -p /root/hall/up3

counter=1

while [ true ]
do
    mv /root/hall/plot/*.plot /root/hall/up$counter
    ((counter++))
    if [ $counter -gt 3 ]; then
        counter=1
    fi
    sleep 30
done
