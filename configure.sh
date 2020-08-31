#!/bin/bash
MODULE_NAME=elasticsearch
RF=$BUILDDIR/${MODULE_NAME}

mkdir -p $RF

DOCKER_HOST=$DOCKERARGS
DOCKER_COMPOSE_FILE=$RF/docker-compose.yml

ES_LOG=$LOG_DIR/${MODULE_NAME}
ES_DATA=$DATA_DIR/${MODULE_NAME}
ES_CONF=$CONF_DIR/${MODULE_NAMEi}

case $VERB in
  "build")
    echo "1. Configuring ${PREFIX}-${MODULE_NAME}..."


    mkdir -p $ES_LOG $ES_CONF $ES_DATA
    docker $DOCKERARGS volume create -o type=none -o device=$ES_LOG -o o=bind ${PREFIX}-${MODULE_NAME}-log
    docker $DOCKERARGS volume create -o type=none -o device=$ES_DATA -o o=bind ${PREFIX}-${MODULE_NAME}-data
    docker $DOCKERARGS volume create -o type=none -o device=$ES_CONF -o o=bind ${PREFIX}-${MODULE_NAME}-conf


    sed -e "s/##PREFIX##/$PREFIX/" \
        -e "s/##OUTERHOST##/$OUTERHOST/" \
        -e "s/##MODULE_NAME##/${MODULE_NAME}/" docker-compose.yml-template > $DOCKER_COMPOSE_FILE

   echo "2. Building ${PREFIX}-${MODULE_NAME}..."
   docker-compose $DOCKER_HOST -f $DOCKER_COMPOSE_FILE build
 ;;

  "install-hydra")
#    register_hydra $MODULE_NAME
  ;;
  "uninstall-hydra")
#    unregister_hydra $MODULE_NAME
  ;;
  "install-nginx")
    register_nginx $MODULE_NAME
  ;;
  "uninstall-nginx")
    unregister_nginx $MODULE_NAME
  ;;

  "start")
    echo "Starting container ${PREFIX}-${MODULE_NAME}"
    docker-compose $DOCKERARGS -f $DOCKER_COMPOSE_FILE up -d
  ;;

  "init")
  ;;

  "stop")
      echo "Stopping container ${PREFIX}-${MODULE_NAME}"
      docker-compose $DOCKERARGS -f $DOCKER_COMPOSE_FILE down
  ;;
  "remove")
      echo "Removing $DOCKER_COMPOSE_FILE"
      docker-compose $DOCKERARGS -f $DOCKER_COMPOSE_FILE kill
      docker-compose $DOCKERARGS -f $DOCKER_COMPOSE_FILE rm

  ;;
  "purge")
  ;;

  "cleandata")
    echo "Cleaning data ${PREFIX}-${MODULE_NAME}"
  ;;

  "purge")
###    echo "Removing $RF" 
###    rm -R -f $RF
###    docker $DOCKERARGS volume rm ${PREFIX}-${MODULE_NAME}-data
  ;;

esac

