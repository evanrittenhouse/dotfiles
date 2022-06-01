FROM --platform=linux/amd64 ubuntu:18.04
RUN apt update && apt install -y git curl && sh -c "$(curl -fsLS chezmoi.io/get)"
RUN chezmoi init https://github.com/evanrittenhouse/chezmoi_dotfiles.git && chezmoi apply
