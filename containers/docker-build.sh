# Create a ~/.env file like the one in the example shown in env.sh
# Run this script (docker-build.sh) from the root folder of the GitHub repo

source ./containers/env.sh

# Build the Docker image
docker build \
  --platform="${PLATFORM}" \
  --tag "${STABLEDIFFUSION_TAG}" \
  --file ./containers/Dockerfile \
  .

# docker run -it --platform linux/amd64 --name mycontainer santisbon/stablediffusion-amd64

# Download model weights (maybe use a local k8s volume?)
# https://kubernetes.io/docs/concepts/storage/volumes/#local

mkdir -p ~/Downloads/models/midas_models

# txt2img. Download model weights for SD2.0-v and SD2.0-base. 
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -O ~/Downloads/models/768-v-ema.ckpt -nc https://huggingface.co/stabilityai/stable-diffusion-2/resolve/main/768-v-ema.ckpt
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -O ~/Downloads/models/512-base-ema.ckpt -nc https://huggingface.co/stabilityai/stable-diffusion-2-base/resolve/main/512-base-ema.ckpt

# img2img. Download the depth-conditional stable diffusion model 
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -O ~/Downloads/models/512-depth-ema.ckpt -nc https://huggingface.co/stabilityai/stable-diffusion-2-depth/resolve/main/512-depth-ema.ckpt
# and the dpt_hybrid MiDaS model weights. Place the dpt_hybrid MiDaS model weights in a folder midas_models.
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -O ~/Downloads/models/midas_models/dpt_hybrid-midas-501f0c75.pt -nc https://github.com/intel-isl/DPT/releases/download/1_0/dpt_hybrid-midas-501f0c75.pt

# Download upscaling weights
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -O ~/Downloads/models/x4-upscaler-ema.ckpt -nc  https://huggingface.co/stabilityai/stable-diffusion-x4-upscaler/resolve/main/x4-upscaler-ema.ckpt

# Download the SD 2.0-inpainting checkpoint
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -O ~/Downloads/models/512-inpainting-ema.ckpt -nc  https://huggingface.co/stabilityai/stable-diffusion-2-inpainting/resolve/main/512-inpainting-ema.ckpt

########## TXT2IMG ##########

# To sample from the SD2.0-v model:
# python scripts/txt2img.py --prompt "my prompt" --ckpt ./768model.ckpt --config configs/stable-diffusion/v2-inference-v.yaml --H 768 --W 768  

# To sample from the base model:
# python scripts/txt2img.py --prompt "my prompt" --ckpt ./512-base-ema.ckpt --config configs/stable-diffusion/v2-inference.yaml

########## IMG2IMG ##########

# To augment the well-established img2img functionality of Stable Diffusion, we provide a shape-preserving stable diffusion model.
# The original method for image modification introduces significant semantic changes w.r.t. the initial image. 
# This model is particularly useful for a photorealistic style. 
# For a maximum strength of 1.0, the model removes all pixel-based information and only relies on the text prompt and the inferred monocular depth estimate.
# Sample via
# python scripts/gradio/depth2img.py --prompt "photorealistic face with VR headset" --init-img ./some-img.jpg --strength 0.8 configs/stable-diffusion/v2-midas-inference.yaml ./midas_models/dpt_hybrid-midas-501f0c75.pt
# or 
# streamlit run scripts/streamlit/depth2img.py --prompt "photorealistic face with VR headset" --init-img ./some-img.jpg configs/stable-diffusion/v2-midas-inference.yaml ./midas_models/dpt_hybrid-midas-501f0c75.pt

# For running the "classic" img2img, use this and adapt the checkpoint (SD2.0-* checkpoints?) and config paths accordingly.
# python scripts/img2img.py --prompt "A fantasy landscape" --init-img ./some-img.jpg --strength 0.8 --ckpt ./768model.ckpt

########## UPSCALING ##########

# For a Gradio or Streamlit demo of the text-guided x4 superresolution model:
# python scripts/gradio/superresolution.py configs/stable-diffusion/x4-upscaling.yaml ./x4-upscaler-ema.ckpt
# or
# streamlit run scripts/streamlit/superresolution.py -- configs/stable-diffusion/x4-upscaling.yaml ./x4-upscaler-ema.ckpt
# This model can be used both on real inputs and on synthesized examples. 
# For the latter, we recommend setting a higher noise_level, e.g. noise_level=100

########## INPAINTING ##########

# For a Gradio or Streamlit demo of the inpainting model:
# python scripts/gradio/inpainting.py configs/stable-diffusion/v2-inpainting-inference.yaml ./512-inpainting-ema.ckpt
# or
# streamlit run scripts/streamlit/inpainting.py -- configs/stable-diffusion/v2-inpainting-inference.yaml ./512-inpainting-ema.ckpt

# Default output locations:
# outputs/txt2img-samples
# outputs/img2img-samples