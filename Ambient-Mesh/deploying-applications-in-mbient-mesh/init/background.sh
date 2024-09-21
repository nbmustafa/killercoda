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
helm install istio-base istio/base -n istio-system --create-namespace

# Install the Istio Ambient Mesh
helm install istiod istio/istiod -n istio-system

# Install Ambient Mesh components (Ztunnel and Waypoints)
helm install ambient istio/gateway -n istio-system --set values.ambient.enabled=true --set values.pilot.enabled=false

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
