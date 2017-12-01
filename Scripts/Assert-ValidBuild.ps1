<##
 # Assert-ValidBuild.ps1
 ##
 # This script is designed to validate builds on build servers, such as VSTS.
 # This script should be used locally to validate the current scripts 
 #>

$ErrorActionPreference = "Continue"
$InformationPreference = "Continue"

# install required modules
Install-PackageProvider -Name "NuGet" -MinimumVersion "2.8.5.201" -Force -Scope "CurrentUser" | Out-Null
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

# install required modules
Import-Csv "$PSScriptRoot\..\RequiredPSGalleryModules.csv" `
    | ? {-not (Get-Module -FullyQualifiedName @{ModuleName = $_.Name; RequiredVersion = $_.Version} -ListAvailable)} `
    | % {Install-Module -Name $_.Name -RequiredVersion $_.Version -Scope "CurrentUser"}

# ensure module import works in code analysis
$env:PSModulePath += ";$PSScriptRoot\..\Modules"


<##
 # Assert valid style
 #>
Import-Module "PSScriptAnalyzer" 
$FailedTests = Invoke-ScriptAnalyzer -Path "$PSScriptRoot\.." -Recurse -ErrorVariable "scriptAnalyzerErrors"
if ($FailedTests.Count -or $scriptAnalyzerErrors.Count) {
    # fail
    "--------------------------", 
    "- Static Analysis Errors -", 
    "--------------------------" `
        | % {Write-Information $_}
    $scriptAnalyzerErrors | Out-String | % {Write-Information $_}
    $FailedTests | Format-Table | Out-String | % {Write-Information $_}
    Write-Error "Failed style enforcement tests"
} else {
    # pass
    Write-Information "Script style is valid"
}


<##
 # Assert valid Pester tests
 #>
Import-Module "Pester"
Invoke-Pester "$PSScriptRoot\.."

