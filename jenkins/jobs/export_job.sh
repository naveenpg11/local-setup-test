#!/bin/bash -e

echo "\033[0;33m exporting Job: sample-app-build-and-deploy to ${PWD}/exported_config.xml \033[0m"

container_id=$(docker ps | grep "sa-jenkins" | awk '{print $1}')

docker cp ${container_id}:var/jenkins_home/jobs/sample-app-build-and-deploy/config.xml ${PWD}/exported_config.xml
