<##
 # Initialize-LocalEnvironment
 ##
 # Configures the local system to build and release Cluster configurations
 #>

$InformationPreference = "Continue"
$ErrorActionPreference = "Stop"

# literal path to repo modules
$ModulePath = Resolve-Path "$PSScriptRoot\..\Modules"

# ensure custom modules are found during DSC packaging and linting
if ($ModulePath -notin ($env:PSModulePath -split ";")) {
    Write-Information "Adding '$ModulePath\Modules' to your machine's 'PSModulePath'"
    # current process
    $env:PSModulePath = "$env:PSModulePath;$ModulePath"
    # future processes
    [Environment]::SetEnvironmentVariable("PSModulePath", $env:PSModulePath, [EnvironmentVariableTarget]::User)
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
