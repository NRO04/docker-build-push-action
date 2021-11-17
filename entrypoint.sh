#!/bin/sh


echo "REPOSITORY NAME -> $1"
echo "TAG -> $2" 
echo "USERNAME -> $4"


# Build the image
echo "preview:"
echo "<< docker build -t $2 $4/$1 >>"