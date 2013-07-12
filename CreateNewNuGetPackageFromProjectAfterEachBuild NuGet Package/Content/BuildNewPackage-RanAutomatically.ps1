param ([string]$ProjectFilePath, [string]$OutputDirectory)
$THIS_SCRIPTS_DIRECTORY = Split-Path $script:MyInvocation.MyCommand.Path

# Specify the version number to use for the NuGet package. If not specified the version number of the assembly being packed will be used.
$versionNumber = ""

# Specify any release notes for this package. 
# These will only be included in the package if you have a .nuspec file for the project in the same directory as the project file.
$releaseNotes = ""

# Specify any additional NuGet Pack options to pass to nuget.exe.
# Do not specify a "-Version" (use $versionNumber above), "-OutputDirectory", or "-NonInteractive", as these are already provided.
# Do not specify "-Build", as this may result in an infinite build loop.
$additionalPackOptions = ""

# Create the new NuGet package.
& "$THIS_SCRIPTS_DIRECTORY\New-NuGetPackage.ps1" -ProjectFilePath "$ProjectFilePath" -VersionNumber $versionNumber -ReleaseNotes $releaseNotes -PackOptions "-OutputDirectory ""$OutputDirectory"" -NonInteractive $additionalPackOptions" -DoNotUpdateNuSpecFile -NoPrompt