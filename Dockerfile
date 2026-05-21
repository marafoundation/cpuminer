FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    automake libcurl4-openssl-dev libjansson-dev make gcc libtool && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /cpuminer
COPY . .

RUN ./autogen.sh && \
    ./configure CFLAGS="-O3" && \
    make

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4 libjansson4 dnsutils && \
    rm -rf /var/lib/apt/lists/*
COPY --from=builder /cpuminer/minerd /usr/local/bin/minerd
ENTRYPOINT ["minerd"]
