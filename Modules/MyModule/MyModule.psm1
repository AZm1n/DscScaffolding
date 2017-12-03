<##
 # MyModule.psm1
 ##
 # https://docs.microsoft.com/en-us/powershell/dsc/authoringresourceclass
 #>

# This enum is for determining if a resource should be absent or present
enum Ensure {
    Absent
    Present
}

# DSC resources are serialized on compilation.  As such, all class properties must support type coercion to primitives.
class MyClassBasedResource {
    [DscProperty(Key)]
    $MyMandatoryProperty

    [DscProperty()]
    [Ensure]$Ensure

    
}
