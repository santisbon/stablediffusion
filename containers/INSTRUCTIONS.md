# Deployment on containers

## Prerequisites

In development your laptop will probably play all these roles:
- The CI server that builds and publishes the container image.
- The orchestrator control plane nodes.
- The orchestrator worker nodes.  

This guide illustrates that case but is designed to make it easy to go to an environment with multiple nodes on-premises or in the cloud. You'll need:
- Docker
- Kubernetes

To automatically download the model files you need a [Huggingface token](https://huggingface.co/settings/tokens). Add it to an env file as shown below.  
It's important to keep this file outside the git repo directory to avoid it getting copied into the Docker image. In production your CI server would probably use its own secrets store.  

Example `~/.env` file:
```Shell
HUGGINGFACE_TOKEN=xxxxxxxxx
ARCH=amd64
PLATFORM=linux/amd64
STABLEDIFFUSION_TAG=stablediffusion-amd64
STABLEDIFFUSION_CONDA_ENV_FILE=environment.yaml
STABLEDIFFUSION_GIT=Stability-AI/stablediffusion
STABLEDIFFUSION_BRANCH=main
```

## Deployment

Run the script **from the root directory** of the git repo.  

```Shell
./containers/deploy.sh
```

## Verification

Check the status of the PersistentVolume and PersistentVolumeClaim to verify that they have been bound.  
Check the pods.
```Shell
kubectl get pv
kubectl get pvc
kubectl get pods -n stablediffusion
```
