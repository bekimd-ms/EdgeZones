
Param(
    [string]$ResourceGroupName,
    [string]$VMSSName,
    [int]$InstanceCount=1,
    [string]$OSType, 
    [string]$UserName, 
    [string]$Password,
    [string]$site = $env:AZURESITE
  )

$template = "templates\createvmss.json"

if ( $OsType -eq 'linux' ) {
  $imagePublisher =  "Canonical"
  $imageOffer = "UbuntuServer"
  $imageSku = "18.04-LTS"
  $imageVersion = "18.04.202012010"
} 
else {
  $imagePublisher =  "MicrosoftWindowsServer"
  $imageOffer = "WindowsServer"
  $imageSku = "2016-Datacenter"
  $imageVersion = "14393.4048.2011170655"  
}

Write-Host "Creating new VM..."
New-AzResourceGroupDeployment -verbose -name $ResourceGroupName -resourcegroupname $ResourceGroupName -templatefile $template `
                              -vmssName $VMSSName `
                              -instanceCount $InstanceCount `
                              -imagePublisher $imagePublisher `
                              -imageOffer $imageOffer `
                              -imageSku $imageSku `
                              -imageVersion $imageVersion `
                              -adminUserName $UserName `
                              -adminPassword $Password `
                              -site $site


