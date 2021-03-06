FROM arm32v6/golang:1.12-alpine
RUN apk update && \
    apk add make && \
    apk add bash && \
    apk add git && \
    apk add python3 && \
    apk add boost-dev && \
    apk add expect && \
    apk add jq && \
    apk add autoconf && \
    apk add --update alpine-sdk && \
    apk add libtool && \
    apk add automake && \
    apk add fmt && \
    apk add build-base && \
    apk add musl-dev && \
    apk add sqlite

RUN apk add dpkg && \
    wget http://deb.debian.org/debian/pool/main/s/shellcheck/shellcheck_0.5.0-3_armhf.deb && \
    dpkg-deb -R shellcheck_0.5.0-3_armhf.deb shellcheck && \
    cd shellcheck && \
    mv usr/bin/shellcheck /usr/bin/
COPY . $GOPATH/src/github.com/algorand/go-algorand
WORKDIR $GOPATH/src/github.com/algorand/go-algorand
ENV GCC_CONFIG="--with-arch=armv6" \
    GOPROXY=https://gocenter.io,https://goproxy.io,direct
RUN make ci-deps && make clean
RUN rm -rf $GOPATH/src/github.com/algorand/go-algorand && \
    mkdir -p $GOPATH/src/github.com/algorand/go-algorand
CMD ["/bin/bash"]
