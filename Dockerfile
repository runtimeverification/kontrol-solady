FROM ghcr.io/runtimeverification/devops/kup:643101c

USER root
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

USER ubuntu 
RUN curl -L https://foundry.paradigm.xyz | bash
RUN /home/ubuntu/.foundry/bin/foundryup

ARG KONTROL_RELEASE=v0.1.15
RUN kup install kontrol --version $KONTROL_RELEASE 
RUN nix-store --gc 