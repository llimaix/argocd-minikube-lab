#!/usr/bin/env bash

set -euo pipefail

PID_FILE="/tmp/argocd-port-forward.pid"

echo "Stopping Argo CD port-forward..."

if [[ -f "$PID_FILE" ]]; then
    PID="$(cat "$PID_FILE")"

    if kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
    fi

    rm -f "$PID_FILE"
fi

echo "Stopping Minikube..."

minikube stop