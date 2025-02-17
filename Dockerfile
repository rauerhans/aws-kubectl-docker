# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set environment variables to non-interactive (this prevents some prompts)
ENV DEBIAN_FRONTEND=noninteractive

# Define the Kubernetes and Docker versions as build arguments with default values
ARG KUBE_VERSION=latest
ARG DOCKER_VERSION=5:27.5.1-1~ubuntu.24.04~noble

# Run updates and install prerequisites including jq
RUN apt-get update && apt-get install -y \
  curl \
  unzip \
  jq \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Install Docker client
RUN apt-get update && \
  install -m 0755 -d /etc/apt/keyrings | curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
  chmod a+r /etc/apt/keyrings/docker.asc && \
  # Add the repository to Apt sources:
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
  apt-get update && apt-get install -y --no-install-recommends \
  docker-ce-cli=${DOCKER_VERSION} \
  && rm -rf /var/lib/apt/lists/*

# Download AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip AWS CLI v2
RUN unzip awscliv2.zip

# Install AWS CLI v2
RUN ./aws/install

# Cleanup AWS CLI installer
RUN rm -f awscliv2.zip

# Install kubectl using the specified version or fetch the latest
RUN if [ "${KUBE_VERSION}" = "latest" ]; then \
  KUBE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt); \
  fi && \
  curl -LO "https://dl.k8s.io/release/${KUBE_VERSION}/bin/linux/amd64/kubectl" \
  && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install envsubst
RUN curl -L https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-`uname -s`-`uname -m` -o envsubst && chmod +x envsubst && mv envsubst /usr/local/bin


# Cleanup and final touches
RUN apt-get update && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set default command
CMD ["bash"]
