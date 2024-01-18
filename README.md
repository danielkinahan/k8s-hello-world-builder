# k8s-hello-world-builder

## About

k8s-hello-world-builder is an example of how one could build an image from a Dockerfile located in git in an initContainer of a k8 pod and then deploy from the built image in the subsequent regular containers of the pod. It uses a 'Docker out of Docker' approach which mounts the Docker daemon that the k8 worker uses. The constraint was to use only two containers and make use only of the local containerd runtime, without any exterior docker registries. However, this approach requires a privileged container and modifying the kubernetes runtime, which have security and reliability issues. A more secure way to do this would be to implement Kaniko, a tool for building docker images without a docker daemon. There are 3 ways to achieve this solution using Kaniko:

- Push the image to an external registry then pull from it when creating the hello-world container.
- Build the image into a tar file and load it in a second init container using [Docker in Docker](https://hub.docker.com/_/docker).
- Implementation of [this issue](https://github.com/GoogleContainerTools/kaniko/issues/1331) which outlines how Kaniko could push to the local docker daemon.

## Structure

- **k8s-hello-world-builder/:** Helm chart
- **hello-world-deployment.yaml:** K8 deployment description outlining the build and deployment steps
- **hello-world-service.yaml:** K8 service description with ports assigned according to NodePort
- **builder.Dockerfile:** Dockerfile for builder container, which requires docker and git installed. Pushed to external registry docker.io
- **hello-world.Dockerfile:** Dockerfile for hello-world web server, built using builder initContainer
- **app.py:** Python flask application built in hello-world.Dockerfile
- **requirements.txt:** Pip requirements for flask application

## Usage

### Launch using helm

```bash
helm install k8s-hello-world-builder-release ./k8s-hello-world-builder
```

## Development

### Run hello-world app as a docker container for testing

```bash
docker build -f ./hello-world.Dockerfile -t hello-world .
docker run -p 5000:5000 hello-world
```

### Push to registry for access from kubernetes deployment

```bash
docker build -f ./builder.Dockerfile -t builder .
docker image tag builder dankinah/builder:0.1.0
docker image push dankinah/builder:0.1.0
```

### Test image for building capabilites

```bash
/bin/sh -c "git clone https://github.com/danielkinahan/k8s-hello-world-builder.git && cd k8s-hello-world-builder && docker build -f ./hello-world.Dockerfile -t hello-world ."
```

### Launch kubernetes deployment and service

```bash
kubectl apply -f hello-world-deployment.yaml
kubectl apply -f hello-world-service.yaml
```

### Check app logs

```bash
kubectl logs hello-world-deployment-... -c builder
kubectl logs hello-world-deployment-... -c hello-world
```

### Expose service from minikube

```bash
minikube service hello-world-service
```

### Destroy deployment and service

```bash
kubectl delete deployments hello-world-deployment
kubectl delete svc hello-world-service
```
