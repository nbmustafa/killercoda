#!/bin/bash

# Verify that the two deployments are running
if kubectl get pods -n falco-test | grep -q 'netcat-deployment'; then
  if kubectl get pods -n falco-test | grep -q 'aws-creds-deployment'; then
    exit 0
  fi
fi

exit 1