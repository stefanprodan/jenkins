#!/bin/bash

JENKINS_HOME=/home/$(whoami)/jenkins_home
mkdir $JENKINS_HOME
chown -R 1000 $JENKINS_HOME

ANSIBLE_INVENTORY=/home/$(whoami)/ansible
mkdir $ANSIBLE_INVENTORY
chown -R 1000 $ANSIBLE_INVENTORY

docker build -t jenkins-ci .

docker run -d --name jenkins \
    -p 8080:8080 -p 50000:50000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /home/$(whoami)/jenkins_home:/var/jenkins_home \
    -v /home/$(whoami)/ansible:/etc/ansible \
    --restart unless-stopped \
    jenkins-ci
