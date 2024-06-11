# Jupyterhub-Gitpuller-Init-Container

This repository contains the Dockerfile for an init container that can be used to pull a git repository into a JupyterHub user's workspace before the user's notebook server starts.

The init container clones the specified git repository into the user's workspace using `nbgitpuller`, and then sets the permissions of the cloned repository to be owned by the user.

The [bash script](./k8s/init-container/gitpuller.sh) that is run by the init container always exits with a status code of 0, so that the init container does not block the pod from starting.

## Configuration

The following environment variables can be set to configure the init container:

- `SOURCE_REPO`: The URL of the git repository to clone. This is a required variable.
- `TARGET_PATH`: The path to clone the repository to. This is a required variable.
- `SOURCE_BRANCH`: The branch to clone. Defaults to `main`.

## Usage

To use this init container in a JupyterHub deployment, add the necessary configuration to the [`singleuser.initContainers` section](https://z2jh.jupyter.org/en/stable/resources/reference.html#singleuser-initcontainers) of the JupyterHub configuration. Here is an example configuration that clones the `veda-docs` repository into the user's workspace:

```yaml
singleuser:
    initContainers:
        - name: jupyterhub-gitpuller-init
        image: public.ecr.aws/nasa-veda/jupyterhub-gitpuller-init:latest
        env:
            - name: TARGET_PATH
              value: veda-docs
            - name: SOURCE_REPO
              value: "https://github.com/NASA-IMPACT/veda-docs"
            - name: SOURCE_BRANCH
              value: "main"
```

Alternatively, if you're using [profiles](https://z2jh.jupyter.org/en/stable/jupyterhub/customizing/user-environment.html#using-multiple-profiles-to-let-users-select-their-environment) to let users select their environment, you can add the init container configuration to the `kubespawner_override.init_containers` section of the profile configuration. [Here's an example](https://github.com/2i2c-org/infrastructure/blob/b4bd289f48cbb0004e090a2ec6c2702baf6d7c21/config/clusters/nasa-veda/common.values.yaml#L114C1-L120C70) of such a configuration.

## Development

To build the Docker image, run the following command:

```bash
docker build -t jupyterhub-gitpuller-init .
```

To test the init container locally, you can run the following command to clone the `veda-docs` repository into the `/tmp` directory on your host machine:

```bash
docker run --rm -v /tmp:/home/jovyan -e TARGET_PATH=veda-docs -e SOURCE_REPO="https://github.com/NASA-IMPACT/veda-docs/" jupyterhub-gitpuller-init
```

and then check that the repository was cloned successfully:

```bash
ls /tmp/veda-docs
```