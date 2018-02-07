<##
 # Restore-AzureRmContext
 ##
 # Sets the AzureRM Context from a cached file or prompt
 #>


$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"


$contextPath = "$PSScriptRoot\.context.json" # must be an absolute path

try {
    Import-AzureRmContext -Path $contextPath
} catch {
    Add-AzureRmAccount | Out-Null
    
    Write-Warning "You will need to delete '$contextPath' if you wish to change the target subscription"
    $subscription = Read-Host -Prompt "Target Azure subscription"
    Set-AzureRmContext -Subscription $subscription

    Save-AzureRmContext -Path $contextPath
}
