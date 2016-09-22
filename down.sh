#!/bin/bash

docker rm -f jenkins

docker rmi -f jenkins-ci

rm -rf /home/$(whoami)/jenkins_home
rm -rf /home/$(whoami)/ansible
