
Param(
    [string]$SourceResourceGroupName,
    [string]$SourceDiskName, 
    [string]$ResourceGroupName,
    [string]$DiskName,
    [string]$Site = $env:AZURESITE
  )

$template = "templates\createdisk.json"
$sasDuration = 3600

Remove-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $DiskName -Force
$disk = Get-AzDisk -ResourceGroupName $SourceResourceGroupName -DiskName $SourceDiskName

Write-Host "Creating new disk..."
New-AzResourceGroupDeployment -verbose -name $ResourceGroupName -resourcegroupname $ResourceGroupName -templatefile $template `
                              -diskName $DiskName `
                              -diskUploadSize ($disk.DisksizeBytes + 512) `
                              -site $Site


Write-Host "Grant SAS access..." 

$sourceSAS = Grant-AzDiskAccess -ResourceGroupName $SourceResourceGroupName -DiskName $SourceDiskName -DurationInSecond $sasDuration -Access Read
$destSAS = Grant-AzDiskAccess -ResourceGroupName $ResourceGroupName -DiskName $DiskName -DurationInSecond $sasDuration -Access Write

Start-Sleep -Seconds 60  

Write-Host "Copying disk bytes..." 

Write-Host "Source: " $sourceSAS.AccessSAS
Write-Host "Dest:   " $destSAS.AccessSAS

azcopy cp $sourceSAS.AccessSAS $destSAS.AccessSAS 

Write-Host "Copy complete" 

Revoke-AzDiskAccess -ResourceGroupName $SourceResourceGroupName -DiskName $SourceDiskName
Revoke-AzDiskAccess -ResourceGroupName $ResourceGroupName -DiskName $DiskName 

