#!/usr/bin/env bash
set -e

mkdir -p $TMP_DIR

#----------------------------------------------
# Checkout, build and install USD
# TODO: use a zipped version of AL_USDMaya to have a more consistant run
#----------------------------------------------

export MAYA_BUILD_DIR=${BUILD_DIR}/AL_USDMaya_${AL_USD_VERSION}_${MAYA_VERSION}

export PATH=$MAYA_LOCATION/bin:$PATH

cd $TMP_DIR
tar -zxf $DOWNLOADS_DIR/AL_USDMaya-${AL_USD_VERSION}.tar.gz 
  cd AL_USDMaya-${AL_USD_VERSION} &&\
    rm -Rf build &&\
    mkdir -p build &&\
    cd build  &&\
      echo "MayaLocation=${MAYA_LOCATION}"
      echo "UsdPxrConfig=$BUILD_DIR/usd/${USD_VERSION}/pxrConfig.cmake"
      cmake -Wno-dev \
            -DCMAKE_INSTALL_PREFIX=$MAYA_BUILD_DIR \
            -DCMAKE_MODULE_PATH=$BUILD_DIR \
            -DBOOST_ROOT=$BUILD_DIR \
            -DMAYA_LOCATION=$MAYA_LOCATION \
            -DGTEST_ROOT=$BUILD_DIR \
            -DUSD_CONFIG_FILE=$BUILD_DIR/usd/${USD_VERSION}/pxrConfig.cmake \
            -DCMAKE_PREFIX_PATH=$MAYA_LOCATION/lib/cmake \
            -DUSD_MAYA_ROOT=$BUILD_DIR/usd/${USD_VERSION} \
            -DBUILD_USDMAYA_PXR_TRANSLATORS=OFF \
            -DPXR_BUILD_TESTS=OFF \
            -DSKIP_USDMAYA_TESTS=ON \
            ..
      make -j ${BUILD_PROCS} install
      ctest -V
    cd ..
#    rm -rf build
