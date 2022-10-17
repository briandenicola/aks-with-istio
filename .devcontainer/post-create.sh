#!/bin/bash

# this runs at Codespace creation - not part of pre-build

echo "$(date)    post-create start" >> ~/status

#Install Flux
VERSION=`curl --silent "https://api.github.com/repos/fluxcd/flux2/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'`
curl -Ls "https://github.com/fluxcd/flux2/releases/download/v${VERSION}/flux_${VERSION}_linux_amd64.tar.gz" -o /tmp/flux2.tar.gz
tar -xf /tmp/flux2.tar.gz -C /tmp
sudo mv /tmp/flux /usr/local/bin
rm -f /tmp/flux2.tar.gz

#Install aks kube tools
sudo az aks install-cli

echo "$(date)    post-create complete" >> ~/status
