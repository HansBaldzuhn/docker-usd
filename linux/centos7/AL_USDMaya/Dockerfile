############################################################
# Dockerfile that builds and runs dependant docker files

ARG usd_version
ARG maya_version
FROM usd-docker/maya${maya_version}-usd:${usd_version}-centos7

ARG usd_version
ARG maya_version
ARG build_proc
ARG al_usd_version
RUN echo

ENV BUILD_PROCS=${build_proc}
ENV AL_USD_VERSION=${al_usd_version}
ENV MAYA_VERSION=${maya_version}

MAINTAINER Animal Logic

# using Devtoolset-6 (easy C++ setup)
#RUN yum install -y centos-release-scl
#RUN yum install -y devtoolset-6
# scl enable devtoolset-6 bash
#SHELL [ "/usr/bin/scl", "enable", "devtoolset-6" ]

COPY bin/maya ${MAYA_LOCATION}/bin/
COPY bin/mayapy ${MAYA_LOCATION}/bin/

COPY scripts/download_AL_USDMaya.sh scripts/build_AL_USDMaya.sh /tmp/
RUN /tmp/download_AL_USDMaya.sh

RUN /tmp/build_AL_USDMaya.sh