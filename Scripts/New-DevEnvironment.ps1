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

. .\Scripts\Initialize-LocalEnvironment
. .\Scripts\Restore-AzureRmContext
Import-Module "Cluster"

Write-Information "Deploying dev cluster"
New-Cluster `
    -ServiceName $ServiceName `
    -FlightingRingName "DEV" `
    -RegionName "EastUS" `
    -DefinitionsContainer ".\Definitions" `
    *>&1 | Tee ".\New-DevEnvironment.log"

Pop-Location

