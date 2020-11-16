
Param(
    [string]$sourceRGName,
    [string]$sourceDiskName, 
    [string]$rgname,
    [string]$diskname,
    [string]$site = $env:AZURESITE
  )

$template = "templates\createdisk.json"
$sasDuration = 3600

Remove-AzDisk -ResourceGroupName $rgname -DiskName $diskname -Force
$disk = Get-AzDisk -ResourceGroupName $sourceRGName -DiskName $sourceDiskName

Write-Host "Creating new disk..."
New-AzResourceGroupDeployment -verbose -name $rgname -resourcegroupname $rgname -templatefile $template `
                              -diskName $diskName `
                              -diskUploadSize ($disk.DisksizeBytes + 512) `
                              -site $site


Write-Host "Grant SAS access..." 

$sourceSAS = Grant-AzDiskAccess -ResourceGroupName $sourceRGName -DiskName $sourceDiskName -DurationInSecond $sasDuration -Access Read
$destSAS = Grant-AzDiskAccess -ResourceGroupName $rgname -DiskName $diskName -DurationInSecond $sasDuration -Access Write

Start-Sleep -Seconds 60  

Write-Host "Copying disk bytes..." 

Write-Host "Source: " $sourceSAS.AccessSAS
Write-Host "Dest:   " $destSAS.AccessSAS

azcopy cp $sourceSAS.AccessSAS $destSAS.AccessSAS 

Write-Host "Copy complete" 

Revoke-AzDiskAccess -ResourceGroupName $sourceRGName -DiskName $sourceDiskName
Revoke-AzDiskAccess -ResourceGroupName $rgname -DiskName $diskName 

