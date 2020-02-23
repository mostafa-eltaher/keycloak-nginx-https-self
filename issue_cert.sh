#!/bin/bash 
set -e

cert_cn=$1
[ -z $cert_cn ] && cert_cn=cert

ca_cn=$2
[ -z $ca_cn ] && cert_cn=rootCA

cat << EOF > $cert_cn.cnf
[ req ]
prompt=no
distinguished_name  = req_distinguished_name
attributes          = req_attributes
req_extensions      = v3_req

[ req_distinguished_name ]
commonName = $cert_cn

[ req_attributes ]


[ v3_req ]
subjectAltName = @alt_names
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
[alt_names]
IP.1 = 10.0.2.2
EOF

openssl genrsa -out $cert_cn.key 2048
openssl req -config $cert_cn.cnf -new -key $cert_cn.key -out $cert_cn.csr
openssl x509 -req -in $cert_cn.csr -CA $ca_cn.crt -CAkey $ca_cn.key -CAcreateserial -out $cert_cn.crt -days 731 -sha256 -extensions v3_req -extfile $cert_cn.cnf
