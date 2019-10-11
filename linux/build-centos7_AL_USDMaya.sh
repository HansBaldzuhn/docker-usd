#!/usr/bin/env bash

set -e

export DOWNLOADS_DIR="`pwd`/../downloads"
export USD_VERSION="18.11"
export CUDA_VERSION="9.0"
export MAYA_VERSION="2019"
export AL_USD_VERSION="0.29.4"
export MAYA_MAJOR_VERSION="${MAYA_VERSION}"
export BUILD_PROC=`nproc`

export LOCAL_IP=`hostname -I|cut -d' ' -f1`


echo "Downloads folder: ${DOWNLOADS_DIR}"
#echo "Copy local root certificates for corporate networks"
#[ -e /etc/pki/ca-trust/source/anchors ] && cp -u /etc/pki/ca-trust/source/anchors/* cert/

export LOCAL_IP=`hostname -I|cut -d' ' -f1`

scripts/download_vfx.sh
scripts/download_maya.sh
scripts/download_usd.sh
scripts/download_AL_USDMaya.sh

# Start a local server to serve files needed during the build.
cd ${DOWNLOADS_DIR} && python -m SimpleHTTPServer && cd - &

httpServerPID=$(ps -ef | grep SimpleHTTPServer | grep -v grep | awk '{print $2}')
function finish {
  kill $httpServerPID
}
trap finish EXIT

echo "Build base: base centos packages and gcc"
docker build --build-arg current_host_ip_address=${LOCAL_IP} \
             --build-arg cuda_version=${CUDA_VERSION} \
             -t "usd-docker/base:1-centos7" -f centos7/base/Dockerfile .
docker tag "usd-docker/base:1-centos7" "usd-docker/base:latest-centos7"

echo "Build VFX packages"
docker build --build-arg current_host_ip_address=${LOCAL_IP} \
			 --build-arg build_proc=${BUILD_PROC} \
             -t "usd-docker/vfx:1-centos7" \
             -f centos7/vfx/Dockerfile .
docker tag "usd-docker/vfx:1-centos7" "usd-docker/vfx:latest-centos7"

echo "Build Maya v${MAYA_VERSION}"
docker build --build-arg current_host_ip_address=$LOCAL_IP \
             --build-arg maya_version=${MAYA_VERSION} \
             --build-arg build_proc=${BUILD_PROC} \
             -t "usd-docker/maya${MAYA_VERSION}:1-centos7" \
             -f centos7/maya/Dockerfile .
docker tag "usd-docker/maya${MAYA_VERSION}:1-centos7" "usd-docker/maya${MAYA_VERSION}:latest-centos7"

echo "Build USD v${USD_VERSION}"
docker build --build-arg current_host_ip_address=${LOCAL_IP} \
             --build-arg maya_version=${MAYA_VERSION} \
             --build-arg usd_version=${USD_VERSION} \
             --build-arg build_proc=${BUILD_PROC} \
             -t "usd-docker/maya${MAYA_VERSION}-usd:${USD_VERSION}-centos7" \
             -f centos7/usd/Dockerfile_maya .
docker tag "usd-docker/maya${MAYA_VERSION}-usd:${USD_VERSION}-centos7" "usd-docker/maya${MAYA_VERSION}-usd:latest-centos7"
docker tag "usd-docker/maya${MAYA_VERSION}-usd:${USD_VERSION}-centos7" "usd-docker/maya-usd:latest-centos7"


echo "Build AL_USDMaya plugin from Animal Logic"
docker build --build-arg current_host_ip_address=${LOCAL_IP} \
			 --build-arg usd_version=${USD_VERSION} \
			 --build-arg maya_version=${MAYA_VERSION} \
			 --build-arg al_usd_version=${AL_USD_VERSION} \
			 --build-arg build_proc=${BUILD_PROC} \
             -t "usd-docker/al_usdmaya_${AL_USD_VERSION}_${MAYA_VERSION}:${USD_VERSION}-centos7" \
             -f centos7/AL_USDMaya/Dockerfile .
docker tag "usd-docker/al_usdmaya_${AL_USD_VERSION}_${MAYA_VERSION}:${USD_VERSION}-centos7" "usd-docker/al_usdmaya:latest-centos7"

