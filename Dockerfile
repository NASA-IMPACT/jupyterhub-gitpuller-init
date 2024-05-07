FROM python:3.12-slim
ENV VERSION=0.0.1

LABEL org.opencontainers.image.source=https://github.com/NASA-IMPACT/jupyterhub-gitpuller-init

ENV DEBIAN_FRONTEND=non-interactive
RUN echo "installing apt-get packages..." \
    && apt-get update --fix-missing > /dev/null \
    && apt-get install -y apt-utils git > /dev/null \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV NB_USER=jovyan
RUN echo "creating ${NB_USER} user..." \
    # Create a group for the user to be part of, with gid same as uid
    && groupadd --gid 1000 ${NB_USER} \
    # Create non-root user, with given gid, uid and create $HOME
    && useradd --create-home --gid 1000 --no-log-init --uid 1000 ${NB_USER}

RUN pip3 install nbgitpuller

USER jovyan
WORKDIR /opt

COPY --chown=jovyan:jovyan ./k8s-init-gitpuller.sh /opt/k8s-init-gitpuller.sh
RUN chmod 777 /opt/k8s-init-gitpuller.sh

CMD ["bash", "/opt/k8s-init-gitpuller.sh"]