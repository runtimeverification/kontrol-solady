ARG KONTROL_RELEASE
FROM runtimeverificationinc/kontrol:ubuntu-jammy-${KONTROL_RELEASE}

USER root
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

USER user 
RUN curl -L https://foundry.paradigm.xyz | bash
RUN /home/user/.foundry/bin/foundryup

ENV PATH="/home/user/.foundry/bin:${PATH}"