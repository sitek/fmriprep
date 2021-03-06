#!/bin/bash

MNI_TEMPLATE="https://files.osf.io/v1/resources/fvuh8/providers/osfstorage/57f32a799ad5a101f977eb77"
MNI_SHA256="c7b7ca347c4bb8b7956d1d10515702f0b5e3a8c630e446a1c980e9bf6a549100"
ASYM_09C_TEMPLATE="https://files.osf.io/v1/resources/fvuh8/providers/osfstorage/580705089ad5a101f17944a9"
ASYM_09C_SHA256="a24699ba0d13f72d0f8934cc211cb80bfd9c9a077b481d9b64295cf5275235a9"
OASIS_TEMPLATE="https://files.osf.io/v1/resources/fvuh8/providers/osfstorage/584123a29ad5a1020913609d"
OASIS_SHA256="d87300e91346c16f55baf6f54f5f990bc020b61e8d5df9bcc3abb0cc4b943113"
NKI_TEMPLATE="https://files.osf.io/v1/resources/fvuh8/providers/osfstorage/59cd90f46c613b02b3d79782"
NKI_SHA256="4bba067f6675d15be96b205cb227e18a540673fd7e4577e13feedcef3a6f0ec5"

GET(){
    URL=$1; SHA256=$2;
    mkfifo pipe.tar.gz
    cat pipe.tar.gz | tar zxv -C $CRN_SHARED_DATA &
    SHASUM=$(curl -sSL $URL | tee pipe.tar.gz | sha256sum | cut -d\  -f 1)
    rm pipe.tar.gz

    if [[ "$SHASUM" != "$SHA256" ]]; then
        echo "Failed checksum!"
        return 1
    fi
    return 0
}

set -e
echo "Getting MNI template"
GET "$MNI_TEMPLATE" "$MNI_SHA256"
echo "Getting MNI152NLin2009cAsym template"
GET "$ASYM_09C_TEMPLATE" "$ASYM_09C_SHA256"
echo "Getting OASIS template"
GET "$OASIS_TEMPLATE" "$OASIS_SHA256"
echo "Getting NKI template"
GET "$NKI_TEMPLATE" "$NKI_SHA256"
echo "Done!"
