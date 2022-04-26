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

FROM --platform=linux/amd64 ubuntu:20.04
COPY --from=builder /usr/local/lib/libmobi.so.0 /usr/local/lib/
COPY --from=builder /lib/x86_64-linux-gnu/libxml2.so.2 /lib/x86_64-linux-gnu/
COPY --from=builder /lib/x86_64-linux-gnu/libicuuc.so.66 /lib/x86_64-linux-gnu/
COPY --from=builder /lib/x86_64-linux-gnu/libicudata.so.66 /lib/x86_64-linux-gnu/
COPY --from=builder /libmobi/tools/.libs/mobidrm /
ENV LD_LIBRARY_PATH=/usr/local/lib
