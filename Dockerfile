FROM jenkins:2.7.4

COPY config/*.xml $JENKINS_HOME/
COPY config/executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

#COPY config/plugins.txt /usr/share/jenkins/ref/
#RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

RUN /usr/local/bin/install-plugins.sh ant:1.4 gradle:1.25 xunit:1.102 workflow-aggregator:2.3 docker-workflow:1.8 build-timeout:1.17.1 credentials-binding:1.9 ssh-agent:1.13 ssh-slaves:1.11 timestamper:1.8.5 ws-cleanup:0.30 email-ext:2.47 github-organization-folder:1.5 purge-job-history:1.1

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
