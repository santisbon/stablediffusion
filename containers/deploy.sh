#!/usr/bin/env bash

source ./containers/env.sh

docker build \
  --platform="${PLATFORM}" \
  --tag "${STABLEDIFFUSION_TAG}" \
  --file ./containers/Dockerfile \
  .

docker push "${STABLEDIFFUSION_TAG}"

mkdir -p ~/Downloads/models/midas_models
# Download model weights for SD2.0-v and SD2.0-base (txt2img).
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -O ~/Downloads/models/768-v-ema.ckpt -nc https://huggingface.co/stabilityai/stable-diffusion-2/resolve/main/768-v-ema.ckpt
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -O ~/Downloads/models/512-base-ema.ckpt -nc https://huggingface.co/stabilityai/stable-diffusion-2-base/resolve/main/512-base-ema.ckpt
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
