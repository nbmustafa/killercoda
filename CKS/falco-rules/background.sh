#!/bin/bash

# Set up Keys and Install Falco on node01
ssh -t node01 << EOF
  curl -fsSL https://falco.org/repo/falcosecurity-packages.asc | sudo gpg --dearmor -o /usr/share/keyrings/falco-archive-keyring.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/falco-archive-keyring.gpg] https://download.falco.org/packages/deb stable main" | sudo tee -a /etc/apt/sources.list.d/falcosecurity.list && \
  sudo apt-get update -y && \
  sudo apt install -y dkms make linux-headers-\$(uname -r) && \
  sudo apt-get install -y falco
EOF


# Install deployment 1 to compromise nc activities
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: zany-smile
  namespace: falco-test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: zany-smile
  template:
    metadata:
      labels:
        app: zany-smile
    spec:
      containers:
      - name: zany-smile
        image: alpine:3.14
        command: ["sh", "-c", "while true; do nc -e /bin/sh -l -p 1234; sleep 5; done"]
EOF


# Install deployment 2 to compromise AWS creds
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: monstrous-kraken
  namespace: falco-test
spec:
  replicas: 2
  selector:
    matchLabels:
      app: monstrous-kraken
  template:
    metadata:
      labels:
        app: monstrous-kraken
    spec:
      containers:
      - name: monstrous-kraken
        image: ubuntu
        command: ["sh", "-c", "cat .aws/credentials"]
EOF

# Install other deployments that run normally
kubectl create deployment starry-shadow -n falco-test --image alpine:3.14 --replicas 2 -- sleep 1d
kubectl create deployment firedrake-champion -n falco-test --image nginx --replicas 1 

sleep 5

touch /tmp/finished