
<##
 # Define the Desired State Configuration
 #>

Configuration Main {
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Environment,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [psobject]$ConfigData,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$ServicePrincipal,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ServicePrincipalTenantId
    )


    # dependent modules need to be installed prior to both compilation and execution
    Import-DscResource -ModuleName "PSDesiredStateConfiguration"
    Import-DscResource -ModuleName @{ModuleName = "vscode"; RequiredVersion = "1.0"}
    Import-DscResource -ModuleName @{ModuleName = "xPSDesiredStateConfiguration"; RequiredVersion = "8.0.0.0"}

    # extract environment properties from environment id
    ($Service, $FlightingRing, $Region) = $Environment -split "-"

    File BuenosDiasMundo {
        DestinationPath = "C:\test.txt"
        Contents        = "Buenos Dias, Mundo!"
    }

    xRemoteFile DownloadVsCode {
        URI             = "https://go.microsoft.com/fwlink/?LinkID=623230"
        DestinationPath = "$env:TEMP\vscodesetup.exe"
        MatchSource     = $false # don't hashcheck
    }

    VSCodeSetup VsCode {
        IsSingleInstance = "yes"
        Path             = "$env:TEMP\vscodesetup.exe"
        Ensure           = "Present"
    }

    Log HelloWorld {
        Message = "Hello $($Config.Hello)"
    }

}

