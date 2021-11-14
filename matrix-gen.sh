#!/bin/bash

base_dir=dockerfiles/$1

subdirs=($(ls -d $base_dir/*))

for (( i=0; i<${#subdirs[@]}; i++ ));
do

    if [ ! $i = $((${#subdirs[@]} - 1)) ]
    then
        echo "{\"path\":\"${subdirs[$i]}/Dockerfile\"},"
    else
        echo "{\"path\":\"${subdirs[$i]}/Dockerfile\"}"
    fi
done
