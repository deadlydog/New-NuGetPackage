# Prerequisites
# You have [downloaded the nuget executable](https://nuget.codeplex.com/releases/view/58939), and (optionally) [it has been added to your PATH](Add-NuGet.exe-To-Your-PATH).
	* In order to run the script from Windows Explorer, nuget.exe must be added to your PATH or in the same directory as the New-NuGetPackage.ps1 file.
# You have [changed your system's PowerShell Execution Policy](Change-PowerShell's-Execution-Policy) to allow PowerShell scripts to be run.
# You have at least PowerShell v2.0.  [Check which PowerShell version you have](Check-Which-Version-Of-PowerShell-You-Have-Installed).

# Create Your .nuspec File (Optional)
If you are not packing a project file (i.e. .csproj, .vbproj, .fsproj), or want to customize the packages information or contents, you will want to [ create a .nuspec file for your package](Create-A-.nuspec-File-For-Your-Package).

# Running The Script
You can run the New-NuGetPackage.ps1 script a few different ways:
# Run it from Windows Explorer by double-clicking it.
	* If it opens the file for editing, instead of double-clicking the file you will need to right-click it and choose Open With -> Windows PowerShell.
	* If the script is not in the same directory as a .nuspec or project file, or there are many .nuspec/project files, it will prompt you for the .nuspec/project file to use.
# Call the script from PowerShell, passing in any desired parameters.
# If you want to be able to easily run the script from Windows Explorer, but need to specify some parameters, you can create another PowerShell script (or batch file) that simply calls the New-NuGetPackage.ps1 script with the parameters specified, and then run that script from Windows Explorer.
[See this post](http://blog.danskingdom.com/fix-problem-where-windows-powershell-cannot-run-script-whose-path-contains-spaces/) for how to run the script from Windows Explorer when the path contains spaces.

Use the following syntax to call the script from PowerShell:
{{
& .\New-NuGetPackage.ps1    # Can use relative path when in same directory as the script.
& "C:\Some Folder\New-NuGetPackage.ps1"   # Use absolute path to run script from anywhere.

# Store script path in a variable and run it using the variable (ideal if running script more than once).
$NewNuGetPackageScriptPath = "C:\Some Folder\New-NuGetPackage.ps1"
& $NewNuGetPackageScriptPath 
}}
# Create Package On Every Successful Build
This script makes it super easy to [create a new NuGet package from your project every time your project is built](NuGet-Package-To-Create-A-NuGet-Package-From-Your-Project-After-Every-Build).

# Script Parameters And Documentation
Use "Get-Help '.\New-NuGetPackage.ps1' -Detailed" to get the cmdlet's documentation:

	.SYNOPSIS
	Creates a NuGet Package (.nupkg) file from the given Project or NuSpec file, and optionally uploads it to a NuGet Gallery.
	
	.DESCRIPTION
	Creates a NuGet Package (.nupkg) file from the given Project or NuSpec file.
	Additional parameters may be provided to also upload the new NuGet package to a NuGet Gallery.
    If an "-OutputDirectory" is not provided via the PackOptions parameter, the default is to place the .nupkg file in a "New-NuGetPackages" directory in the same directory as the .nuspec or project file being packed.
    If a NuGet Package file is specified (rather than a Project or NuSpec file), we will simply push that package to the NuGet Gallery.
	
	.PARAMETER NuSpecFilePath
	The path to the .nuspec file to pack.
	If you intend to pack a project file that has an accompanying .nuspec file, use the ProjectFilePath parameter instead.

	.PARAMETER ProjectFilePath
	The path to the project file (e.g. .csproj, .vbproj, .fsproj) to pack.
	If packing a project file that has an accompanying .nuspec file, the nuspec file will automatically be picked up by the NuGet executable.

    .PARAMETER PackageFilePath
    The path to the NuGet package file (.nupkg) to push to the NuGet gallery.
    If provided a new package will not be created; we will simply push to specified NuGet package to the NuGet gallery.

	.PARAMETER VersionNumber
	The version number to use for the NuGet package.
	The version element in the .nuspec file (if available) will be updated with the given value unless the DoNotUpdateNuSpecFile switch is provided.
	If this parameter is not provided then you will be prompted for the version number to use (unless the NoPrompt or NoPromptForVersionNumber switch is provided).
	If the "-Version" parameter is provided in the PackOptions, that version will be used for the NuGet package, but this version will be used to update the .nuspec file (if available).

	.PARAMETER ReleaseNotes
	The release notes to use for the NuGet package.
	The release notes element in the .nuspec file (if available) will be updated with the given value unless the DoNotUpdateNuSpecFile switch is provided.
	
	.PARAMETER PackOptions
	The arguments to pass to NuGet's Pack command. These will be passed to the NuGet executable as-is, so be sure to follow the NuGet's required syntax.	
	By default this is set to "-Build" in order to be able to create a package from a project that has not been manually built yet.
	See http://docs.nuget.org/docs/reference/command-line-reference for valid parameters.

	.PARAMETER PushPackageToNuGetGallery
	If this switch is provided the NuGet package will be pushed to the NuGet gallery.
	Use the PushOptions to specify a custom gallery to push to, or an API key if required.

	.PARAMETER PushOptions
	The arguments to pass to NuGet's Push command. These will be passed to the NuGet executable as-is, so be sure to follow the NuGet's required syntax.	
	See http://docs.nuget.org/docs/reference/command-line-reference for valid parameters.

    .PARAMETER DeletePackageAfterPush
    If this switch is provided and the package is successfully pushed to a NuGet gallery, the NuGet package file will then be deleted.
	
	.PARAMETER NoPrompt
	If this switch is provided the user will not be prompted for the version number or release notes; the current ones in the .nuspec file will be used (if available).
	The user will not be prompted for any other form of input either, such as if they want to push the package to a gallery, or to give input before the script exits when an error occurs.
    This parameter should be provided when an automated mechanism is running this script (e.g. an automated build system).
	
	.PARAMETER NoPromptExceptOnError
	The same as NoPrompt except if an error occurs the user will be prompted for input before the script exists, making sure they are notified that an error occurred.
	If both this and the NoPrompt switch are provided, the NoPrompt switch will be used.
	If both this and the NoPromptForInputOnError switch are provided, it is the same as providing the NoPrompt switch.
	
	.PARAMETER NoPromptForVersionNumber
	If this switch is provided the user will not be prompted for the version number; the one in the .nuspec file will be used (if available).
	
	.PARAMETER NoPromptForReleaseNotes
	If this switch is provided the user will not be prompted for the release notes; the ones in the .nuspec file will be used (if available).
	
	.PARAMETER NoPromptForPushPackageToNuGetGallery
	If this switch is provided the user will not be asked if they want to push the new package to the NuGet Gallery when the PushPackageToNuGetGallery switch is not provided.	
	
	.PARAMETER NoPromptForInputOnError
	If this switch is provided the user will not be prompted for input before the script exits when an error occurs, so they may not notice than an error occurred.	
	
	.PARAMETER UsePowerShellPrompts
	If this switch is provided any prompts for user input will be made via the PowerShell console, rather than the regular GUI components.
	This may be preferable when attempting to pipe input into the cmdlet.
	
	.PARAMETER DoNotUpdateNuSpecFile
	If this switch is provided a backup of the .nuspec file (if available) will be made, changes will be made to the original .nuspec file in order to 
	properly perform the pack, and then the original file will be restored once the pack is complete.

	.PARAMETER NuGetExecutableFilePath
	The full path to NuGet.exe.
	If not provided it is assumed that NuGet.exe is in the same directory as this script, or that NuGet.exe has been added to your PATH and can be called directly from the command prompt.

	.PARAMETER UpdateNuGetExecutable
	If this switch is provided "NuGet.exe update -self" will be performed before packing or pushing anything.
	Provide this switch to ensure your NuGet executable is always up-to-date on the latest version.

	.EXAMPLE
	& .\New-NuGetPackage.ps1

	Run the script without any parameters (e.g. as if it was ran directly from Windows Explorer).
	This will prompt the user for a .nuspec, project, or .nupkg file if one is not found in the same directory as the script, as well as for any other input that is required.
	This assumes that you are currently in the same directory as the New-NuGetPackage.ps1 script, since a relative path is supplied.

	.EXAMPLE
	& "C:\Some Folder\New-NuGetPackage.ps1" -NuSpecFilePath ".\Some Folder\SomeNuSpecFile.nuspec" -Verbose

	Create a new package from the SomeNuSpecFile.nuspec file.
	This can be ran from any directory since an absolute path to the New-NuGetPackage.ps1 script is supplied.
	Additional information will be displayed about the operations being performed because the -Verbose switch was supplied.
	
	.EXAMPLE
	& .\New-NuGetPackage.ps1 -ProjectFilePath "C:\Some Folder\TestProject.csproj" -VersionNumber "1.1" -ReleaseNotes "Version 1.1 contains many bug fixes."

	Create a new package from the TestProject.csproj file.
	Because the VersionNumber and ReleaseNotes parameters are provided, the user will not be prompted for them.
	If "C:\Some Folder\TestProject.nuspec" exists, it will automatically be picked up and used when creating the package; if it contained a version number or release notes, they will be overwritten with the ones provided.

	.EXAMPLE
	& .\New-NuGetPackage.ps1 -ProjectFilePath "C:\Some Folder\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""C:\Output""" -UsePowerShellPrompts

	Create a new package from the TestProject.csproj file, building the project before packing it and saving the  package in "C:\Output".
	Because the UsePowerShellPrompts parameter was provided, all prompts will be made via the PowerShell console instead of GUI popups.
	
	.EXAMPLE
	& .\New-NuGetPackage.ps1 -NuSpecFilePath "C:\Some Folder\SomeNuSpecFile.nuspec" -NoPrompt
	
	Create a new package from SomeNuSpecFile.nuspec without prompting the user for anything, so the existing version number and release notes in the .nuspec file will be used.
	
	.EXAMPLE	
	& .\New-NuGetPackage.ps1 -NuSpecFilePath ".\Some Folder\SomeNuSpecFile.nuspec" -VersionNumber "9.9.9.9" -DoNotUpdateNuSpecFile
	
	Create a new package with version number "9.9.9.9" from SomeNuSpecFile.nuspec without saving the changes to the file.
	
	.EXAMPLE
	& .\New-NuGetPackage.ps1 -NuSpecFilePath "C:\Some Folder\SomeNuSpecFile.nuspec" -PushPackageToNuGetGallery -PushOptions "-Source ""http://my.server.com/MyNuGetGallery"" -ApiKey ""EAE1E980-5ECB-4453-9623-F0A0250E3A57"""
	
	Create a new package from SomeNuSpecFile.nuspec and push it to a custom NuGet gallery using the user's unique Api Key.
	
	.EXAMPLE
	& .\New-NuGetPackage.ps1 -NuSpecFilePath "C:\Some Folder\SomeNuSpecFile.nuspec" -NuGetExecutableFilePath "C:\Utils\NuGet.exe"

	Create a new package from SomeNuSpecFile.nuspec by specifying the path to the NuGet executable (required when NuGet.exe is not in the user's PATH).

    .EXAMPLE
    & New-NuGetPackage.ps1 -PackageFilePath "C:\Some Folder\MyPackage.nupkg"

    Push the existing "MyPackage.nupkg" file to the NuGet gallery.
    User will be prompted to confirm that they want to push the package; to avoid this prompt supply the -PushPackageToNuGetGallery switch.

	.EXAMPLE
	& .\New-NuGetPackage.ps1 -NoPromptForInputOnError -UpdateNuGetExecutable

	Create a new package or push an existing package by auto-finding the .nuspec, project, or .nupkg file to use, and prompting for one if none are found.
	Will not prompt the user for input before exitting the script when an error occurs.

	.OUTPUTS
	Returns the full path to the NuGet package that was created.
	If a NuGet package was not required to be created (e.g. you were just pushing an existing package), then nothing is returned.
	Use the -Verbose switch to see more detailed information about the operations performed.
	
	.LINK
	Project home: https://newnugetpackage.codeplex.com

	.NOTES
	Author: Daniel Schroeder
	Version: 1.5.0
	
	This script is designed to be called from PowerShell or ran directly from Windows Explorer.
	If this script is ran without the $NuSpecFilePath, $ProjectFilePath, and $PackageFilePath parameters, it will automatically search for a .nuspec, project, or package file in the 
	same directory as the script and use it if one is found. If none or more than one are found, the user will be prompted to specify the file to use.

