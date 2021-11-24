# docker-build-push-action <img src="https://img.shields.io/badge/Docker-2496ed?style=for-the-badge&logo=docker&logoColor=white" style="border-radius: 1.2rem;">

<img src="https://camo.githubusercontent.com/607f5f48387c389e7ea1206a02530235cbae93b1e1fd3bf374c4ae9401fce2de/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f446f636b65722d3234393665643f7374796c653d666f722d7468652d6261646765266c6f676f3d646f636b6572266c6f676f436f6c6f723d7768697465" data-canonical-src="https://img.shields.io/badge/Docker-2496ed?style=for-the-badge&amp;logo=docker&amp;logoColor=white" style="max-width: 100%;border-radius: 1.2rem;">
Action to build an push docker images to your repository on DockerHub

# USAGE

```yaml
name: CI_RO

on: # trigger event
  push: # event push
    branches: [master]

jobs:
  example: # name of job
    name: BUILD DOCKER IMAGE
    runs-on: ubuntu-latest # SO where jobs will execute.
    steps: # sequence tasks to do.
      - name: PULL REPOSITORY
        uses: actions/checkout@v2

      - name: USING ACTION TO BUILD AND PUST :)
        uses: NRO04/docker-build-push-action@v2
        with: #args for action, all of them are required.
          name-repository: ${{ github.repository }} #repository name, specify what the repository will be called on dockerhub.
          tag: v1 #tag for repository
          docker-username: ${{ secrets.DOCKER_HUB_USERNAME }} # docker account - username
          docker-password: ${{ secrets.DOCKER_HUB_PASSWORD }} # docker account - password
```
