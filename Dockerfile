FROM jenkins:2.7.4

COPY config/*.xml $JENKINS_HOME/
COPY config/executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

RUN /usr/local/bin/install-plugins.sh ant gradle xunit workflow-aggregator docker-workflow build-timeout credentials-binding ssh-agent ssh-slaves timestamper ws-cleanup email-ext github-organization-folder purge-job-history

USER root
RUN apt-get update -qq
RUN apt-get install -qqy apt-transport-https ca-certificates
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo deb https://apt.dockerproject.org/repo debian-jessie main > /etc/apt/sources.list.d/docker.list
RUN apt-get update -qq
RUN apt-get install -qqy docker-engine
RUN usermod -aG docker jenkins
RUN chown -R jenkins:jenkins $JENKINS_HOME/

USER jenkins
