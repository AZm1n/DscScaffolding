<##
 # Restore-AzureRmContext
 ##
 # Sets the AzureRM Context from a cached file or prompt
 #>
Param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Subscription
)

if (-not (Get-AzureRmContext).Account -or (Get-AzureRmSubscription).Name -ne $Subscription) {
    try {
        Import-AzureRmContext -Path "$PSScriptRoot\.context.json"
    } catch {
        Login-AzureRmAccount
        Set-AzureRmContext -Subscription $Subscription
        Save-AzureRmContext -Path "$PSScriptRoot\.context.json"
    }
}
