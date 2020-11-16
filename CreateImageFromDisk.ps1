
Param(
    [string]$SourceResourceGroupName,
    [string]$SourceDiskName,
    [string]$ResourceGroupName, 
    [string]$ImageName,
    [string]$OsType,
    [string]$Site = $env:AZURESITE
  )

$template = "templates\createimage.json"

$disk = Get-AzDisk -ResourceGroupName $SourceResourceGroupName -DiskName $SourceDiskName

Write-Host "Creating new image..."
New-AzResourceGroupDeployment -verbose -name $ResourceGroupName -resourcegroupname $ResourceGroupName -templatefile $template `
                              -imageName $ImageName `
                              -diskSizeGB $disk.DisksizeGB `
                              -diskId $disk.Id `
                              -osType $OsType `
                              -site $Site


