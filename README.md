# Sphinx port

## Prerequisites

Install in the following order

1. [zlib](https://github.com/zerovm/zerovm-ports/blob/master/zlib/README.md)
2. [bzip2](https://github.com/zerovm/zerovm-ports/blob/master/bzip2/README.md)
3. [libexpat](https://github.com/zerovm/zerovm-ports/blob/master/libexpat/README.md)
4. [pcre](https://github.com/zerovm/zerovm-ports/blob/master/pcre-8.33/README.md)
5. [iconv](https://github.com/zerovm/zerovm-ports/blob/master/libiconv/README.md)

## Building sphinx-port

    ./configureall.sh; make
    cd zxpdf-3.03; make
    cd ../docxextract; make
    cd ../antiword-0.37; make
    cd ../hypermail; ./configure --host=x86_64-nacl --disable-i18n; make
    cd ../catdoc-0.94.4; make
    cd ../zsphinx/src; make


## Usage

    ./indexingandsearch.sh {~/search path}

# Run sphinx search on zwift

[README](https://github.com/zerovm/sphinx-port/blob/master/zsphinx/zwift/README.md)

