To install Istio Ambient Mesh using Helm, you need to follow these general steps. It includes setting up Helm, adding the Istio Helm repository, and configuring the Ambient Mesh installation:

adding the Istio Helm repository
```bash
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
```{{exec}}

Install Istio Base Components
```bash
helm install istio-base istio/base -n istio-system --create-namespace --wait
```{{exec}}

Install or upgrade the Kubernetes Gateway API CRDs
```bash
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  { kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml; }
```{{exec}}

Isntall Istiod control plane in ambient mode
```bash
helm install istiod istio/istiod --namespace istio-system --set profile=ambient --wait
```{{exec}}

Install CNI node agent
```bash
helm install istio-cni istio/cni -n istio-system --set profile=ambient --wait
```{{exec}}

Install the data plane
Install Ambient Mesh components - ztunnel DaemonSet: 
```bash
helm install ztunnel istio/ztunnel -n istio-system --wait
```{{exec}}


Ingress gateway (optional)
```bash
helm install istio-ingress istio/gateway -n istio-ingress --create-namespace --wait
```{{exec}}



Wait a few seconds and then verify the installation:
```bash
kubectl get pods -n istio-system
```{{exec}}


Check if istio components are Running
```bash
kubectl get pods -n istio-system -l app=ztunnel
kubectl get pods -n istio-system -l app=istiod
kubectl get pods -n istio-system -l app=istio-cni
```{{exec}}

Verify that the Istio control plane is functioning correctly. For example, ensure that istiod is not managing sidecars, and ambient mode is enabled:
```bash
kubectl get istiooperators.install.istio.io -n istio-system
```{{exec}}

Since Ztunnel typically runs as a DaemonSet, you can check the DaemonSet status using:
```bash
kubectl get daemonset ztunnel -n istio-system
```{{exec}}

