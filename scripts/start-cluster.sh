#!/usr/bin/env bash

set -euo pipefail

echo "Starting Minikube..."
minikube start

echo
echo "Current Kubernetes context:"
kubectl config current-context

echo
echo "Cluster:"
kubectl get nodes

echo
echo "Argo CD:"
kubectl get pods -n argocd
