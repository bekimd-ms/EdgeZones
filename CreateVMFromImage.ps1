
Param(
    [string]$ResourceGroupName,
    [string]$VMName,
    [string]$ImageResourceGroupName, 
    [string]$ImageName,
    [string]$UserName, 
    [string]$Password,
    [string]$site = $env:AZURESITE
  )

$template = "templates\createvm.json"
$image = Get-AzImage -ResourceGroupName $ImageResourceGroupName -ImageName $ImageName

Write-Host "Creating new VM..."
New-AzResourceGroupDeployment -verbose -name $ResourceGroupName -resourcegroupname $ResourceGroupName -templatefile $template `
                              -vmName $VMName `
                              -imageId $image.Id `
                              -adminUserName $UserName `
                              -adminPassword $Password `
                              -dnsLabelPrefix $VMName `
                              -site $site


