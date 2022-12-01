# Deployment on containers

## Prerequisites

In development your laptop will probably play all the roles:
- The CI server that builds and publishes the container image.
- The orchestrator (Kubernetes) control plane.
- The orchestrator worker nodes.  
This guide illustrates that single-node case but is designed to make it easy to go to an environment with multiple nodes on-premises or in the cloud.  

To download the model files you need a Huggingface token. Add it to an env file as shown below.  
It's important to keep this file outside the git repo directory to avoid it getting copied into the Docker image.  

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

Run all scripts **from the root directory** of the git repo.  

```Shell
./containers/deploy.sh
```
