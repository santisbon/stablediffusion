# Deployment on containers

## Prerequisites

In development your laptop will probably play all these roles:
- The CI server that builds and pushes the container image to a registry.
- The orchestrator control plane nodes.
- The orchestrator worker nodes.  

This guide illustrates that case but is designed to make it easy to go to an environment with multiple nodes on-premises or in the cloud. You'll need:
- Docker
- Kubernetes  

To automatically download the model files you need a [Huggingface token](https://huggingface.co/settings/tokens).  

Run the script **from the root directory** of the git repo.
```Shell
cat << EOF > ./containers/.env
HUGGINGFACE_TOKEN=xxxxxxxxx
PLATFORM=linux/amd64
STABLEDIFFUSION_TAG=stablediffusion
STABLEDIFFUSION_CONDA_ENV_FILE=environment.yaml
STABLEDIFFUSION_GIT=Stability-AI/stablediffusion
STABLEDIFFUSION_BRANCH=main
EOF
```
The `.env` file will be ignored by Docker so it won't go into the image. In production your CI server would probably use its own store for secrets and configuration instead.  

## Deployment

Run the script **from the root directory** of the git repo.  
```Shell
./containers/deploy.sh
```

To delete everything
```Shell
kubectl delete -f ./containers/objects.yml -n sdspace
```

## Verification

Check the status of the PersistentVolume and PersistentVolumeClaim to verify that they have been bound.  
Check the pods.
```Shell
kubectl get sc -n sdspace
kubectl get pv
kubectl get pvc -n sdspace
kubectl get pod -n sdspace
kubectl get deploy -n sdspace
```

## Use

Default output locations:
```
outputs/txt2img-samples
outputs/img2img-samples
```

Text-to-image
```
# To sample from the SD2.0-v model:
python scripts/txt2img.py --prompt "my prompt" --ckpt ./768model.ckpt --config configs/stable-diffusion/v2-inference-v.yaml --H 768 --W 768  
# To sample from the base model:
python scripts/txt2img.py --prompt "my prompt" --ckpt ./512-base-ema.ckpt --config configs/stable-diffusion/v2-inference.yaml
```

Image-to-image
```
# To augment the well-established img2img functionality of Stable Diffusion, we provide a shape-preserving stable diffusion model.
# The original method for image modification introduces significant semantic changes w.r.t. the initial image. 
# This model is particularly useful for a photorealistic style. 
# For a maximum strength of 1.0, the model removes all pixel-based information and relies only on the text prompt and the inferred monocular depth estimate.
# Sample via
python scripts/gradio/depth2img.py --prompt "photorealistic face with VR headset" --init-img ./some-img.jpg --strength 0.8 configs/stable-diffusion/v2-midas-inference.yaml ./midas_models/dpt_hybrid-midas-501f0c75.pt
# or 
streamlit run scripts/streamlit/depth2img.py --prompt "photorealistic face with VR headset" --init-img ./some-img.jpg configs/stable-diffusion/v2-midas-inference.yaml ./midas_models/dpt_hybrid-midas-501f0c75.pt

# For running the "classic" img2img, use this and adapt the checkpoint (SD2.0-* checkpoints?) and config paths accordingly.
python scripts/img2img.py --prompt "A fantasy landscape" --init-img ./some-img.jpg --strength 0.8 --ckpt ./768model.ckpt
```

Upscaling
```
# For a Gradio or Streamlit demo of the text-guided x4 superresolution model:
python scripts/gradio/superresolution.py configs/stable-diffusion/x4-upscaling.yaml ./x4-upscaler-ema.ckpt
# or
streamlit run scripts/streamlit/superresolution.py -- configs/stable-diffusion/x4-upscaling.yaml ./x4-upscaler-ema.ckpt
# This model can be used both on real inputs and on synthesized examples. 
# For the latter, we recommend setting a higher noise_level, e.g. noise_level=100
```

Inpainting
```
# For a Gradio or Streamlit demo of the inpainting model:
python scripts/gradio/inpainting.py configs/stable-diffusion/v2-inpainting-inference.yaml ./512-inpainting-ema.ckpt
# or
streamlit run scripts/streamlit/inpainting.py -- configs/stable-diffusion/v2-inpainting-inference.yaml ./512-inpainting-ema.ckpt
```
