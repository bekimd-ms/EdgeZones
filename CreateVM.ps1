
Param(
    [string]$ResourceGroupName,
    [string]$VMName,
    [string]$VMSize = "Standard_D2s_v3",
    [string]$OSType, 
    [string]$AdminUserName, 
    [string]$AdminSecret, 
    [string]$site = $env:AZURESITE
  )

$templateFile = "templates\createvm.json"

$template = get-content ($templateFile) -raw | ConvertFrom-Json -Depth 32

if ( $OsType -eq 'linux' ) {
  $imagePublisher =  "Canonical"
  $imageOffer = "UbuntuServer"
  $imageSku = "18.04-LTS"
  $imageVersion = "latest"
  $adminSecretData = Get-Content -Path $Secret
  $template.resources[4].properties.osProfile.PSObject.properties.remove('adminPassword')
} 
else {
  $imagePublisher =  "MicrosoftWindowsServer"
  $imageOffer = "WindowsServer"
  $imageSku = "2016-Datacenter"
  $imageVersion = "latest"  
  $adminSecretData = $AdminSecret
  $template.resources[4].properties.osProfile.PSObject.properties.remove('linuxConfiguration')
}

$templateFile = ".\temp.json"
$template | ConvertTo-Json -depth 32 | set-content ( $templateFile )

Write-Host "Creating new VM..."

New-AzResourceGroupDeployment -verbose -name $ResourceGroupName -resourcegroupname $ResourceGroupName -templatefile $templateFile `
                              -vmName $VMName `
                              -imagePublisher $imagePublisher `
                              -imageOffer $imageOffer `
                              -imageSku $imageSku `
                              -imageVersion $imageVersion `
                              -dnsLabelPrefix $VMName `
                              -adminUserName $AdminUserName `
                              -adminSecret  $adminSecretData `
                              -site $site


