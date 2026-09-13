#!/usr/bin/env bash

set -euo pipefail

echo "======================================"
echo " Starting Argo CD Minikube Lab"
echo "======================================"

echo
echo "[1/5] Starting Minikube..."

minikube start \
  --driver=docker \
  --cpus=4 \
  --memory=7g \
  --disk-size=30g

echo
echo "[2/5] Validating Kubernetes..."

CURRENT_CONTEXT="$(kubectl config current-context)"

if [[ "$CURRENT_CONTEXT" != "minikube" ]]; then
    echo "ERROR: Current Kubernetes context is '$CURRENT_CONTEXT'."
    echo "Expected: minikube"
    exit 1
fi

kubectl get nodes

echo
echo "[3/5] Checking Argo CD..."

if ! kubectl get deployment argocd-server \
     -n argocd >/dev/null 2>&1; then

    echo "Argo CD installation not detected."
    echo "Bootstrapping Argo CD..."

    kubectl apply \
      --server-side \
      --force-conflicts \
      -k bootstrap/argocd/

else

    echo "Argo CD already installed."

fi

echo
echo "[4/5] Waiting for Argo CD pods..."

kubectl wait \
  --for=condition=Ready \
  pod \
  --all \
  -n argocd \
  --timeout=300s

echo
echo "[5/5] Environment status"

echo
echo "=== MINIKUBE ==="
minikube status

echo
echo "=== KUBERNETES ==="
kubectl get nodes -o wide

echo
echo "=== ARGO CD ==="
kubectl get pods -n argocd

echo
echo "=== ARGO CD APPLICATIONS ==="
kubectl get applications.argoproj.io \
  -n argocd 2>/dev/null || true

echo
echo "[6/6] Starting Argo CD port-forward..."

PID_FILE="/tmp/argocd-port-forward.pid"
LOG_FILE="/tmp/argocd-port-forward.log"

if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo "Argo CD port-forward already running."
else
    nohup kubectl port-forward \
      -n argocd \
      svc/argocd-server \
      8080:443 \
      >"$LOG_FILE" 2>&1 &

    echo $! > "$PID_FILE"

    sleep 2

    if kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo "Argo CD available at:"
        echo "https://localhost:8080"
    else
        echo "ERROR: Argo CD port-forward failed."
        cat "$LOG_FILE"
        exit 1
    fi
fi

echo
echo "======================================"
echo " Lab Ready"
echo "======================================"
