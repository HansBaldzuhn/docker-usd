#!/usr/bin/env bash

export USD_VERSION="18.11"
export MAYA_VERSION="2019"
export AL_USD_VERSION="0.29.4"

docker build --build-arg user_name=`id -un` \
			 --build-arg user_id=`id -u` \
			 --build-arg home=${HOME}  \
			 --build-arg group_name=`id -gn` \
			 --build-arg group_id=`id -g` \
			 --build-arg usd_version=${USD_VERSION} \
			 --build-arg maya_version=${MAYA_VERSION} \
			 --build-arg al_usd_version=${AL_USD_VERSION} \
			 -t "usd-docker/usd_get_build_${AL_USD_VERSION}:${USD_VERSION}-centos7" \
             -f centos7/AL_USDMaya/Dockerfile_getbuild .

docker tag "usd-docker/usd_get_build_${AL_USD_VERSION}:${USD_VERSION}-centos7" "usd-docker/usd_get_build:latest-centos7"

docker run --rm \
	--name "usd-docker" \
	-v="${HOME}/USD/install:/data/install:rw" \
	"usd-docker/usd_get_build_${AL_USD_VERSION}:${USD_VERSION}-centos7"