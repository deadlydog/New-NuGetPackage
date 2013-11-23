param($installPath, $toolsPath, $package, $project)

# Get the current Post-Build Event text.
$postBuildEventText = $project.Properties.Item(“PostBuildEvent”).Value

# Define the Post-Build Event Code to remove.
$postBuildEventCode = @'
REM Create a NuGet package for this project and place the .nupkg file in the project's output directory.
ECHO Building NuGet package in Post-Build event...
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '$(ProjectDir)PostBuildScripts\BuildNewPackage-RanAutomatically.ps1' -ProjectFilePath '$(ProjectPath)' -OutputDirectory '$(TargetDir)' -Configuration='$(ConfigurationName)' -Platform='$(PlatformName)'"
'@

# Remove the Post-Build Event Code to the project and save it.
$postBuildEventText = $postBuildEventText.Replace($postBuildEventCode, "")
$project.Properties.Item(“PostBuildEvent”).Value = $postBuildEventText.Trim()
$project.Save()