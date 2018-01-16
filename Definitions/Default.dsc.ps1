
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

    Import-DscResource -ModuleName "PSDesiredStateConfiguration"
    Import-DscResource -ModuleName "MyModule"

    # extract environment properties from environment id
    ($Service, $FlightingRing, $Region) = $Environment -split "-"

    MyCompositeResource MyCompositeTest {
        ConfigValues    = @("a", "b", "c")
        LogConfigValues = $true
    }

}

