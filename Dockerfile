# Copyright 2021 Juicedata Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.18-buster as builder

WORKDIR /workspace
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/work/openjdk-8u332
ENV PATH=$PATH:${JAVA_HOME}/bin
RUN  rm -rf /var/lib/apt/lists/*  \
    && apt-get clean \
    && apt-get update -o Acquire::CompressionTypes::Order::=gz \
    && apt-get update \
    && apt-get \
    -o Acquire::BrokenProxy="true" \
    -o Acquire::http::No-Cache="true" \
    -o Acquire::http::Pipeline-Depth="0" install \
    -y --no-install-recommends --fix-missing locales \
      musl-tools upx-ucl librados-dev maven git gcc && \
    ln -fs /bin/bash /bin/sh && mkdir -p /work && \
    wget --quiet "http://download.byzer.org/byzer/misc/jdk/jdk8/openjdk-8u332-b09-linux-x64.tar.gz" && \
    tar -xf openjdk-8u332-b09-linux-x64.tar.gz -C /work/ && \
    mv /work/openlogic-openjdk-8u332-b09-linux-x64 /work/openjdk-8u332 && \
    rm openjdk-8u332-b09-linux-x64.tar.gz

COPY . .
COPY ./settings.xml /usr/share/maven/conf/settings.xml
RUN cat /usr/share/maven/conf/settings.xml && \
    go env -w GO111MODULE=on && \
    go env -w GOPROXY=https://goproxy.io,direct && \
    cd /workspace/sdk/java && make

ENTRYPOINT ["tail"]