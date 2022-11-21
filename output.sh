#!/bin/bash
#从容器中复制出jar以及可执行文件

OUT_DIR=./out
CONTAINER_ID=`docker ps|grep juicefs|awk '{print $1}'`
#docker exec -it $CONTAINER_ID /bin/sh /workspace/make.sh
if [[ ! -d $OUT_DIR ]];then
   mkdir $OUT_DIR
fi
docker cp $CONTAINER_ID:/workspace/sdk/java/target/juicefs-hadoop-1.0.2.jar ./out/juicefs-hadoop-1.0.2.jar
docker cp $CONTAINER_ID:/workspace/juicefs ./out/juicefs
