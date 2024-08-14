#!/bin/bash

DIR=ISO

if [ ! -d ${DIR} ]; then
    mkdir ${DIR}
fi

while read url; do
    wget $url
done < urls.txt

echo ""
# Verify the BLAKE2b checksums
b2sum -c b2sums.txt
# Verify signature
gpg --keyserver-options auto-key-retrieve --verify *.iso.sig *.iso
echo ""
# move to dir
mv *.iso ${DIR}
mv *.sig ${DIR}
mv b2sums.txt ${DIR}
mv sha256sums.txt ${DIR}

