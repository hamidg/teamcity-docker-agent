#!/bin/bash

set -e 

docker ps --format="{{.Names}}" | grep agent

for f in $(docker container ls --format="{{.Names}}" | grep agent)
do
   echo stopping container $f
   docker container stop $f

   echo Removing containerge $f
   docker container rm $f
done
