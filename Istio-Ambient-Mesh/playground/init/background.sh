#!/bin/bash

# wait fo k8s ready
while ! kubectl get nodes | grep -w "Ready"; do
  echo "WAIT FOR NODES READY"
  sleep 1
done

# mark k8s finished
touch /ks/.k8sfinished

# Add the Istio Helm Repository
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

# Install Istio Base Components
helm install istio-base istio/base -n istio-system --create-namespace --wait

# Install or upgrade the Kubernetes Gateway API CRDs
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  { kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml; }

# Isntall Istiod control plane in ambient mode
helm install istiod istio/istiod --namespace istio-system --set profile=ambient --wait

# Install CNI node agent
helm install istio-cni istio/cni -n istio-system --set profile=ambient --wait

# Install Ztunnel
helm install ztunnel istio/ztunnel -n istio-system --wait

# istio Ingress Gateway
helm install istio-ingress istio/gateway -n istio-ingress --create-namespace --wait

# Verify Installation
kubectl get pods -n istio-system


touch /ks/.istiofinished

# Init scenario

# allow pods to run on controlplane
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-

# Install Sample Application
kubectl label namespace default istio.io/dataplane-mode=ambient

kubectl run tester --image=nginx
while ! kubectl get pods | grep -w "Running"; do echo -n "."; sleep 1; done

# mark init finished
touch /ks/.initfinished
