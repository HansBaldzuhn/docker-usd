# Set environment variable to use USD binaries and libraries
# Add to ~/.bashrc for application started from a shell
# Copy to a usd.sh file in /etc/profile.d/ for system wide usage

export USD_VERSION="18.11"
export MAYA_VERSION="2019"
export AL_USD_VERSION="0.29.4"


# ROOT USD

export USD_INSTALL_DIR=${HOME}/USD/install/al-${AL_USD_VERSION}-${USD_VERSION}

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${USD_INSTALL_DIR}/usd/lib:${USD_INSTALL_DIR}/lib:${USD_INSTALL_DIR}/extra/lib
export PATH=${PATH}:${USD_INSTALL_DIR}/usd/bin
export PYTHONPATH=${PYTHONPATH}:${USD_INSTALL_DIR}/usd/lib/python:${USD_INSTALL_DIR}/extra/lib/python:${USD_INSTALL_DIR}/lib/python/site-packages:${USD_INSTALL_DIR}/lib/python2.7/site-packages

# PIXAR USD
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${USD_INSTALL_DIR}/usd/maya/lib
export MAYA_PLUG_IN_PATH=${MAYA_PLUG_IN_PATH}:${USD_INSTALL_DIR}/usd/maya/plugin
export MAYA_SCRIPT_PATH=${MAYA_SCRIPT_PATH}:${USD_INSTALL_DIR}/usd/maya/lib/usd/usdMaya/resources
export XBMLANGPATH=${XBMLANGPATH}:${USD_INSTALL_DIR}/usd/maya/lib/usd/usdMaya/resources

# AL USD
export AL_USD_ROOT=${USD_INSTALL_DIR}/AL_USDMaya_${AL_USD_VERSION}_${MAYA_VERSION}
export MAYA_PLUG_IN_PATH=${MAYA_PLUG_IN_PATH}:${AL_USD_ROOT}/plugin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${AL_USD_ROOT}/lib
export PYTHONPATH=${PYTHONPATH}:${AL_USD_ROOT}/lib/python

export MAYA_VP2_DEVICE_OVERRIDE=VirtualDeviceGL 