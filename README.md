# EdgeZones tools

Powershell scripts for creating disks, images and VMs for Edge Zones


Create resource group for disks in your Azure region 
Create resource group for disks and images for the edge site


Set the location and site environment variables<br>
```powershell
$env:AZURELOCATION =  "eastus2euap"
$env:AZURESITE = "MicrosoftRRDCLab1"
```

Create a disk from a PIR image. Find the available images using: Get-AzVMImagePublisher, Get-AzVMImageOffer, Get-AzVMImageSKU, Get-AzVMImage.  
```powershell
.\CreateDiskFromImage.ps1 -Location eastus2euap -Publisher MicrosoftWindowsServer -Offer WindowsServer -Sku 2019-Datacenter -Version 2019.0.20181107 -ResourceGroupName osimages -DiskName windowsserver_2019_datacenter
.\CreateDiskFromImage.ps1 -Location eastus2euap -Publisher Canonical -Offer UbuntuServer -Sku 18.04-LTS -Version 18.04.202011120 -ResourceGroupName osimages -DiskName ubuntuserver_1804_LTS
```
The following scripts use azcopy to copy the disk content from azure region to edge site.

[Install azcopy](https://azcopyvnext.azureedge.net/release20201106/azcopy_windows_amd64_10.7.0.zip)

Unzip and make sure you ad azcopy.exe binary location to path before running the next script. 

Copy the disk into a disk at edge site 
```powershell
.\CopyDiskToEdgeSite.ps1 -SourceResourceGroupName osimages -SourceDiskName windowsserver_2019_datacenter -ResourceGroupName rr1_osimages -DiskName windowsserver_2019_datacenter
.\CopyDiskToEdgeSite.ps1 -SourceResourceGroupName osimages -SourceDiskName ubuntuserver_1804_LTS -ResourceGroupName rr1_osimages -DiskName ubuntuserver_1804_LTS
```

Create image from disk at edge sire
```powershell
.\CreateImageFromDisk.ps1 -SourceResourceGroupName rr1_osimages -SourceDiskName windowsserver_2019_datacenter -ResourceGroupName rr1_osimages -ImageName windowsserver_2019_datacenter -OsType Windows
.\CreateImageFromDisk.ps1 -SourceResourceGroupName rr1_osimages -SourceDiskName ubuntuserver_1804_LTS -ResourceGroupName rr1_osimages -ImageName ubuntuserver_1804_LTS -OsType Linux
```

After the image is created you can use it for creating as many VMs as you wish

Create resource group for VM 
```powershell
New-AzResourceGroup -ResourceGroupName rr1windowsvm -Location $env:AZURELOCATION
New-AzResourceGroup -ResourceGroupName rr1linuxvm -Location $env:AZURELOCATION
```

Create VM from image.   
```powershell
$UserName = "[admin username for new VM]"
$Password = "[admin password for new VM]"
.\CreateVMFromImage.ps1 -ResourceGroupName rr1windowsvm -VMName rr1windowsvm -ImageResourceGroupName rr1_osimages -ImageName windowsserver_2019_datacenter -UserName $UserName -Password $Password
.\CreateVMFromImage.ps1 -ResourceGroupName rr1linuxvm -VMName rr1linuxvm -ImageResourceGroupName rr1_osimages -ImageName ubuntuserver_1804_LTS -UserName $UserName -Password $Password
```
