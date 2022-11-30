FROM    continuumio/miniconda3
SHELL   ["/bin/bash", "-c"]
RUN     apt update && apt upgrade -y

WORKDIR /app
COPY    environment.yaml setup.py ./
RUN     conda init bash && source ~/.bashrc && conda env create -f environment.yaml && conda activate ldm
COPY    . .
RUN     rm -rf .git .gitignore containers

# CMD   tail -f /dev/null
