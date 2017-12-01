Param(
    [Parameter(Mandatory)]
    [string]$SubscriptionName
)

$InformationPreference = "Continue"
$ErrorActionPreference = "Stop"

# literal path to repo modules
$ModulePath = Resolve-Path "$PSScriptRoot\..\Modules"


# ensure custom modules are found during DSC packaging and linting
if (($env:PSModulePath -split ";") -notcontains $ModulePath) {
    Write-Information "Adding '$ModulePath\Modules' to your machine's 'PSModulePath'"
    [Environment]::SetEnvironmentVariable("PSModulePath", "$env:PSModulePath;$ModulePath", [EnvironmentVariableTarget]::User)
}

# enable headless installation from PowerShell gallery
Write-Information "Adding PSGallery as a package provider"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Scope "CurrentUser" -Force | Out-Null
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

# install missing required PowerShell Gallery modules
Write-Information "Ensuring modules are installed"
Import-Csv "$PSScriptRoot\..\RequiredPSGalleryModules.csv" `
    | ? {-not (Get-Module -FullyQualifiedName @{ModuleName = $_.Name; ModuleVersion = $_.Version} -ListAvailable)} `
    | % {Install-Module -Name $_.Name -RequiredVersion $_.Version -Scope "CurrentUser" -AllowClobber}

# set checkpoint to avoid installing in the future
Write-Information "Saving your settings to '$PSScriptRoot\.context.json' to speed things up next time"
Save-AzureRmContext `
    -Path "$PSScriptRoot\.context.json" `
    -Profile (Add-AzureRmAccount -SubscriptionName $SubscriptionName) `
    -Force

Write-Warning "Reopen your PowerShell window for the changes to take effect"

