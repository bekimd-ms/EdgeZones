
Param(
    [string]$Publisher,
    [string]$Offer,
    [string]$Sku,
    [string]$Version,
    [string]$ResourceGroupName,
    [string]$DiskName,
    [string]$Location = $env:AZURELOCATION,
    [string]$Site = $env:AZURESITE
  )

$image = Get-AzVMImage -Location $Location `
                       -PublisherName $Publisher `
                       -Offer $Offer `
                       -Skus $Sku `
                       -Version $Version 

$diskConfig = New-AzDiskConfig -CreateOption FromImage `
                       -ImageReference @{Id= $image.ID} `
                       -Location $Location
                      
Write-Host "Creating disk from image..."
New-AzDisk -ResourceGroupName $ResourceGroupName `
           -DiskName $DiskName `
           -Disk $diskConfig



