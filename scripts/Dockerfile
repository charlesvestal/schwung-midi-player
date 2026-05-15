# Uses Debian bullseye for GCC 10 / GLIBCXX compatibility with Move device
FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    gcc-aarch64-linux-gnu \
    make \
    && rm -rf /var/lib/apt/lists/*

ENV CROSS_PREFIX=aarch64-linux-gnu-

WORKDIR /build
