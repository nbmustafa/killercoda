#!/bin/bash

source /tmp/check-utils.sh

check_output_contains "get pods -n istio-system -l istio.io/dataplane-mode=ambient" "istio.io/dataplane-mode=ambient"
