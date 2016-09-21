# Jenkins CI 

This is a Jenkins CI Server image suitable for running CD work-flows inside containers using Jenkins Docker Pipeline and the Docker daemon present on the host system. Note that this is not a "Docker in Docker" Jenkins setup. This image requires the Docker socket to be mounted inside the Jenkins container. All the Docker commands issued by the Jenkins Docker Pipeline will be executed on the host system.

Pre-installed plugins:

* Docker Pipeline
* SSH Agent
* GitHub
* Xunit

### Running Jenkins CI

First you need to setup a persistent storage and mount it as `JENKINS_HOME`, you can do this by creating a directory on the host or by using a Docker volume.

Create a directory on the host and give ownership to the Jenkins user (uid 1000):

```bash
JENKINS_HOME=/home/$(whoami)/jenkins_home
mkdir $JENKINS_HOME
chown -R 1000 $JENKINS_HOME
```   

Run Jenkins container by mounting the Docker socket and jenkins_home directory:

```
docker run -d --name jenkins \ 
	-p 8080:8080 -p 50000:50000 \ 
	-v /var/run/docker.sock:/var/run/docker.sock \ 
	-v /home/$(whoami)/jenkins_home:/var/jenkins_home \ 
	stefanprodan/jenkins
```

After starting the container, you can access Jenkins at `http://localhost:8080`. Look in the logs for the admin password that Jenkins is generating on first run:

```
docker logs jenkins
```

