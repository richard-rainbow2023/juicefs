#!/bin/bash
#author hongyang
#date 2022/11/02
#构建镜像
docker build -t ccb/juicefs:v3.0 -f Dockerfile . --no-cache
