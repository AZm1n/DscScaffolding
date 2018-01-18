<##
 # Assert-ValidBuild
 ##
 # Script for use as an Azure PowerShell Task in a VSTS Build Definition.  Git should require successful completion of the build definition before merging changes into master.  Modify as needed.
 #>

$ErrorActionPreference = "Continue"
$InformationPreference = "Continue"



. "$PSScriptRoot\Initialize-LocalEnvironment"


<##
 # Run PSScriptAnalyzer
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
 # Run unit tests
 #>

Import-Module "Pester"
Invoke-Pester "$PSScriptRoot\.."



<##
 # Compile DSC - Uncomment these lines and modify parameters to match your DSC
 #>

# $parameters = @{
#     Parameter1 = "..."
#     Parameter2 = "..."
# }

# $dscPaths = (Get-ChildItem "$PSScriptRoot\..\Definitions\*.dsc.ps1").FullName
# foreach ($dscPath in $dscPaths) {
#     .$dscPath
#     Main @parameters
# }


