#!/bin/bash

if [ -d "./docker-stuff-ipv6-ad" ]
then
    cd ./caronte
    sudo docker-compose up -d
else
    echo "Error: Directory ./docker-stuff-ipv6-ad does not exists."
fi