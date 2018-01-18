<##
 # Release-Environment
 ##
 # Script for use as an Azure PowerShell Task in a VSTS Release Definition.  Modify as needed.  Configurations will expire in one month if the -Expiry parameter is unchanged.  For maximum security, set up timed releases in VSTS with image baking.
 #>
Param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$ServiceName,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$FlightingRingName,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [Alias('Region')]
    [string]$RegionName
)


Push-Location $PSScriptRoot

. .\Initialize-LocalEnvironment
.\Restore-AzureRmContext
Import-Module "Cluster"

$clusters = Select-Cluster $ServiceName $FlightingRingName $RegionName
foreach ($cluster in $clusters) {
    Write-Information "Deploying '$cluster'"
    Publish-ClusterConfiguration `
        -Cluster $cluster `
        -DefinitionsContainer "$PSScriptRoot\..\Definitions" `
        -Expiry (Get-Date).AddMonths(1)
}

Pop-Location
