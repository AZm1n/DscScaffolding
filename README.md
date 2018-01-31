# This repro is still in active development and is not currently supported by Microsoft

# DscScaffolding
Project template for creating PowerShell Desired State Configurations and deploying them to Azure using the [Cluster](https://github.com/Microsoft/Cluster) PowerShell module.

### Prerequisite Concepts
* [PowerShell Desired State Configurations](https://docs.microsoft.com/en-us/powershell/dsc/overview)
* [Azure Resource Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview)

## DSC Extension is currently supported.  CSE theoretically works, but has not been tested.

## Structure

### .vscode
Configures project-specific settings in VS Code to help avoid common PowerShell issues.

### Definitions
This is where configs are placed.  Service definitions (AzureRM templates, DSCs, etc) are placed in this folder and named with according to the [Config Selection](https://github.com/Microsoft/Cluster#configselection) rules.

### Modules
When developing a custom DSC, all resources must be placed in a module.  There are many community modules listed and documented on https://github.com/PowerShell/, and installable from the PowerShell gallery with `Install-Module`.  Custom resources must be defined in custom modules.  For development convenience, the Modules folder is added to the PowerShell module search path (`$env:PSModulePath`) with `Initialize-LocalEnvironment.ps1` script, enabling linting, validation, and packaging the DSC for deployment.  

More information about defining custom DSC modules and resources is available in `.\Modules\README.md`.

### Scripts
Scripts for dev environment creation, build validation, and deployment are placed here.  Typically, these are convience scripts wrapping the `Cluster` module.  These scripts are in active development and are not currently to be trusted.

### .gitignore
Ensures user-specific files are not saved to the git repository.

### LICENSE
Must travel with all copies/forks of this repo to ensure compliance with Microsoft's Open Source policy.  More information at opensource.ms.

### PSScriptAnalyzerSettings.psd1
Custom settings for the PowerShell static analysis engine, "PSScriptAnalyzer".  When run, PSScriptAnalyzer will first ensure that your project has no syntax or module import errors, then ensure your code follows some common style, safety, and security practices.  The declarative nature of DSCs makes static analysis extra beneficial.

PSScriptAnalyzer errors can almost always be detected and resolved using VS Code linting alone.  To get a complete print out of PSScriptAnalyzer issues, run `Invoke-ScriptAnalyzer . -Recurse` in the repo root.


# Set up

1. Install VS Code
1. Install msazurermtools and ms-vscode.powershell
1. Run the `.\Scripts\Initialize-LocalEnvironment.ps1` script to configure your PSModulePath and install required modules
1. Close any open VS Code windows, then open the project in VS Code


# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
