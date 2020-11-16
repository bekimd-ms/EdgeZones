
Param(
    [string]$sourceRGName,
    [string]$sourceDiskName,
    [string]$rgname, 
    [string]$imagename,
    [string]$ostype,
    [string]$site = $env:AZURESITE
  )

$template = "templates\createimage.json"

$disk = Get-AzDisk -ResourceGroupName $sourceRGName -DiskName $sourceDiskName

Write-Host "Creating new image..."
New-AzResourceGroupDeployment -verbose -name $rgname -resourcegroupname $rgname -templatefile $template `
                              -imageName $imageName `
                              -diskSizeGB $disk.DisksizeGB `
                              -diskId $disk.Id `
                              -osType $osType `
                              -site $site


