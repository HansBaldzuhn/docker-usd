#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Please pass the USD version as first argument (e.g. 19.05)"
  exit 1
fi

usd_version=$1

DATA_PATH="../data"
if [ ! -f $DATA_PATH/retrotv.usdz ]; then
	wget https://developer.apple.com/arkit/gallery/models/retrotv/retrotv.usdz --output-document=$DATA_PATH/retrotv.usdz
fi

#	--runtime=nvidia \
#docker run --rm -it \
#	--name "usd-docker" \
#	--env DISPLAY \
#	-v /tmp/.X11-unix:/tmp/.X11-unix \
#	--env QT_X11_NO_MITSHM=1 \
#	-v="$HOME:/home/usd:rw" \
#	-v="$(dirname `pwd`)/data:/data:rw" \
#	"hbaldzuhn/usd:19.05-centos7"