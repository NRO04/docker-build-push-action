#!/bin/sh

# ----- PARAMS ----- 
# echo "REPOSITORY NAME -> $1"
# echo "TAG -> $2" 
# echo "USERNAME -> $3"
# echo "PASSWORD -> $4"


# ------ VAR ------

USERNAME=$3
PASSWORD=$4
TAG=$2
REPOSITORY=$1

# ------ END VAR ------


# Log in DockerHub
# "--------------------------------"
  echo $PASSWORD | docker login -u $USERNAME --password-stdin
# "--------------------------------"
echo " ++++++ Loggin in Docker ++++++"

# build image
# "--------------------------------"
    docker build -t $USERNAME/$REPOSITORY:$TAG .
# "--------------------------------"
echo " ++++++ Building image ++++++"


# push the image to dockerhub
# "--------------------------------"
    docker push $USERNAME/$REPOSITORY:$TAG
# "--------------------------------""