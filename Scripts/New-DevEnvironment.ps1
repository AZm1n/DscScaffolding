<##
 # Simple parameterless script for devs to quickly create a OneRF environment to test in
 #>

$InformationPreference = "Continue"
$ErrorActionPreference = "Stop"


# run in scriptblock to capture all output streams
& {

    # initialize environment if not initialized
    try {
        # validate settings can be parsed
        Write-Information "Checking if logged into Azure"
        Import-AzureRmContext -Path "$PSScriptRoot\.context.json"
    } catch {
        # set up settings and exit
        Write-Information "Not logged in to Azure; logging in (won't happen in subsequent invokations)"
        &"$PSScriptRoot\Initialize-LocalEnvironment.ps1" (Read-Host "Azure subscription name")
        Write-Information "Your local machine is now configured"
        Start-Process `
            -FilePath "PowerShell" `
            -ArgumentList "$PSScriptRoot\New-DevEnvironment.ps1" `
            -UseNewEnvironment `
            -NoNewWindow `
            -Wait
        exit
    }


    <##
     # Create new dev environment
     #>

    Import-Module "Cluster" -Force

    Write-Information "Deploying dev cluster"
    New-Cluster `
        -ServiceName ([Regex]::Replace($env:USERNAME, "^\w", {param($c) $c.Value.ToUpper() })) `
        -FlightingRingName "DEV" `
        -RegionName "EastUS"

} *>&1 | Tee-Object "$PSScriptRoot\New-DevEnvironment.log"

