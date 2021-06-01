
Param(
    [string]$ResourceGroupName,
    [string]$VMName,
    [string]$OSType, 
    [string]$AdminUserName, 
    [string]$KeyFile, 
    [string]$site = $env:AZURESITE
  )

$template = "templates\createvm.json"

if ( $OsType -eq 'linux' ) {
  $imagePublisher =  "Canonical"
  $imageOffer = "UbuntuServer"
  $imageSku = "18.04-LTS"
  $imageVersion = "latest"
} 
else {
  $imagePublisher =  "MicrosoftWindowsServer"
  $imageOffer = "WindowsServer"
  $imageSku = "2016-Datacenter"
  $imageVersion = "latest"  
}

$keyValue = Get-Content -Path $KeyFile

Write-Host "Creating new VM..."

New-AzResourceGroupDeployment -verbose -name $ResourceGroupName -resourcegroupname $ResourceGroupName -templatefile $template `
                              -vmName $VMName `
                              -imagePublisher $imagePublisher `
                              -imageOffer $imageOffer `
                              -imageSku $imageSku `
                              -imageVersion $imageVersion `
                              -dnsLabelPrefix $VMName `
                              -adminUserName $AdminUserName `
                              -adminPublicKey $keyValue `
                              -site $site


