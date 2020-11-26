
Param(
    [string]$ResourceGroupName,
    [string]$VMSSName,
    [int]$InstanceCount=1,
    [string]$ImageResourceGroupName, 
    [string]$ImageName,
    [string]$UserName, 
    [string]$Password,
    [string]$site = $env:AZURESITE
  )

$template = "templates\createvmss.json"
$image = Get-AzImage -ResourceGroupName $ImageResourceGroupName -ImageName $ImageName

Write-Host "Creating new VM..."
New-AzResourceGroupDeployment -verbose -name $ResourceGroupName -resourcegroupname $ResourceGroupName -templatefile $template `
                              -vmssName $VMSSName `
                              -instanceCount $InstanceCount `
                              -imageId $image.Id `
                              -adminUserName $UserName `
                              -adminPassword $Password `
                              -site $site


