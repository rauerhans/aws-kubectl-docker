build:
  docker build --platform linux/amd64  --build-arg KUBE_VERSION=latest --build-arg DOCKER_VERSION=5:27.5.1-1~ubuntu.24.04~noble -t rauerhans/aws-kubectl-docker .

