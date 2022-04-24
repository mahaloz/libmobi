# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang 

## Add source code to the build stage.
ADD . /libmobi
WORKDIR /libmobi

RUN apt -y install autoconf libtool libxml2-dev zlib1g-dev
RUN ./autogen.sh
RUN CC=clang CXX=clang++ ./configure
RUN make -j3
RUN make install

ENV LD_LIBRARY_PATH=/usr/local/lib
RUN cp /libmobi/tools/.libs/mobidrm /fuzz
#RUN ln -s /libmobi/tools/mobidrm /fuzz
WORKDIR /
