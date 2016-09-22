# Jenkins CI 

[![layers](https://images.microbadger.com/badges/image/stefanprodan/jenkins.svg)](https://microbadger.com/images/stefanprodan/jenkins)

This is a Jenkins CI Server image suitable for running CD work-flows inside disposable containers using Jenkins Docker Pipeline and the Docker daemon present on the host system. Note that this is not a "Docker in Docker" Jenkins setup. This image requires the Docker socket to be mounted inside the Jenkins container. All the Docker commands issued by the Jenkins Docker Pipeline will be executed on the host system. This image also has Ansible installed.

This image is based on the official Jenkins image. Each time the official image is updated, Docker Hub will automatically trigger a rebuild of this image. 

### Running Jenkins CI

First, you will need to set up persistent storage for Jenkins and the Ansible inventory.

You will need a directory for each on the host, and you will need to give the `jenkins` user (UID 1000) ownership of both.

For Jenkins:

```bash
JENKINS_HOME=/home/$(whoami)/jenkins_home
mkdir $JENKINS_HOME
chown -R 1000 $JENKINS_HOME
```

For Ansible:

```bash
ANSIBLE_INVENTORY=/home/$(whoami)/ansible
mkdir $ANSIBLE_INVENTORY
chown -R 1000 $ANSIBLE_INVENTORY
```

Run Jenkins container by mounting the Docker socket and jenkins_home directory:

```
docker run -d --name jenkins \ 
	-p 8080:8080 -p 50000:50000 \ 
	-v /var/run/docker.sock:/var/run/docker.sock \ 
	-v /home/$(whoami)/jenkins_home:/var/jenkins_home \ 
	-v /home/$(whoami)/ansible:/etc/ansible \ 
	stefanprodan/jenkins
```

After starting the container, you can access Jenkins at `http://localhost:8080`. Look in the logs for the admin password that Jenkins is generating on first run:

```
docker logs jenkins
```

or run

```
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

After login, chose ***Select plugins to install*** and uncheck all.

### Jenkins plugins

Pre-installed plugins:

* Ant
* Ansible
* Build Timeout
* GitHub
* Gradle
* Pipeline
* Purge Job History
* CloudBees Docker Pipeline
* Credentials Binding
* Simple Theme Plugin
* SSH Agent
* SSH Slaves
* Timestamper
* Workspace Cleanup
* Xunit