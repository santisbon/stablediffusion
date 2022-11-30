# Create a ~/.env file as in the example shown in env.sh
# Run this script (docker-build.sh) from the root folder of the GitHub repo

source ./containers/env.sh

# Build the Docker image
docker build \
  --platform="${PLATFORM}" \
  --tag "${STABLEDIFFUSION_TAG}" \
  --file ./containers/Dockerfile \
  .


# Default output locations:
# outputs/txt2img-samples
# outputs/img2img-samples

########## TXT2IMG ##########

# Download the weights for SD2.0-v and SD2.0-base. 
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -nc https://huggingface.co/stabilityai/stable-diffusion-2/blob/main/768-v-ema.ckpt
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -nc https://huggingface.co/stabilityai/stable-diffusion-2-base/resolve/main/512-base-ema.ckpt

# To sample from the SD2.0-v model:
# python scripts/txt2img.py --prompt "my prompt" --ckpt ./768model.ckpt --config configs/stable-diffusion/v2-inference-v.yaml --H 768 --W 768  

# To sample from the base model:
# python scripts/txt2img.py --prompt "my prompt" --ckpt ./512-base-ema.ckpt --config configs/stable-diffusion/v2-inference.yaml

########## IMG2IMG ##########

# To augment the well-established img2img functionality of Stable Diffusion, we provide a shape-preserving stable diffusion model.
# The original method for image modification introduces significant semantic changes w.r.t. the initial image. 
# If that is not desired, download our depth-conditional stable diffusion model 
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -nc https://huggingface.co/stabilityai/stable-diffusion-2-depth/resolve/main/512-depth-ema.ckpt
# and the dpt_hybrid MiDaS model weights, 
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -nc https://github.com/intel-isl/DPT/releases/download/1_0/dpt_hybrid-midas-501f0c75.pt
# place the latter in a folder midas_models. WHERE? root folder or in /scripts?
mkdir midas_models
mv ./dpt_hybrid-midas-501f0c75.pt midas_models/
# and sample via
# python scripts/gradio/depth2img.py --prompt "photorealistic face with VR headset" --init-img ./some-img.jpg --strength 0.8 configs/stable-diffusion/v2-midas-inference.yaml ./midas_models/dpt_hybrid-midas-501f0c75.pt
# or 
# streamlit run scripts/streamlit/depth2img.py --prompt "photorealistic face with VR headset" --init-img ./some-img.jpg configs/stable-diffusion/v2-midas-inference.yaml ./midas_models/dpt_hybrid-midas-501f0c75.pt
# This model is particularly useful for a photorealistic style. 
# For a maximum strength of 1.0, the model removes all pixel-based information and only relies on the text prompt and the inferred monocular depth estimate.

# For running the "classic" img2img, use this and adapt the checkpoint (SD2.0-* checkpoints?) and config paths accordingly.
# python scripts/img2img.py --prompt "A fantasy landscape" --init-img ./some-img.jpg --strength 0.8 --ckpt ./768model.ckpt

########## UPSCALING ##########

# Download the weights
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -nc  https://huggingface.co/stabilityai/stable-diffusion-x4-upscaler/resolve/main/x4-upscaler-ema.ckpt
# For a Gradio or Streamlit demo of the text-guided x4 superresolution model:
# python scripts/gradio/superresolution.py configs/stable-diffusion/x4-upscaling.yaml ./x4-upscaler-ema.ckpt
# or
# streamlit run scripts/streamlit/superresolution.py -- configs/stable-diffusion/x4-upscaling.yaml ./x4-upscaler-ema.ckpt
# This model can be used both on real inputs and on synthesized examples. 
# For the latter, we recommend setting a higher noise_level, e.g. noise_level=100

########## INPAINTING ##########

# Download the SD 2.0-inpainting checkpoint
wget --header="Authorization: Bearer ${HUGGINGFACE_TOKEN}" -nc  https://huggingface.co/stabilityai/stable-diffusion-2-inpainting/resolve/main/512-inpainting-ema.ckpt
# For a Gradio or Streamlit demo of the inpainting model:
# python scripts/gradio/inpainting.py configs/stable-diffusion/v2-inpainting-inference.yaml ./512-inpainting-ema.ckpt
# or
# streamlit run scripts/streamlit/inpainting.py -- configs/stable-diffusion/v2-inpainting-inference.yaml ./512-inpainting-ema.ckpt
