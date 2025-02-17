set dotenv-filename := ".env"

build:
  docker build --platform linux/amd64  --build-arg KUBE_VERSION=latest --build-arg DOCKER_VERSION=5:27.5.1-1~ubuntu.24.04~noble -t rauerhans/aws-kubectl-docker:latest .

login:
  echo $DOCKERHUB_TOKEN | docker login --username rauerhans --password-stdin

push:
  docker push rauerhans/aws-kubectl-docker:latest
  docker tag rauerhans/aws-kubectl-docker:latest rauerhans/aws-kubectl-docker:0.0.1
  docker push rauerhans/aws-kubectl-docker:0.0.1

build-login-push: build login push

