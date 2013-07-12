param($installPath, $toolsPath, $package, $project)
$postBuildEventText = $project.Properties.Item(“PostBuildEvent”).Value

# If there is already a call to the powershell script in the post build event, then just exit.
if ($postBuildEventText -match "New-NuGetPackage.ps1")
{
	return
}

# Define the Post-Build Event Code to add.
$postBuildEventCode = @'
REM Create a NuGet package for this project and place the .nupkg file in the project's output directory.
ECHO Building NuGet package in Post-Build event...
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '$(ProjectDir)PostBuildScripts\BuildNewPackage-RanAutomatically.ps1' -ProjectFilePath '$(ProjectPath)' -OutputDirectory '$(TargetDir)'"
'@

# Add the Post-Build Event Code to the project and save it (prepend a couple newlines in case there is existing Post Build Event text).
$postBuildEventText += "`n`r`n`r$postBuildEventCode"
$project.Properties.Item(“PostBuildEvent”).Value = $postBuildEventText.Trim()
$project.Save()