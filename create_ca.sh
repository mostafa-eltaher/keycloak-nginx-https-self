#!/bin/bash
set -e

ca_common_name=$1
[ -z $ca_common_name ] && ca_common_name=rootCA

cat << EOF > $ca_common_name.cnf
[ req ]
prompt=no
distinguished_name = req_distinguished_name
attributes         = req_attributes

[ req_distinguished_name ]
commonName = $ca_common_name

[ req_attributes ]
req_extensions     = v3_req

[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = critical,CA:TRUE, pathlen:0
keyUsage         = critical, cRLSign, digitalSignature, keyCertSign
EOF
openssl genrsa -out $ca_common_name.key 4096
openssl req -x509 -new -nodes -config $ca_common_name.cnf -extensions v3_req -key $ca_common_name.key -sha512 -days 1827 -out $ca_common_name.crt

