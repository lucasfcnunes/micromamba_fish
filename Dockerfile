FROM ubuntu:22.04
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN \
  --mount=type=cache,target=/var/cache/apt/ \
  --mount=type=cache,target=/var/lib/apt/ \
  export DEBIAN_FRONTEND=noninteractive \
  && apt update \
  && apt install -y fish curl

ARG USER=micromamba_fish
RUN useradd -m -d /home/${USER}/ -s $(which bash) -G sudo ${USER}
SHELL [ "bash", "-i", "-c" ]
USER ${USER}

RUN curl micro.mamba.pm/install.sh | bash
RUN \
  micromamba install -y -n base -c conda-forge python=3.10 \
  && micromamba clean --all --yes
RUN \
  echo \
  && micromamba shell init -s bash \
  && micromamba shell init -s fish \
  && micromamba config set auto_activate_base true

ENTRYPOINT [ "fish" ]
