Write-Host Deleting default nodepool -ForegroundColor Green
kubectl delete nodepool general-purpose
Write-Host Creating nodepool my-nodepool -ForegroundColor Green
kubectl apply -f my-nodepool.yaml