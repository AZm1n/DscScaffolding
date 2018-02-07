<##
 # Initialize-LocalEnvironment
 ##
 # Configures the local system to build and release Cluster configurations
 #>

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

Push-Location "$PSScriptRoot\.."


# literal path to repo modules
$ModulePath = Resolve-Path ".\Modules"

# ensure custom modules are found during DSC packaging and linting
if ($ModulePath -notin ($env:PSModulePath -split ";")) {
    Write-Information "Adding '$ModulePath' to your machine's 'PSModulePath'"
    # save changes for current runtime
    $env:PSModulePath = "$env:PSModulePath;$ModulePath"
    # save changes for future runtimes
    [Environment]::SetEnvironmentVariable("PSModulePath", $env:PSModulePath, [EnvironmentVariableTarget]::User)
}

# enable headless installation from PowerShell gallery
if (-not (Get-PackageProvider -Name "NuGet") -or -not (Get-PSRepository -Name "PSGallery")) {
    Write-Information "Adding PSGallery as a package provider"
    Install-PackageProvider -Name "NuGet" -Scope "CurrentUser" -Force | Out-Null
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
}

# install missing required PowerShell Gallery modules
$missingModules = Import-Csv ".\RequiredPSGalleryModules.csv" `
    | ? {-not (Get-Module -FullyQualifiedName @{ModuleName = $_.Name; ModuleVersion = $_.Version} -ListAvailable)}
if ($missingModules) {
    Write-Information "Ensuring modules are installed"
    $missingModules `
        | % {Install-Module -Name $_.Name -RequiredVersion $_.Version -Scope "CurrentUser" -AllowClobber -SkipPublisherCheck}
}


Pop-Location
