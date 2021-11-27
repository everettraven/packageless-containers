---
title: Contributing
id: contributing
---

Thanks for your interest in contributing to the packageless-containers repository!

There are a couple ways that you can contribute to this repository, by raising issues or by adding/modifying Dockerfiles.

## Raising an issue
One way to contribute to the packageless-containers repository is to raise an issue for any problems you may find with the container images that are kept here. The issues have a general template, so fill the template out with the issue you are experiencing as well as steps to reproduce the issue and we will get to resolving it as soon as we can!

## Dockerfiles
### Modifying Dockerfiles
If you would like to modify existing Dockerfiles, follow the below steps:
1. Fork the packageless-containers repository
2. Clone the forked repository
3. Create a new branch that follows the format **improvement/{package}**, where *package* is the package where the Dockerfile is being modified, E.g. git
4. Make your modifications
5. Test building and running the image locally to ensure it works as expected!
6. Push your changes to your forked repository
7. Issue a pull request and fill out the template with the necessary information

### Adding Dockerfiles
If you would like to add new Dockerfiles to an existing package (you would likely do this only to add a new version to the package) follow the below steps:
1. Fork the packageless-containers repository
2. Clone the forked repository
3. Create a new branch that follows the format **feature/{package}-{version}** where *package* is the package where you are adding a new Dockerfile (e.g. git) and *version* is the version of the package you are adding a new Dockerfile for (e.g. feature/python-3.6)
4. Create a new directory under the package you are modifying with the name being the version you are adding. For example, if I wanted to add python 3.6 I would create the directory python/3.6
5. Create your Dockerfile in the newly created folder
6. Test building and running the image locally to ensure it works as expected!
7. Push the changes to your forked repository
8. Issue a pull request and fill out the template with the necessary information
   
If you would like to add an entirely new package, you will need to follow the below steps:
1. Fork the packageless-containers repository
2. Clone the forked repository
3. Create a new branch that follows the format **feature/{package}** where *package* is the package where you are adding.
4. Create a new directory under the dockerfiles directory with the name of the package you are adding. For example, if I wanted to add python I would create the directory dockerfiles/python
5. For each version of the package that you are going to add you need to create a separate directory with the version being the name of the directory. For example, if I wanted to add the python package with versions 3.6 and 3.7 I would create python/3.6 and python/3.7
6. Add the Dockerfiles to the proper directories
7. Test building and running each image to ensure that it works as expected!
8. Since we are adding a new package we need to add a new GitHub Actions workflow to automatically build and push the images. To do this, create a new file under the .github/workflows directory that follows the format **{package}.yml** where *package* is the name of the package that you are adding.
9. Add the following code to the new workflow file, replacing all instances of *{package_here}* with the name of the package you are adding:
```
name: build and push {package_here} images

on:
  push:
    branches: [ main ]
    paths:
      - 'dockerfiles/{package_here}/*'
  
  workflow_dispatch:

jobs:
  matrix-config:
    runs-on: ubuntu-latest
    outputs:
      matrix: ${{ steps.set-matrix.outputs.matrix }}
    steps:
      - uses: actions/checkout@v2
      - id: set-matrix
        run: |
          chmod +x matrix-gen.sh
          matrix_arr=($(./matrix-gen.sh {package_here}))
          echo ${matrix_arr[@]}
          echo "::set-output name=matrix::{\"include\":[${matrix_arr[@]}]}"

  build-push-images:
    needs: matrix-config
    runs-on: ubuntu-latest
    strategy:
      matrix: ${{ fromJson(needs.matrix-config.outputs.matrix) }}
    steps:
      - name: Checkout repo
        uses: actions/checkout@v2
      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1
      - name: Set up Docker Buildx
        id: buildx
        uses: docker/setup-buildx-action@v1
      - name: Login to DockerHub
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      - name: Build & Push
        uses: docker/build-push-action@v2
        with:
          builder: ${{ steps.buildx.outputs.name }}
          platforms: linux/amd64, linux/arm64/v8
          context: .
          file: ${{ matrix.path }}
          push: true
          tags: "packageless/{package_here}:${{ matrix.tag }}"
```
10. Push changes to your forked repository
11. Issue a pull request and fill out the template with any necessary information