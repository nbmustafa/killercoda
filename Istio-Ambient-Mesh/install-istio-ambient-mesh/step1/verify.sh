#!/bin/bash

source /tmp/check-utils.sh

# check_path_value istiooperators installed-state istio-system '.spec.meshConfig.outboundTrafficPolicy.mode' 'REGISTRY_ONLY'
check_output_contains "kubectl get pods -n istio-system -l app=ztunnel" "ztunnel"
check_output_contains "kubectl get pods -n istio-system -l app=ztunnel" "waypoint"
check_output_contains "kubectl get pods -n istio-system -l app=ztunnel" "istiod"
check_output_contains "kubectl get daemonset ztunnel -n istio-system" "ztunnel"
