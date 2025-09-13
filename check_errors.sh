#!/bin/bash
#export KUBECONFIG=$HOME/.kube/config.yaml

# Script to check pod status and scan for specific error keywords in logs within the robot-shop namespace

NAMESPACE=msa-sample

echo "Checking pods status in namespace '$NAMESPACE'..."
kubectl get pods -n $NAMESPACE --no-headers

echo -e "\nChecking for 'NoneType' errors or 'Erroneous calls' in pod logs..."

LOG_KEYWORDS=("NoneType" "Erroneous")

for pod in $(kubectl get pods -n $NAMESPACE --no-headers | awk '{print $1}'); do
  echo -e "\n== Logs from pod: $pod =="
  for keyword in "${LOG_KEYWORDS[@]}"; do
    echo "-- Searching for keyword: $keyword"
    kubectl logs $pod -n $NAMESPACE --tail=50 | grep -i $keyword && echo "[!] Keyword '$keyword' found in $pod logs"
  done
  echo "-- Finished searching in $pod logs"
done

echo -e "\nPod status summary:"
kubectl get pods -n $NAMESPACE --no-headers | awk '{print $3}' | sort | uniq -c
