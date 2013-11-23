#==========================================================
# This script is ran automatically after every successful build.
#
# This script creates a NuGet package for the current project, and places the .nupkg file in the project's output directory (beside the .dll/.exe file).
#
# You may edit the values of the $versionNumber, $releaseNotes, $packProperties, $additionalPackProperties, and $additionPackOptions variables below to adjust the settings used to create the NuGet package.
#
# If you have modified this script:
#	- if you uninstall the "Create New NuGet Package From Project After Each Build" package, this file will not be removed automatically; you will need to manually delete it.
#	- if you update the "Create New NuGet Package From Project After Each Build" package, this file will not be updated unless you provide the "-FileConflictAction Overwrite" parameter 
#		when installing. Also, if you do this then your custom changes will be lost. It might be easiest to backup the file, uninstall the package, delete the left-over file,
#		reinstall the package, and then re-apply your custom changes.
#==========================================================
param ([string]$ProjectFilePath, [string]$OutputDirectory, [string]$Configuration, [string]$Platform)
$THIS_SCRIPTS_DIRECTORY = Split-Path $script:MyInvocation.MyCommand.Path

# The Configuration and Platform get passed in the format "Key=Value", so strip out the Value as that's all we want.
$Configuration = $Configuration -ireplace ".*?=", ""
$Platform = $Platform -ireplace ".*?=", ""

# Make sure the OutputDirectory does not end in a trailing backslash, as it will mess up nuget.exe's parameter parsing.
$OutputDirectory = $OutputDirectory.TrimEnd('\')

#################################################
# Users May Edit The Following Variables.
#################################################

# Specify the version number to use for the NuGet package. If not specified the version number of the assembly being packed will be used.
$versionNumber = ""

# Specify any release notes for this package. 
# These will only be included in the package if you have a .nuspec file for the project in the same directory as the project file.
$releaseNotes = ""

# Make sure we build and pack the assemblies of the currently selected Configuration (e.g. Debug, Release) and Platform (e.g. x86, x64, Any CPU).
# If you want to force your NuGet package to always be built with a specific Configuration and Platform, change "$Configuration" and "$Platform" below to the desired values.
#	e.g. $packProperties = "Configuration=""Release"";Platform=""Any CPU"";"
$packProperties = "Configuration=""$Configuration"";Platform=""$Platform"";"

# Specify any additional NuGet Pack Properties to pass to MsBuild. e.g. "TargetFrameworkVersion=v3.5;Optimize=true"
# Do not specify the "Configuration" or "Platform" here (use $packProperties above).
# MsBuild Properties that can be specified: http://msdn.microsoft.com/en-us/library/vstudio/bb629394.aspx
$additionalPackProperties = ""

# Specify any additional NuGet Pack options to pass to nuget.exe.
# Do not specify a "-Version" (use $versionNumber above), "-OutputDirectory", or "-NonInteractive", as these are already provided.
# Do not specify any "-Properties" here; instead use the $packProperties variable below.
# Do not specify "-Build", as this may result in an infinite build loop.
$additionalPackOptions = ""

#################################################
# Do Not Edit Anything Past This Point (except to add the "-Verbose" flag to the end of the last line for troubleshooting purposes).
#################################################

# Join the user's custom pack Properties with our default ones.
$packProperties = ($packProperties + $additionalPackProperties).TrimEnd(';')

# Create the new NuGet package.
& "$THIS_SCRIPTS_DIRECTORY\New-NuGetPackage.ps1" -ProjectFilePath "$ProjectFilePath" -VersionNumber $versionNumber -ReleaseNotes $releaseNotes -PackOptions "-OutputDirectory ""$OutputDirectory"" -Properties $packProperties -NonInteractive $additionalPackOptions" -DoNotUpdateNuSpecFile -NoPrompt -Verbose