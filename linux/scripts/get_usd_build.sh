#!/usr/bin/env bash


INSTALL_DIR=/data/install/al-$AL_USD_VERSION-$USD_VERSION
USD_DIR=$INSTALL_DIR/usd
EXTRA_DIR=$INSTALL_DIR/extra

CPP_DEV=${INSTALL_DIR}/DEV

rm -fvr ${INSTALL_DIR}/* > /dev/null

mkdir -p ${USD_DIR}/bin
mkdir -p ${USD_DIR}/lib
mkdir -p ${USD_DIR}/include
mkdir -p ${USD_DIR}/share
mkdir -p ${INSTALL_DIR}/lib
mkdir -p ${EXTRA_DIR}/lib/python
mkdir -p ${CPP_DEV}/usd

# USD

cp -a /opt/usd/usd/$USD_VERSION/bin/* ${USD_DIR}/bin
cp -a /opt/usd/usd/$USD_VERSION/lib/* ${USD_DIR}/lib
cp -a /opt/usd/usd/$USD_VERSION/share/* ${USD_DIR}/share
cp -a /opt/usd/lib/* ${INSTALL_DIR}/lib

cp -a /usr/lib/python2.7/site-packages/PyOpenGL-3.0.2-py2.7.egg/OpenGL $EXTRA_DIR/lib/python/
cp -a /usr/lib64/python2.7/site-packages/PySide $EXTRA_DIR/lib/python/
cp -a /usr/local/cuda-9.0/targets/x86_64-linux/lib/libcudart* ${EXTRA_DIR}/lib
cp -a /usr/lib64/libpyside* ${EXTRA_DIR}/lib
cp -a /usr/lib64/libshiboken* ${EXTRA_DIR}/lib

# Source for IDE include path
cp -a /opt/usd/usd/$USD_VERSION/include ${CPP_DEV}/usd
cp -a /opt/usd/include ${CPP_DEV}/


# PIXAR MAYA
cp -a /opt/usd/usd/$USD_VERSION/third_party/maya ${USD_DIR}

# AL USD MAYA
cp -a /opt/usd/AL_USDMaya_${AL_USD_VERSION}_${MAYA_VERSION} ${INSTALL_DIR}


# Set permission
chown -R ${USER_NAME}:${GROUP_NAME} ${INSTALL_DIR}