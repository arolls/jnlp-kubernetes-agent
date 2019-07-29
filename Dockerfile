FROM jenkinsci/jnlp-slave:3.16-1

ARG DOCKER_VERSION=17.06.2~ce-0~debian
ARG DC_VERSION=1.18.0

USER root

RUN apt-get update && \
    apt-get install -qq -y --no-install-recommends apt-transport-https ca-certificates curl gnupg2 software-properties-common gnupg2 git make gettext cl-base64 wget lsb-release sed gpg unzip
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" && \
    apt-get update && \
    apt-get install -qq -y --no-install-recommends docker-ce=${DOCKER_VERSION} && \
    curl -L https://github.com/docker/compose/releases/download/${DC_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN wget https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz && \
    tar -xzvf helm-v2.12.3-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null && \
    AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install azure-cli
RUN curl -o vault.zip https://releases.hashicorp.com/vault/1.1.0/vault_1.1.0_linux_amd64.zip ; yes | unzip vault.zip && \
    mv vault /usr/local/bin/
RUN curl -fL https://getcli.jfrog.io | sh && \
    mv jfrog /usr/local/bin/
RUN wget https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    apt-key add apt-key.gpg && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl && \
    mkdir /root/.kube
VOLUME ["/git"]
WORKDIR /git
