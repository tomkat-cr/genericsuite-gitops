#!/bin/bash
# File: k8/k8_start_minikube.sh
# 2022-02-25 | CR
echo ""
echo "Running: service docker start"
service docker start
echo ""
echo "To access from outside the server (insecure, without filter)"
echo "Running: kubectl proxy --address='0.0.0.0' --disable-filter=true &"
kubectl proxy --address='0.0.0.0' --disable-filter=true &
echo ""
echo "Starting Minikube"
echo "Running: minikube start &"
minikube start &
echo "To enable the K8 Dashboard"
echo ""
echo "Running: minikube dashboard &"
minikube dashboard &
echo ""
echo "To enable the K8 Service"
echo "Running: minikube tunnel &"
minikube tunnel &
