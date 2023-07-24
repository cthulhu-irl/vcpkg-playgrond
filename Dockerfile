FROM ubuntu:22.04

ENV VCPKG_ROOT="/opt/vcpkg"
ENV VCPKG_DEFAULT_BINARY_CACHE="/opt/vcpkg-binary-cache"
ENV CC=gcc
ENV CXX=g++

RUN apt-get -qq update -y && \
    apt-get -qq install -y software-properties-common build-essential \
    curl zip unzip tar wget cmake pkg-config locales \
    git gcc-12 g++-12 openssl libssl-dev \
    uuid-dev zlib1g-dev libc-ares-dev ninja-build

RUN git clone --single-branch --depth=1 https://github.com/microsoft/vcpkg.git ${VCPKG_ROOT} && \
    ${VCPKG_ROOT}/bootstrap-vcpkg.sh && \
    ${VCPKG_ROOT}/vcpkg integrate install

RUN mkdir -p ${VCPKG_DEFAULT_BINARY_CACHE}

RUN ${VCPKG_ROOT}/vcpkg install protobuf:x64-linux --clean-after-build
RUN ${VCPKG_ROOT}/vcpkg install grpc:x64-linux --clean-after-build
RUN ${VCPKG_ROOT}/vcpkg install drogon[ctl,orm,redis]:x64-linux --clean-after-build
RUN ${VCPKG_ROOT}/vcpkg install boost:x64-linux --clean-after-build
