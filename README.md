# CI - Docker: Build and Push action <img src="https://img.shields.io/badge/Docker-2496ed?style=for-the-badge&logo=docker&logoColor=white">

This action makes it esasy to build and push your docker image to your repository on DockerHub.


## Set up 

To perform this action, you'll need to provide the DockerHub credentials, for security, it is recommended to create secrets on your repository.

Create secrets: 
To authenticate against Docker Hub it's strongly recommended to create a personal access token as an alternative to your password.
  - Go to Settings  >  Secrets, then create secrets for your credentials.
  - username
  - password (use access token)


| Inputs            |  Decription               | Required
| -------------     |:------------------:       | :-------------:|
| docker-username   | Username from dockerhub    | yes
| docker-password   | Password from dockerhub   | yes
| tag               | tag for repository        | yes
| name-repository   | name for repository       | yes




## Usage

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
          docker-username: ${{ secrets.DOCKERHUB_USERNAME }} # docker account - username
          docker-password: ${{ secrets.DOCKERHUB_ACCESS_TOKEN }} # docker password, it should use access token
         
```
