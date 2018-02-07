<##
 # New-Topology
 ##
 # Creates Service, Flighting Ring, and Environment resource groups in Azure
 #>
Param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$ServiceName,
    [ValidateNotNullOrEmpty()]
    [string[]]$FlightingRingNames = ("DEV", "TEST", "PPE", "PROD"),
    [ValidateNotNullOrEmpty()]
    [Alias('Region')]
    [string]$RegionName = "EastUS"
)


$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"


Push-Location "$PSScriptRoot\.."

. .\Scripts\Initialize-LocalEnvironment
. .\Scripts\Restore-AzureRmContext
Import-Module "Cluster"

Write-Information "Creating service '$ServiceName'"
$service = New-ClusterService -Name $ServiceName

$flightingRings = $FlightingRingNames | % {
    Write-Information "Creating flighting ring '$service-$_'"
    New-ClusterFlightingRing -Service $service -Name $_
}

$flightingRings | % {
    Write-Information "Creating environment '$_-$RegionName'"
    New-ClusterEnvironment -FlightingRing $_ -RegionName $RegionName
} | Out-Null

Pop-Location
