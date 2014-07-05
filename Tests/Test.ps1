# Turn on Strict Mode to help catch syntax-related errors.
# 	This must come after a script's/function's param section.
# 	Forces a function to be the first non-comment code to appear in a PowerShell Module.
Set-StrictMode -Version Latest

# Get the directory that this script is in.
$THIS_SCRIPTS_DIRECTORY = Split-Path $script:MyInvocation.MyCommand.Path

cd $THIS_SCRIPTS_DIRECTORY

# Clear the screen.
Clear-Host

# Test packing from a project with a NuSpec file.
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -Verbose
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test Project\TestProject\TestProject.csproj" -VersionNumber "1.1" -ReleaseNotes "Pack project without building and specify version 1.1"

# Test packing from a project without a NuSpec file.
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test Project Without NuSpec\TestProjectWithoutNuSpec\TestProjectWithoutNuSpec.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY"""

# Test packing from a nuspec file.
#.\..\New-NuGetPackage.ps1 -NuSpecFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test NuSpec File\StaticNuSpecFileTest.nuspec"
#.\..\New-NuGetPackage.ps1 -NuSpecFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test NuSpec File\StaticNuSpecFileTest.nuspec" -VersionNumber "1.0.0" -ReleaseNotes "Pack nuspec file with version number and release notes specified"

# Test errors to see how they look.
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test Project With Errors So It Will Not Pack\ProjectWithErrorsSoItWillNotPack\ProjectWithErrorsSoItWillNotPack.csproj" -PackOptions "-Build"
#.\..\New-NuGetPackage.ps1 -NuSpecFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test NuSpec With Errors So It Will Not Pack\NuSpecFileWithErrorsTest.nuspec" -NoPrompt

# Test packing without specifying a file path or any other parameters.
#.\..\New-NuGetPackage.ps1
#.\..\New-NuGetPackage.ps1 -UsePowerShellPrompts -NoPromptForInputOnError

# Test packing using the various different prompt modes.
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -NoPrompt
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -NoPromptForVersionNumber
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -NoPromptForReleaseNotes
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -NoPromptForPushPackageToNuGetGallery
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -NoPromptForInputOnError
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -UsePowershellPrompts

# Test packing without updating the NuSpec file.
#.\..\New-NuGetPackage.ps1 -NuSpecFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test NuSpec File\StaticNuSpecFileTest.nuspec" -DoNotUpdateNuSpecFile
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test Project\TestProject\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""$THIS_SCRIPTS_DIRECTORY""" -DoNotUpdateNuSpecFile

# Test packing by specifying a custom NuGet.exe path with spaces.
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test Project\TestProject\TestProject.csproj" -VersionNumber "1.2" -ReleaseNotes "Pack project without building and specify version 1.2" -NuGetExecutableFilePath "$THIS_SCRIPTS_DIRECTORY\NuGet Executable\NuGet.exe"

# Test packing from a relative path.
#.\..\New-NuGetPackage.ps1 -NuSpecFilePath ".\Test Files\Test NuSpec File\StaticNuSpecFileTest.nuspec" -DoNotUpdateNuSpecFile
#.\..\New-NuGetPackage.ps1 -ProjectFilePath ".\Test Files\Test Project\TestProject\TestProject.csproj" -DoNotUpdateNuSpecFile

# Test the NuGet Update switch.
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test Project\TestProject\TestProject.csproj" -VersionNumber "1.3" -ReleaseNotes "Pack project without building and specify version 1.3 and do NOT update the NuGet.exe" -NoPromptForPushPackageToNuGetGallery -NuGetExecutableFilePath "$THIS_SCRIPTS_DIRECTORY\Older Version NuGet Executable\NuGet.exe" -Verbose
#.\..\New-NuGetPackage.ps1 -ProjectFilePath "$THIS_SCRIPTS_DIRECTORY\Test Files\Test Project\TestProject\TestProject.csproj" -VersionNumber "1.3" -ReleaseNotes "Pack project without building and specify version 1.3 and update the NuGet.exe" -NoPromptForPushPackageToNuGetGallery -NuGetExecutableFilePath "$THIS_SCRIPTS_DIRECTORY\Older Version NuGet Executable\NuGet.exe" -UpdateNuGetExecutable -Verbose




#Nuget spec $THIS_SCRIPTS_DIRECTORY\Test Files\TestProject\TestProject\TestProject.csproj -f
#Nuget spec $THIS_SCRIPTS_DIRECTORY\Test Files\TestDll\TestDll.dll -f

#Nuget pack $THIS_SCRIPTS_DIRECTORY\Test Files\TestProject\TestProject\TestProject.csproj -OutputDirectory $thisScriptsDirectory -Build

#cd $THIS_SCRIPTS_DIRECTORY\Test Files\TestProject\TestProject
#nuget spec -f

#cd $THIS_SCRIPTS_DIRECTORY\Test Files\TestDll
#nuget spec -f
