#!/usr/bin/env bash

set -euo pipefail

echo "=== MINIKUBE ==="
minikube status

echo
echo "=== NODES ==="
kubectl get nodes -o wide

echo
echo "=== ARGO CD ==="
kubectl get pods -n argocd

echo
echo "=== APPLICATIONS ==="
kubectl get applications -n argocd 2>/dev/null || true
