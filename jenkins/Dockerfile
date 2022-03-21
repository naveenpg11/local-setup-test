FROM jenkins/jenkins:2.320

USER root

# install docker commandline interface, terrafoprm and their dependencies
RUN apt update && apt install -y lsb-release \
    software-properties-common \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb [arch=arm64] \
    https://download.docker.com/linux/debian $(lsb_release -cs) stable " \
    && apt update && apt install -y docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && add-apt-repository "deb [arch=arm64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update && apt-get install terraform=1.0.10

# bootstarp
RUN jenkins-plugin-cli --plugins blueocean:1.25.1
COPY run.sh /run.sh
COPY ./jenkins.yml /usr/share/jenkins/ref/casc_configs/jenkins.yml
COPY jobs/sample-app-build-and-deploy/config.xml /usr/share/jenkins/ref/jobs/sample-app-build-and-deploy/config.xml

ENTRYPOINT ["bash","-x","/run.sh"]