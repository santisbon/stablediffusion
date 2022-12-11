#!/usr/bin/env bash

source ./containers/env.sh

docker build \
  --platform="${PLATFORM}" \
  --tag "${STABLEDIFFUSION_TAG}" \
  --file ./containers/Dockerfile \
  .

docker push "${STABLEDIFFUSION_TAG}"

# Find the links to visit and for Hugging Face manually go get the real links that have "resolve" in the URL.
# grep -i https://huggingface.co/stabilityai/stable-diffusion README.md > containers/links.txt
# grep -i https://github.com/intel-isl/DPT/releases/download README.md > containers/links.txt
# https://huggingface.co/stabilityai/stable-diffusion-2-1
# https://huggingface.co/stabilityai/stable-diffusion-2-1-base
# https://huggingface.co/stabilityai/stable-diffusion-2-depth
# https://github.com/intel-isl/DPT/releases/download/1_0/dpt_hybrid-midas-501f0c75.pt
# https://huggingface.co/stabilityai/stable-diffusion-x4-upscaler
# https://huggingface.co/stabilityai/stable-diffusion-2-inpainting

mkdir -p ~/Downloads/models/midas_models
# Download model weights for _SD2.1-v_ and _SD2.1-base_ (txt2img).
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -O ~/Downloads/models/v2-1_768-ema-pruned.ckpt -nc https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-ema-pruned.ckpt
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -O ~/Downloads/models/v2-1_512-ema-pruned.ckpt -nc https://huggingface.co/stabilityai/stable-diffusion-2-1-base/resolve/main/v2-1_512-ema-pruned.ckpt
# Download the depth-conditional stable diffusion model (img2img) 
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -O ~/Downloads/models/512-depth-ema.ckpt -nc https://huggingface.co/stabilityai/stable-diffusion-2-depth/resolve/main/512-depth-ema.ckpt
# and the dpt_hybrid MiDaS model weights. Place the dpt_hybrid MiDaS model weights in a folder midas_models.
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -O ~/Downloads/models/midas_models/dpt_hybrid-midas-501f0c75.pt -nc https://github.com/intel-isl/DPT/releases/download/1_0/dpt_hybrid-midas-501f0c75.pt
# Download upscaling weights.
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -O ~/Downloads/models/x4-upscaler-ema.ckpt -nc  https://huggingface.co/stabilityai/stable-diffusion-x4-upscaler/resolve/main/x4-upscaler-ema.ckpt
# Download the SD 2.0-inpainting checkpoint.
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -O ~/Downloads/models/512-inpainting-ema.ckpt -nc  https://huggingface.co/stabilityai/stable-diffusion-2-inpainting/resolve/main/512-inpainting-ema.ckpt

kubectl create namespace sdspace
kubectl apply -f containers/objects.yml -n sdspace
