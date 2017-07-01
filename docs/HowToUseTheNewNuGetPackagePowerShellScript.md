# How To Use The New-NuGetPackage PowerShell Script


## Prerequisites

1. You have [downloaded the nuget executable](https://github.com/NuGet/Home/releases), and (optionally) [add it to your PATH](AddNuGetExeToYourPath.md).
	* In order to run the script from Windows Explorer, nuget.exe must be added to your PATH or in the same directory as the New-NuGetPackage.ps1 file.
1. You have [changed your system's PowerShell Execution Policy](CheckAndChangePowerShellsExecutionPolicy.md) to allow PowerShell scripts to be run.
1. You have at least PowerShell v2.0.  [Check which PowerShell version you have](CheckWhichVersionOfPowerShellYouHaveInstalled.md).


## Create Your .nuspec File (Optional)

If you are not packing a project file (i.e. .csproj, .vbproj, .fsproj), or want to customize the packages information or contents, you will want to [create a .nuspec file for your package](CreateANuspecFileForYourPackage.md).


## Running The Script

You can run the New-NuGetPackage.ps1 script a few different ways:

1. Run it from Windows Explorer by double-clicking it.
	* If it opens the file for editing, instead of double-clicking the file you will need to right-click it and choose Open With -> Windows PowerShell.
	* If the script is not in the same directory as a .nuspec or project file, or there are many .nuspec/project files, it will prompt you for the .nuspec/project file to use.
1. Call the script from PowerShell, passing in any desired parameters.
1. If you want to be able to easily run the script from Windows Explorer, but need to specify some parameters, you can create another PowerShell script (or batch file) that simply calls the New-NuGetPackage.ps1 script with the parameters specified, and then run that script from Windows Explorer. [See this post](http://blog.danskingdom.com/fix-problem-where-windows-powershell-cannot-run-script-whose-path-contains-spaces/) for how to run the script from Windows Explorer when the path contains spaces.

Use the following syntax to call the script from PowerShell:

```PowerShell
& .\New-NuGetPackage.ps1    # Can use relative path when in same directory as the script.
& "C:\Some Folder\New-NuGetPackage.ps1"   # Use absolute path to run script from anywhere.

# Store script path in a variable and run it using the variable (ideal if running script more than once).
$NewNuGetPackageScriptPath = "C:\Some Folder\New-NuGetPackage.ps1"
& $NewNuGetPackageScriptPath
```


## Create Package On Every Successful Build

This script makes it super easy to [create a new NuGet package from your project every time your project is built](NuGetPackageToCreateANuGetPackageFromYourProjectAfterEveryBuild.md).


## Script Parameters And Documentation

Use `Get-Help '.\New-NuGetPackage.ps1' -Detailed` to get the cmdlet's full documentation for the version of the script you are using, or [check the source code for the latest documentation](../src/New-NuGetPackage.ps1).
