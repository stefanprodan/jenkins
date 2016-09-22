FROM jenkins:2.7.4

# Configure Jenkins
COPY config/*.xml $JENKINS_HOME/
COPY config/executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

# Install plugins
RUN /usr/local/bin/install-plugins.sh \
    ant:1.4 \
    ansible:0.5 \
    gradle:1.25 \
    xunit:1.102 \
    workflow-aggregator:2.4 \
    docker-workflow:1.8 \
    build-timeout:1.17.1 \
    credentials-binding:1.9 \
    ssh-agent:1.13 \
    ssh-slaves:1.11 \
    timestamper:1.8.6 \
    ws-cleanup:0.30 \
    email-ext:2.47 \
    github-organization-folder:1.5 \
    purge-job-history:1.1 \
    simple-theme-plugin:0.3

USER root

# Install Docker from official repo
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -qqy apt-transport-https ca-certificates && \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
        --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo deb https://apt.dockerproject.org/repo debian-jessie main > /etc/apt/sources.list.d/docker.list && \
    apt-get update -qq && \
    apt-get install -qqy docker-engine && \
    usermod -aG docker jenkins && \
    chown -R jenkins:jenkins $JENKINS_HOME/

ENV ANSIBLE_HOME=/opt/ansible

# Install Ansible (+deps) from git repo & cleanup
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends -qqy \
        build-essential \
        python-pip python-dev python-yaml \
        libffi-dev libssl-dev \
        libxml2-dev libxslt1-dev zlib1g-dev && \
    pip install --upgrade wheel setuptools && \
    pip install --upgrade pyyaml jinja2 pycrypto && \
    git clone git://github.com/ansible/ansible.git --recursive && \
    cd ansible && \
    bash -c 'source ./hacking/env-setup' && \
    mkdir -p $ANSIBLE_HOME && \
    mv /ansible/bin $ANSIBLE_HOME/bin && \
    mv /ansible/lib $ANSIBLE_HOME/lib && \
    mv /ansible/docs $ANSIBLE_HOME/docs && \
    rm -rf /ansible && \
    apt-get install -qqy sshpass openssh-client && \
    apt-get remove -y --auto-remove build-essential python-pip python-dev libffi-dev libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts && \
    chown -R jenkins:jenkins $ANSIBLE_HOME/

USER jenkins

ENV ANSIBLE_HOME=/opt/ansible \
    PATH=$ANSIBLE_HOME/bin:$PATH \
    PYTHONPATH=$ANSIBLE_HOME/lib:$PYTHONPATH \
    MANPATH=$ANSIBLE_HOME/docs/man:$MANPATH

VOLUME ["/var/jenkins_home", "/var/run/docker.sock", "/etc/ansible"]