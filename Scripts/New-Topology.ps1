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


Push-Location $PSScriptRoot

. .\Initialize-LocalEnvironment
. .\Restore-AzureRmContext

Write-Information "Create service '$ServiceName'"
$service = New-ClusterService -Name $ServiceName
$service | Write-Output

Write-Information "Create flighting rings '$FlightingRingNames'"
$flightingRings = $FlightingRingNames | % {New-ClusterFlightingRing -Service $service -Name $_}
$flightingRings | Write-Output

Write-Information "Create environment '$environment'"
$environments = $flightingRings | % {New-ClusterEnvironment -FlightingRing $_ -Region "EastUS"}
$environments | Write-Output

Pop-Location
