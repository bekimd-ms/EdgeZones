
Param(
    [string]$rgname,
    [string]$vmName,
    [string]$imagergname, 
    [string]$imagename,
    [string]$username, 
    [string]$password,
    [string]$site = $env:AZURESITE
  )

$template = "templates\createvm.json"
$image = Get-AzImage -ResourceGroupName $imagergname -ImageName $imagename

Write-Host "Creating new VM..."
New-AzResourceGroupDeployment -verbose -name $rgname -resourcegroupname $rgname -templatefile $template `
                              -vmName $vmName `
                              -imageId $image.Id `
                              -adminUserName $username `
                              -adminPassword $password `
                              -dnsLabelPrefix $vmName `
                              -site $site


