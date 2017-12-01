
<##
 # Define the Desired State Configuration
 #>

Configuration Main {
    Param(
        [Parameter(Mandatory)][string]$Environment,
        [Parameter(Mandatory)][psobject]$ConfigData,
        [Parameter(Mandatory)][PSCredential]$ServicePrincipal,
        [Parameter(Mandatory)][string]$ServicePrincipalTenantId
    )

    Import-DscResource -ModuleName "OneRF"
    Import-DscResource -ModuleName "PSDesiredStateConfiguration"
    Import-DscResource -ModuleName @{ModuleName = "xPSDesiredStateConfiguration"; RequiredVersion = "8.0.0.0"}
    Import-DscResource -ModuleName @{ModuleName = "xWebAdministration"; RequiredVersion = "1.19.0.0"}

    # extract environment properties from environment id
    ($Service, $FlightingRing, $Region) = $Environment -split "-"

    OneRFPlatform BaseConfiguration {
        Service       = $Service
        Region        = $Region
        FlightingRing = $FlightingRing
    }

}

Main 

Start-DscConfiguration ".\Main" | Wait-Job | Receive-Job

Remove-DscConfigurationDocument -Stage Current, Pending, Previous
