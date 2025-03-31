Write-Host ""
Write-Host ::: Install-Kube-Prometheus-Stack v1 ::: -ForegroundColor Cyan
Write-Host ""

Write-Host Adding Helm repo... -ForegroundColor Cyan
Write-Host "helm repo add prometheus-community https://prometheus-community.github.io/helm-charts" -ForegroundColor Green
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

Write-Host `nUpdating Helm repos... -ForegroundColor Cyan
Write-Host "helm repo update" -ForegroundColor Green
helm repo update

Write-Host `nInstalling Helm chart... -ForegroundColor Cyan
Write-Host 'helm install prometheus prometheus-community/kube-prometheus-stack `
    -n monitoring `
    --create-namespace `
    -f values.yaml' --ForegroundColor Green
    # --set alertmanager.persistentVolume.storageClass="default" `
    # --set server.persistentVolume.storageClass="default" `
helm install prometheus prometheus-community/kube-prometheus-stack `
    -n monitoring `
    --create-namespace `
    -f values.yaml
 #   --set alertmanager.persistentVolume.storageClass="default" `
 #   --set server.persistentVolume.storageClass="default" `
 #   --set alertmanager.persistentVolume.enabled=false `
 #   --set server.persistentVolume.enabled=false
