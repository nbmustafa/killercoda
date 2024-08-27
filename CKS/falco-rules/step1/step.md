# Step 1: Deploy Applications That Trigger Falco Rules

Deploy two separate applications in the `falco-test` namespace. These applications will trigger specific Falco rules related to potential security issues.

<details>
  <summary>Solution</summary>

1. **Create the First Deployment (netcat)**:
   Create a deployment manifest for an application that runs `nc` (netcat) with a command that triggers the `Netcat Remote Code Execution in Container` rule.

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: netcat-deployment
      namespace: falco-test
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: netcat-app
      template:
        metadata:
          labels:
            app: netcat-app
        spec:
          containers:
          - name: netcat-container
            image: alpine:3.14
            command: ["sh", "-c", "while true; do nc -e /bin/sh -l -p 1234; sleep 5; done"]
    ```

2. **Create the Second Deployment (AWS Credential Search)**:
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: aws-creds-deployment
      namespace: falco-test
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: aws-creds-app
      template:
        metadata:
          labels:
            app: aws-creds-app
        spec:
          containers:
          - name: aws-creds-container
            image: alpine:3.14
            command: ["sh", "-c", "find /root -name .aws/credentials"]
    ```

3. **Apply the deployment**:
  ```bash
  kubectl apply -f netcat-deployment.yaml
  kubectl apply -f aws-creds-deployment.yaml
  ```

4. **Verify the deployment**: `kubectl get pods -n falco-test`

</details>
