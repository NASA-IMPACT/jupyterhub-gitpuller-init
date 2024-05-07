# Jupyterhub-Gitpuller-Init-Container

This repository contains the Dockerfile for an init container that can be used to pull a git repository into a JupyterHub user's workspace before the user's notebook server starts.

The init container clones the specified git repository into the user's workspace using `nbgitpuller`, and then sets the permissions of the cloned repository to be owned by the user.

The [bash script](./k8s/init-container/gitpuller.sh) that is run by the init container always exits with a status code of 0, so that the init container does not block the pod from starting.

## Configuration

The following environment variables can be set to configure the init container:

- `SOURCE_REPO`: The URL of the git repository to clone. This is a required variable.
- `TARGET_PATH`: The path to clone the repository to. This is a required variable.
- `SOURCE_BRANCH`: The branch to clone. Defaults to `main`.