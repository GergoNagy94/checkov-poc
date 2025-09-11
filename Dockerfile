FROM python:3.13-slim

ARG AWS_CLI_VERSION=2.29.0
ARG TERRAGRUNT_VERSION=v0.87.0
ARG OPENTOFU_VERSION=1.7.2

ARG TARGETARCH

RUN apt-get update && apt-get install -y \
    fd-find \
    curl \
    unzip \
    git \
    ca-certificates \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

RUN case $TARGETARCH in \
    amd64) AWS_ARCH=x86_64 ;; \
    arm64) AWS_ARCH=aarch64 ;; \
    esac && \
    curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}-${AWS_CLI_VERSION}.zip" -o awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install --bin-dir /usr/local/bin && \
    rm -rf awscliv2.zip aws

RUN aws --version

RUN case $TARGETARCH in \
    amd64) TERRAGRUNT_ARCH=amd64 ;; \
    arm64) TERRAGRUNT_ARCH=arm64 ;; \
    esac && \
    curl -sL "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_${TERRAGRUNT_ARCH}" -o /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt

RUN terragrunt --version

RUN case $TARGETARCH in \
    amd64) OPENTOFU_ARCH=amd64 ;; \
    arm64) OPENTOFU_ARCH=arm64 ;; \
    esac && \
    curl -sL "https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_linux_${OPENTOFU_ARCH}.zip" -o opentofu.zip && \
    unzip opentofu.zip -d /usr/local/bin && \
    rm opentofu.zip && \
    chmod +x /usr/local/bin/tofu

RUN pip install --upgrade pip setuptools && \
    pip install checkov

CMD ["/bin/bash"]
