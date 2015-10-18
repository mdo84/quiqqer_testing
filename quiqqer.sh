#!/bin/bash
# using docker to test quiqqer
#
# Usage:
#  start               - start and build the containers mysql & apache2 with quiqqer installed"
#  build               - only build the containers"
#  stop_all_containers - stopping and deleting ALL containers on the host"
#
#
# check if docker is installed
if [[ ! -e /bin/docker ]]
then
  echo "Docker is not installed"
  exit 1
fi

OPTION=${1}
ENVGIT=${2}
DOCKERFILEPATH=Dockerfiles/
CONTAINER=apache2

function build {
  echo "Using ${ENVGIT}"
  sed "s#ENVGIT#${ENVGIT}#g" ${DOCKERFILEPATH}${CONTAINER}/Dockerfile.template > ${DOCKERFILEPATH}${CONTAINER}/Dockerfile
  echo "Using the following Dockerfile"
  cat ${DOCKERFILEPATH}${CONTAINER}/Dockerfile
  docker build -t quiqqer/apache2 ${DOCKERFILEPATH}${CONTAINER}
  echo "Cleanup Dockerfile..."
  rm -f Dockerfiles/apache2/Dockerfile
}

function start {

  # downloading mysqldb from dockerhub
  docker run --name mysqldb -e MYSQL_ROOT_PASSWORD=quiqqer -e MYSQL_DATABASE=quiqqer -d mysql

  # use the built image
  docker run --name apache2 --link mysqldb:mysql -p 80:80 -d quiqqer/apache2 /usr/sbin/apache2ctl -D FOREGROUND

}

function stop_all_containers {

  echo "Stopping all Containers...."
  # stopping all docker container
  docker stop $(docker ps -a -q)

  echo "Removing all Containers..."
  # remove als docker container
  docker rm --volumes=true  $(docker ps -a -q)

}

function repo_check {
  # check if EVNGIT is set
  if [[ -z ${ENVGIT} ]]; then
    echo "GITREPO is missing..."
    usage
    exit 1
  fi

}

function usage {

  echo Usage:
  echo " start <GITREPO>     - start and build the containers mysql & apache2 with quiqqer installed"
  echo " build <GITREPO>     - only build the containers"
  echo " stop_all_containers - stopping and deleting ALL containers on the host"

}

case ${OPTION} in
start)
  repo_check
  build
  start
  ;;
stop_all_containers)
  stop_all_containers
  ;;
build)
  repo_check
  build
  ;;
*)
  usage
  ;;
esac

