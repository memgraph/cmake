#!/bin/bash
pushd () { command pushd "$@" > /dev/null; }
popd () { command popd "$@" > /dev/null; }
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CPUS=$( grep -c processor < /proc/cpuinfo )
PREFIX="$DIR/output"
ARCHIVES="$DIR/archives"
BUILD="$DIR/build"
COMMON_CONFIGURE_FLAGS="--enable-shared=no --prefix=$PREFIX"
GPG="gpg --homedir .gnupg"
KEYSERVER="hkp://keyserver.ubuntu.com"
mkdir -p "$ARCHIVES"
mkdir -p "$BUILD"
function log_tool_name () {
    echo ""
    echo ""
    echo "#### $1 ####"
    echo ""
    echo ""
}

FLEX_VERSION=2.6.4
pushd "$ARCHIVES"
if [ ! -f flex-$FLEX_VERSION.tar.gz ]; then
    wget https://github.com/westes/flex/releases/download/v$FLEX_VERSION/flex-$FLEX_VERSION.tar.gz -O flex-$FLEX_VERSION.tar.gz
fi
if [ ! -f flex-$FLEX_VERSION.tar.gz.sig ]; then
    wget https://github.com/westes/flex/releases/download/v$FLEX_VERSION/flex-$FLEX_VERSION.tar.gz.sig
fi
if false; then
    $GPG --keyserver $KEYSERVER --recv-keys 0xE4B29C8D64885307
    $GPG --verify flex-$FLEX_VERSION.tar.gz.sig flex-$FLEX_VERSION.tar.gz
fi
popd
pushd "$BUILD"
log_tool_name "flex $FLEX_VERSION"
if [ ! -f "$PREFIX/include/FlexLexer.h" ]; then
    if [ -d flex-$FLEX_VERSION ]; then
        rm -rf flex-$FLEX_VERSION
    fi
    tar -xzf "$ARCHIVES/flex-$FLEX_VERSION.tar.gz"
    pushd flex-$FLEX_VERSION
    ./configure $COMMON_CONFIGURE_FLAGS
    make -j$CPUS install
    popd
fi
popd
