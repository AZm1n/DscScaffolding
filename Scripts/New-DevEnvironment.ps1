<##
 # New-DevEnvironment
 ##
 # Creates a new dev environment in Azure
 #>
Param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [Alias('Service')]
    [string]$ServiceName
)

$InformationPreference = "Continue"
$ErrorActionPreference = "Stop"


Push-Location -Path "$PSScriptRoot\.."

Write-Information "Ensuring prerequisites are met"
. .\Initialize-LocalEnvironment

Write-Information "Ensuring logged in to Azure"
$subscription = Read-Host "Azure subscription name"
.\Restore-AzureRmContext $subscription

Write-Information "Deploying dev cluster"
Import-Module "Cluster" -Force
New-Cluster `
    -ServiceName $ServiceName `
    -FlightingRingName "DEV" `
    -RegionName "EastUS" `
    *>&1 | Tee .\New-DevEnvironment.log

Pop-Location

