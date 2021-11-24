# docker-build-push-action <img src="https://img.shields.io/badge/Docker-2496ed?style=for-the-badge&logo=docker&logoColor=white">

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
