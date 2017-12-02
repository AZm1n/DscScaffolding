# Modules
Any code not placed directly in your DSC (your config with a .ps1 extension) must be defined in a module.  Custom modules are implemented in the Modules folder.  Multiple custom modules are only necessary for organizational purposes.

## Module structure
A module 'MyModule' must have
* a folder 'MyModule' in Modules
* a module script file 'MyModule.psm1' containing logic
* a module manifest file 'MyModule.psd1' containing metadata and specifying which variables, cmdlets, functions, in 'MyModule.psm1' should be available outside the module

## Class-based resources
Class-based resources are custom DSC resources that are implemented using PowerShell classes.  Class-based resources must be completely serializable/deserializable and must therefore only contain PowerShell primatives.  Class definitions must be defined in the module script file (ex: `MyModule.psm1`) and explicitly exported in the module manifest (ex: `MyModule.psd1`).

More information: https://docs.microsoft.com/en-us/powershell/dsc/authoringresourceclass

## Composite resources
Composite resources are themselves DSCs (as opposed to PowerShell classes).  Composite resource definitions have folder structures equivalent to modules.  The composite resource's module folder is then placed in the `DSCResources` within the root module.  The root module is what is specified as `$ModuleName` in the `Import-DscResource -ModuleName $ModuleName` directive.

More information: https://docs.microsoft.com/en-us/powershell/dsc/authoringresourcecomposite
