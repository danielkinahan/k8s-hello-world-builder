# k8s-hello-world-builder

## Run hello-world app as a docker container for testing

```bash
docker build -f ./hello-world.Dockerfile -t hello-world .
docker run -p 5000:5000 hello-world
```

## Push to registry for access from kubernetes deployment

```bash
docker image tag hello-world dankinah/hello-world:latest
docker image push dankinah/hello-world:latest

docker build -f ./builder.Dockerfile -t builder .
docker image tag builder dankinah/builder:latest
docker image push dankinah/builder:latest
```

## Test image for building capabilites

```bash
/bin/sh -c "git clone https://github.com/danielkinahan/k8s-hello-world-builder.git && cd k8s-hello-world-builder && docker build -f ./hello-world.Dockerfile -t hello-world ."
```

## Launch kubernetes deployment and service

```bash
kubectl apply -f hello-world-deployment.yml
kubectl apply -f hello-world-service.yml

```

## Check deployment logs

```bash
kubectl logs hello-world-deployment -c hello-world
```

## Destroy deployment and service

```bash
kubectl delete deployments hello-world-deployment
kubectl delete svc hello-world-service
```
