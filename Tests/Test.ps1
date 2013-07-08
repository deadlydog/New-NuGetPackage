# Turn on Strict Mode to help catch syntax-related errors.
# 	This must come after a script's/function's param section.
# 	Forces a function to be the first non-comment code to appear in a PowerShell Module.
Set-StrictMode -Version Latest

# Get the directory that this script is in.
$THIS_SCRIPTS_DIRECTORY = Split-Path $script:MyInvocation.MyCommand.Path

cd $THIS_SCRIPTS_DIRECTORY

# Test packing from a project with a NuSpec file.
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY"""
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Project\TestProject\TestProject.csproj" -VersionNumber "1.1" -ReleaseNotes "Pack project without building and specify version 1.1"

# Test packing from a project without a NuSpec file.
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Project Without NuSpec\TestProjectWithoutNuSpec\TestProjectWithoutNuSpec.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY"""

# Test packing from a nuspec file.
#.\..\New-NuGetPackage.ps1 -NuSpecFilePath "$THIS_SCRIPTS_DIRECTORY\Test NuSpec File\StaticNuSpecFileTest.nuspec"
#.\..\New-NuGetPackage.ps1 -NuSpecFilePath "$THIS_SCRIPTS_DIRECTORY\Test NuSpec File\StaticNuSpecFileTest.nuspec" -VersionNumber "1.0.0" -ReleaseNotes "Pack nuspec file with version number and release notes specified"

# Test packing without specifying a file path or any other parameters.
#.\..\New-NuGetPackage.ps1
#.\..\New-NuGetPackage.ps1 -UsePowerShellPrompts -NoPromptForInputOnError

# Test packing using the various different prompt modes.
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -NoPrompt
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -NoPromptForVersionNumber
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -NoPromptForReleaseNotes
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -NoPromptForPushPackageToNuGetGallery
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -NoPromptForInputOnError
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -UsePowershellPrompts

# Test packing without updating the NuSpec file.
#.\..\New-NuGetPackage.ps1 -NuSpecFilePath "$THIS_SCRIPTS_DIRECTORY\Test NuSpec File\StaticNuSpecFileTest.nuspec" -DoNotUpdateNuSpecFile
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -DoNotUpdateNuSpecFile

# Test packing by specifying a custom NuGet.exe path with spaces.
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Project\TestProject\TestProject.csproj" -VersionNumber "1.2" -ReleaseNotes "Pack project without building and specify version 1.2" -NuGetExecutableFilePath "C:\dev\TFS\RQ\Dev\Tools\DevOps\New-NuGetPackage\Tests\NuGet Executable\NuGet.exe"

# Test packing from a relative path.
#.\..\New-NuGetPackage.ps1 -NuSpecFilePath ".\Test NuSpec File\StaticNuSpecFileTest.nuspec" -DoNotUpdateNuSpecFile
#.\..\New-NuGetPackage.ps1 -ProjectFilePath ".\Test Project\TestProject\TestProject.csproj" -DoNotUpdateNuSpecFile





#Nuget spec $thisScriptsDirectory\TestProject\TestProject\TestProject.csproj -f
#Nuget spec $thisScriptsDirectory\TestDll\TestDll.dll -f

#Nuget pack $thisScriptsDirectory\TestProject\TestProject\TestProject.csproj -OutputDirectory $thisScriptsDirectory -Build

#cd $thisScriptsDirectory\TestProject\TestProject
#nuget spec -f

#cd $thisScriptsDirectory\TestDll
#nuget spec -f
