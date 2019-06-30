FROM alpine:3.9 AS build-stage

ENV DIR_PREFIX /usr/local
ENV SRC_DIR $DIR_PREFIX/src
ENV BIN_DIR $DIR_PREFIX/bin

RUN apk --no-cache add git bash make automake autoconf pkgconfig gcc musl-dev libcaca-dev \
    && git clone https://github.com/cacalabs/toilet $SRC_DIR/toilet \
    && cd $SRC_DIR/toilet \
    && ./bootstrap \
    && ./configure \
    && make \
    && install -m 0755 ./src/toilet $BIN_DIR \
    && mkdir /usr/local/share/figlet/ \
    && install -m 0644 ./fonts/*.tlf /usr/local/share/figlet/

FROM alpine:3.9 AS exec-stage
RUN apk add libcaca-dev
COPY --from=build-stage /usr/local/bin/* /usr/local/bin/
COPY --from=build-stage /usr/local/src/toilet/fonts/* /usr/local/share/figlet/

ENTRYPOINT ["toilet"]
