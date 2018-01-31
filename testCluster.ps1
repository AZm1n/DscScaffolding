Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionId "895e4792-6eb1-48b1-b3b8-517df81ca20c"

Import-Module ..\Cluster\Cluster.psm1
. ..\Cluster\Types.ps1


$number = Get-Random
$service = New-ClusterService -Name "Onerf$number"
$ring = New-ClusterFlightingRing -Service $service -Name "Dev"
$env = New-ClusterEnvironment -FlightingRing $ring -Region "westus2"
$cluster = $env.NewChildCluster()
$cluster.PublishConfiguration(".\Definitions", [datetime]::MaxValue)
