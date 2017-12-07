param($installPath, $toolsPath, $package, $project)

# Get the current Post-Build Event text.
$postBuildEventText = $project.Properties.Item("PostBuildEvent").Value
$postBuildEventCodeMarker = @'
REM CreateNewNuGetPackageFromProjectAfterEachBuild Update Block
'@
###### Start of code to remove older versions of post build event text.
$oldPostBuildEventCode = @'
REM Create a NuGet package for this project and place the .nupkg file in the project's output directory.
ECHO Building NuGet package in Post-Build event...
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '$(ProjectDir)PostBuildScripts\BuildNewPackage-RanAutomatically.ps1' -ProjectFilePath '$(ProjectPath)' -OutputDirectory '$(TargetDir)' -Configuration '$(ConfigurationName)' -Platform '$(PlatformName)'"
'@
$postBuildEventText = $postBuildEventText.Replace($oldPostBuildEventCode, $postBuildEventCodeMarker)

$oldPostBuildEventCode = @'
REM Create a NuGet package for this project and place the .nupkg file in the project's output directory.
ECHO Building NuGet package in Post-Build event...
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '$(ProjectDir)PostBuildScripts\BuildNewPackage-RanAutomatically.ps1' -ProjectFilePath '$(ProjectPath)' -OutputDirectory '$(TargetDir)' -Configuration='$(ConfigurationName)' -Platform='$(PlatformName)'"
'@
$postBuildEventText = $postBuildEventText.Replace($oldPostBuildEventCode, $postBuildEventCodeMarker)

$oldPostBuildEventCode = @'
REM Create a NuGet package for this project and place the .nupkg file in the project's output directory.
REM If you see this in Visual Studio's Error List window, check the Output window's Build tab for the actual error.
ECHO Building NuGet package in Post-Build event...
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '$(ProjectDir)PostBuildScripts\BuildNewPackage-RanAutomatically.ps1' -ProjectFilePath '$(ProjectPath)' -OutputDirectory '$(TargetDir)' -Configuration '$(ConfigurationName)' -Platform '$(PlatformName)'"
'@
$postBuildEventText = $postBuildEventText.Replace($oldPostBuildEventCode, $postBuildEventCodeMarker)
###### End of code to remove older versions of post build event text.

# Define the Post-Build Event Code to remove.
$postBuildEventCode = @'
REM Create a NuGet package for this project and place the .nupkg file in the project's output directory.
REM If you see this in Visual Studio's Error List window, check the Output window's Build tab for the actual error.
ECHO Creating NuGet package in Post-Build event...
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '$(ProjectDir)_CreateNewNuGetPackage\DoNotModify\CreateNuGetPackage.ps1' -ProjectFilePath '$(ProjectPath)' -OutputDirectory '$(TargetDir)' -BuildConfiguration '$(ConfigurationName)' -BuildPlatform '$(PlatformName)'"
'@

# Remove the Post-Build Event Code to the project and save it.
$postBuildEventText = $postBuildEventText.Replace($postBuildEventCode, $postBuildEventCodeMarker)
$project.Properties.Item("PostBuildEvent").Value = $postBuildEventText.Trim()
$project.Save()