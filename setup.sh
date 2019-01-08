#!/bin/bash

function removeUnwantedImages() {
    DOCKER_IMAGE_IDS=$(docker images | grep upsource | awk '{print $3}')
    if [ -z "$DOCKER_IMAGE_IDS" -o "$DOCKER_IMAGE_IDS" = " " ]; then
        echo "---- No images available for deletion ----"
    else
        docker rmi -f $DOCKER_IMAGE_IDS
    fi
}

function networkUp () {    
    docker-compose -f upsource.yaml up -d 2>&1
    if [ $? -ne 0 ]; then
	    echo "ERROR !!!! Unable to start the server "
	    exit 1
    fi
}

function networkDown () {
    docker-compose -f upsource.yaml down
    #Cleanup images
    # removeUnwantedImages
}

printHelp() {
  echo "Usage: setup.sh [-c -r -u -d]"
  echo
  echo "-u - start server"
  echo "-d - stop server"
  echo
  echo "e.g. setup.sh -u"
  echo 
}

#Create the network using docker compose
while getopts h?n:crud opt; do
  case "$opt" in
    h|\?)
        printHelp
        exit 0
    ;;
    u)  networkUp
    ;;
    d)  networkDown
    ;;
  esac
done

