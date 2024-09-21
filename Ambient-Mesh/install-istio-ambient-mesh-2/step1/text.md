In Istio all outbound traffic from an istio-injected pod is redirected
automatically to its Istio sidecar proxy by default.


Therefore, the accessibility of external URLs outside the cluster depends on the configuration of the sidecar proxies.


By default, Istio proxy is configured to pass through requests for unknown services.


The Isto's `outboundTrafficPolicy` configuration option configures the way sidecar proxies handle communications
with external services, that is, those services that are or are not listed in the Istio’s
internal [service registry](https://istio.io/latest/docs/concepts/traffic-management/#introducing-istio-traffic-management).


If the `outboundTrafficPolicy` configuration option is set to **ALLOW_ANY**,
the Istio proxies let calls to unknown services pass through, whereas if the option
is set to **REGISTRY_ONLY**, Istio proxies will block any host not listed in the internal service registry.

Currently, Istio is configured with the `outboundTrafficPolicy` option is set
to **ALLOW_ANY**.


Test that you can successfully make a request to the *httpbin* external service by running:
```bash
kubectl exec tester -- \
    curl -sS -o /dev/null -D - http://httpbin.org/status/200 | \
    grep  "HTTP/";
```{{exec}}


Your task is to install Istio Ambient Mesh using helm
mode instead of **ALLOW_ANY** using `istioctl`:
```bash
istioctl install --set profile=demo \
    -y --manifests=/root/istio-${ISTIO_VERSION}/manifests \
    --set meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY
```{{exec}}

Install Istio Base Components
```bash
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update


helm install istio-base istio/base -n istio-system --create-namespace
```{{exec}}

Install the Istio Ambient Mesh
```bash
helm install istiod istio/istiod -n istio-system
```{{exec}}

Install Ambient Mesh components (Ztunnel and Waypoints)
``bash
helm install ambient istio/gateway -n istio-system --set values.ambient.enabled=true --set values.pilot.enabled=false
```{{exec}}

Wait a few seconds and then verify the installation:

``bash
kubectl get pods -n istio-system
```{{exec}}

