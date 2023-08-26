#!/bin/bash
# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

wget https://get.helm.sh/helm-v${helm_version}-linux-amd64.tar.gz
tar -zxvf helm-v${helm_version}-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
rm -f helm-v${helm_version}-linux-amd64.tar.gz
rm -rf linux-amd64
chmod 500 ~/.kube/config
helm repo add stable https://charts.helm.sh/stable

if [ ${add_incubator_repo} ]; then
  helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
fi

if [ ${add_jetstack_repo} ]; then
  helm repo add jetstack https://charts.jetstack.io
fi

helm repo update

echo "source <(helm completion bash)" >> ~/.bashrc
echo "alias h='helm'" >> ~/.bashrc

sleep 500s
#while [[ $(kubectl -n kube-system get pods -l app=helm,name=tiller -o ‘jsonpath={..status.conditions[?(@.type==“Ready”)].status}’) != “True” ]]; do echo “waiting for tiller pod to be up” && sleep 1; done
