#!/bin/bash
#export KUBECONFIG=$HOME/.kube/config.yaml

NAMESPACE="msa-sample"

echo "[$(date)] Checking pod status in namespace '$NAMESPACE'..."
echo "------------------------------------------------------------"

# Status all pod 
kubectl get pods -n $NAMESPACE -o custom-columns=\
"NAME:.metadata.name,\
READY:.status.containerStatuses[*].ready,\
STATUS:.status.phase,\
RESTARTS:.status.containerStatuses[*].restartCount,\
AGE:.metadata.creationTimestamp" | \
awk 'NR==1 {print $0; next} {print $0 | "sort -k3"}' | column -t

echo "------------------------------------------------------------"

# Summary
echo -e "\nPod status summary:"
kubectl get pods -n $NAMESPACE --no-headers | awk '{print $3}' | sort | uniq -c | while read count status; do
  echo "  $status : $count"
done

echo -e "\nCompleted pod health check."
