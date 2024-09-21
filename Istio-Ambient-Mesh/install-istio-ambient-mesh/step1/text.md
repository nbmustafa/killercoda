To install Istio Ambient Mesh using Helm, you need to follow these general steps. It includes setting up Helm, adding the Istio Helm repository, and configuring the Ambient Mesh installation:

adding the Istio Helm repository
```bash
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
```{{exec}}

Install Istio Base Components
```bash
helm install istio-base istio/base -n istio-system --create-namespace
```{{exec}}

Install the Istio Ambient Mesh
```bash
helm install istiod istio/istiod -n istio-system
```{{exec}}

Install Ambient Mesh components (Ztunnel and Waypoints)
```bash
helm install ambient istio/gateway -n istio-system --set values.ambient.enabled=true --set values.pilot.enabled=false
```{{exec}}

Wait a few seconds and then verify the installation:
```bash
kubectl get pods -n istio-system
```{{exec}}


Check if Ztunnel and Waypoints are Running
```bash
kubectl get pods -n istio-system -l app=ztunnel
kubectl get pods -n istio-system -l app=waypoint
```{{exec}}

Verify that the Istio control plane is functioning correctly. For example, ensure that istiod is not managing sidecars, and ambient mode is enabled:
```bash
kubectl get istiooperators.install.istio.io -n istio-system
```{{exec}}

Since Ztunnel typically runs as a DaemonSet, you can check the DaemonSet status using:
```bash
kubectl get daemonset ztunnel -n istio-system
```{{exec}}

