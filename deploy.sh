#!/usr/bin/env bash
set -euo pipefail

NS="logging-hw"

echo "[1/9] Applying namespace"
kubectl apply -f k8s/namespace.yaml

echo "[2/9] Applying ConfigMap"
kubectl apply -f k8s/configmap.yaml

echo "[3/9] Applying initial test Pod"
kubectl apply -f k8s/pod.yaml
kubectl wait --for=condition=Ready pod/custom-app-pod-test -n "$NS" --timeout=180s

echo "[4/9] Applying Deployment"
kubectl apply -f k8s/deployment.yaml
kubectl rollout status deployment/custom-app -n "$NS" --timeout=180s

echo "[5/9] Applying Service"
kubectl apply -f k8s/service.yaml

echo "[6/9] Applying DaemonSet"
kubectl apply -f k8s/daemonset.yaml
kubectl rollout status daemonset/log-agent -n "$NS" --timeout=180s || true

echo "[7/9] Applying StatefulSet"
kubectl apply -f k8s/statefulset.yaml
kubectl rollout status statefulset/backup-store -n "$NS" --timeout=180s || true

echo "[8/9] Applying RBAC for CronJob"
kubectl apply -f k8s/rbac-log-archiver.yaml

echo "[9/9] Applying CronJob"
kubectl apply -f k8s/cronjob.yaml

echo
echo "===== CURRENT OBJECTS ====="
kubectl get all -n "$NS"

echo
echo "Deployment finished."
echo "To test the service:"
echo "kubectl port-forward -n $NS svc/custom-app-service 8080:80"