<##
 # MyCompositeResource.schema.psm1
 ##
 # https://docs.microsoft.com/en-us/powershell/dsc/authoringresourcecomposite
 #>

Configuration MyConfiguration {
    Param(
        [Parameter(Mandatory)]
        [string[]]$ConfigValues,
        [Parameter(Mandatory)]
        [bool]$LogConfigValues
    )

    # These directives introduce the DSC resources from the specified modules 
    # into the compilation namespace.  PSDesiredStateConfiguration ships with
    # PowerShell, while the other two were installed with Install-Module.
    Import-DscResource -ModuleName "PSDesiredStateConfiguration"
    Import-DscResource -ModuleName @{
        ModuleName      = "xPSDesiredStateConfiguration"
        RequiredVersion = "8.0.0.0"
    }
    Import-DscResource -ModuleName @{
        ModuleName      = "vscode" 
        RequiredVersion = "1.0"
    }

    # Variables can be defined and evaluated during compile time to simplify
    # configuration definitions
    $startTime = Get-Date

    # This resource logs Message to the event log located at Event Viewer path:
    #   App... logs\Microsoft\Windows\Desired State Configurations\Operational
    Log StartTime {
        # This string is evaluated at compile time.  The time of compilation
        # will be logged on every invokation of this Log resource
        Message = "The time is $startTime"
    }

    # Download the VS Code installer to %TEMP%\vscodesetup.exe
    xRemoteFile DownloadVsCode {
        URI             = "https://go.microsoft.com/fwlink/?LinkID=623230"
        DestinationPath = "$env:TEMP\vscodesetup.exe"
        # Avoid downloading on every execution by disabling equality checks
        MatchSource     = $false
    }

    # Use a community resource to set up VS Code
    VSCodeSetup VsCode {
        # Mandatory field, because it doesn't make sense to have multiple 
        # installations in a single (default) location
        IsSingleInstance = "yes"
        Path             = "$env:TEMP\vscodesetup.exe"
        Ensure           = "Present"
    }

    # Common control flow statements can be used during compilation
    if ($LogConfigValues) {
        1..$ConfigValues.Count | % {
            Log "ConfigValue$_" {
                Message = $ConfigValues[$_]
            }
        }
    }

}
