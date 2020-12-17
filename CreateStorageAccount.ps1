
Param(
    [string]$ResourceGroupName,
    [string]$Name,
    [string]$SkuName="Premium_LRS", 
    [string]$SkuTier="Premium",
    [string]$Kind="BlockBlobStorage", 
    [string]$site = $env:AZURESITE
  )

$template = "templates\createstorageaccount.json"

Write-Host "Creating new storage account..."
New-AzResourceGroupDeployment -verbose -name $ResourceGroupName -resourcegroupname $ResourceGroupName -templatefile $template `
                              -accountname $Name `
                              -skuname $SkuName `
                              -skutier $SkuTier `
                              -kind    $Kind `
                              -site $site


