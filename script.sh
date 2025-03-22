#!/bin/bash

istioctl install --set profile=minimal -y
kubectl label namespace default istio-injection=enabled
cd kustomize/

kubectl apply -k .

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.25/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.25/samples/addons/kiali.yaml

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.25/samples/addons/grafana.yaml
