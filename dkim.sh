#!/bin/sh

# ARGUMENTS
KEY_NAME=$1
DOMAIN=$2

# Generate public key
openssl genrsa -out $DOMAIN.priv 1024
openssl rsa -in $DOMAIN.priv -out $DOMAIN.pub -pubout -outform PEM

# One line the public key
PUB_KEY=`tr -d '\n' < $DOMAIN.pub | sed "s/^-----BEGIN PUBLIC KEY-----//" | sed "s/-----END PUBLIC KEY-----$//"`

# Display server properties
PRIV_KEY=`cat $DOMAIN.priv | sed 's/^/    \"/' | sed 's/$/\"/'`
echo "\n====\nServer Properties\n===="
echo "DKIM_PRIVATE_KEY = (\n$PRIV_KEY
)"


echo "DKIM_DOMAIN = \"$DOMAIN\""
echo "DKIM_SELECTOR = \"$KEY_NAME\""

# Display DNS details
echo "\n====\nDomain Information\n===="
echo "TXT Hostname: $KEY_NAME._domainkey.$DOMAIN"
echo "TXT Content: v=DKIM1;t=s;n=core;p=$PUB_KEY"
