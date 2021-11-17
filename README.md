# docker-build-push-action

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
        uses: NRO04/docker-build-push-action@v1
        with: #args for action, all of them are required.
          name-repository: ${{ github.repository }} #repository name, specify what the repository will be called on dockerhub.
          tag: v1 #tag for repository
          docker-username: ${{ secrets.DOCKER_HUB_USERNAME }} # docker account - username
          docker-password: ${{ secrets.DOCKER_HUB_PASSWORD }} # docker account - password
```
