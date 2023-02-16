# Containers

## Ubuntu

- Detail about how to use github registry
  - https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry

```bash
export tagname=202211
# change the variable your_personal_token to yours
export your_personal_token=ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# docker build . -t ghcr.io/saqwed/edk2_ubuntu_container:202211 -f Dockerfile-Ubuntu 
DOCKER_BUILDKIT=1 docker build --no-cache -t ghcr.io/saqwed/edk2_ubuntu_container:${tagname} . -f Dockerfile-Ubuntu
export CR_PAT=${your_personal_token}
echo $CR_PAT | docker login ghcr.io -u saqwed --password-stdin
docker push ghcr.io/saqwed/edk2_ubuntu_container:${tagname}
```
