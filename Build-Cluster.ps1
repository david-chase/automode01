Write-Host ""
Write-Host ::: Build EKS Cluster v1 ::: -ForegroundColor Cyan
Write-Host ""

# Read in the config file
$oConfig = Get-Content -Path 'config.ini' | ConvertFrom-StringData

$sTags = '"Owner=' + $oConfig.owner + ",Purpose=" + $oConfig.purpose + ",CreateDate=" + ( Get-Date -format "yyyy.MM.dd" ) + '"'

$sCreateCluster = "create cluster --name=" + $oConfig.clustername + `
    " --region=" + $oConfig.region + `
    " --zones=" + $oConfig.region + "a," + $oConfig.region + "b"  + `
    " --tags " + $sTags + `
    " --version " + $oConfig.version + `
    " --write-kubeconfig --set-kubeconfig-context --enable-auto-mode --with-oidc"
$sEKSPodIdentity = "create addon --name eks-pod-identity-agent --cluster" + $oConfig.clustername + " --region " + $oConfig.region + " --force --version latest"
$sCoreDNS = "create addon --name coredns --cluster" + $oConfig.clustername + " --region " + $oConfig.region + " --force --version latest"
$sKubeProxy = "create addon --name kube-proxy --cluster " + $oConfig.clustername + " --region " + $oConfig.region + " --force --version latest"
$sVPCCNI = "create addon --name vpc-cni --cluster " + $oConfig.clustername + " --region " + $oConfig.region + " --force --version latest"
$sEBSCSI = "create addon --name aws-ebs-csi-driver --cluster " + $oConfig.clustername + " --region " + $oConfig.region + " --force --version latest"
$sEFSCSI = "create addon --name aws-efs-csi-driver --cluster " + $oConfig.clustername + " --region " + $oConfig.region + " --force --version latest"
$sPodIdentity = "utils migrate-to-pod-identity --cluster " + $oConfig.clustername + "  --approve"

# Show the user the command we're about to execute and let them choose to proceed
Write-Host "eksctl" $sCreateCluster`n -ForegroundColor Green
Write-Host "eksctl" $sEKSPodIdentity -ForegroundColor Green
Write-Host "eksctl" $sCoreDNS -ForegroundColor Green
Write-Host "eksctl" $sKubeProxy -ForegroundColor Green
Write-Host "eksctl" $sVPCCNI -ForegroundColor Green
# Install the EBS CSI driver only if specified in the config file
if( $oConfig.ebscsi.ToUpper() -eq "YES" ) {
    Write-Host "eksctl" $sEBSCSI -ForegroundColor Green
}
# Install the EFS CSI driver only if specified in the config file
if( $oConfig.efscsi.ToUpper() -eq "YES" ) {
    Write-Host "eksctl" $sEFSCSI -ForegroundColor Green
}
Write-Host "eksctl" $sPodIdentity -ForegroundColor Green

$sResponse = Read-Host -Prompt "Proceed? [Y/n]"
if( $sResponse.ToLower() -eq "n" ) { exit }

# Start a timer
$oStopWatch = New-Object -TypeName System.Diagnostics.Stopwatch
$oStopWatch.Start()

Start-Process "eksctl" -ArgumentList $sCreateCluster -Wait -NoNewWindow
Start-Process "eksctl" -ArgumentList $sEKSPodIdentity -Wait -NoNewWindow
Start-Process "eksctl" -ArgumentList $sCoreDNS -Wait -NoNewWindow
Start-Process "eksctl" -ArgumentList $sKubeProxy -Wait -NoNewWindow
Start-Process "eksctl" -ArgumentList $sVPCCNI -Wait -NoNewWindow
# Install the EBS CSI driver only if specified in the config file
if( $oConfig.ebscsi.ToUpper() -eq "YES" ) {
    Start-Process "eksctl" -ArgumentList $sEBSCSI -Wait -NoNewWindow
}
# Install the EFS CSI driver only if specified in the config file
if( $oConfig.efscsi.ToUpper() -eq "YES" ) {
    Start-Process "eksctl" -ArgumentList $sEFSCSI -Wait -NoNewWindow
}
Start-Process "eksctl" -ArgumentList $sPodIdentity -Wait -NoNewWindow

Write-Host

# Stop the timer
$oStopWatch.Stop()
Write-Host `nMinutes elapsed: $oStopWatch.Elapsed.Minutes -ForegroundColor Cyan

# This can take a long time, so make a sound so the user knows it's complete
[console]::beep(500,300)