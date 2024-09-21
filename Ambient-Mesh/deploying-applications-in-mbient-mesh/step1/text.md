Configuring the Application to Join the Ambient Mesh

Annotate the namespace to enable Ambient Mesh:
```bash
kubectl label namespace default istio.io/dataplane-mode=ambient
```
