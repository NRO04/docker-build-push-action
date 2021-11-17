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
    docker login -u USERNAME -p PASSWORD
# "--------------------------------"
echo " ++++++ Loggin in Docker ++++++"

# build image
# "--------------------------------"
    docker build -t TAG USERNAME/REPOSITORY .
# "--------------------------------"
echo " ++++++ Building image ++++++"


# push the image to dockerhub
# "--------------------------------"
    docker push USERNAME/REPOSITORY:TAG 
# "--------------------------------"