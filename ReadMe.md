# New-NuGetPackage PowerShell Script Description

[New-NuGetPackage.ps1][New-NuGetPackageFileUrl] is a PowerShell script to make creating and publishing NuGet packages quick and easy, using a .nuspec or project file, from Explorer or PS.

This script is also used by a NuGet Package that you can use to [automate making your project's NuGet packages in Visual Studio](docs/NuGetPackageToCreateANuGetPackageFromYourProjectAfterEveryBuild.md).

__This script depends on [nuget.exe][NuGetExeReleasesUrl]__, and it is recommended that you [add nuget to your PATH](docs/AddNuGetExeToYourPath.md).


## Features

* The script uses nuget.exe to pack a .nuspec or project file (.csproj, .vbproj, .fsproj) and optionally push it to a NuGet gallery.
* Can be ran from PowerShell or directly from Windows Explorer (e.g. double-click it, or right-click -> Run with PowerShell).
* If no parameters are provided the user will be prompted for:
  * the .nuspec or project file to pack, or package to push (if one can't be found automatically)
  * the version number and release notes to use for the package (if a .nuspec file is used)
  * whether the package should be pushed to a NuGet gallery or not.
* Parameters may be provided to supply these values and/or suppress the prompts, so it can be integrated into your build system.

The script provides parameters for the Pack and Push Options, which will be passed as-is to nuget.exe, allowing for all of the same functionality as calling nuget.exe directly yourself.


## Getting Started Quickly

Here are a couple examples of how to run the script from PowerShell to have the GUI prompt you for the required parameters:

```PowerShell
& .\New-NuGetPackage.ps1    # Can use relative path when in same directory as the script.
& "C:\Some Folder\New-NuGetPackage.ps1"   # Use absolute path to run script from anywhere.
```

Below are some examples of calling the script with parameters to avoid the GUI prompts. For more information on the script and its parameters, [check out the documentation](docs/HowToUseTheNewNuGetPackagePowerShellScript.md).

```PowerShell
& ".\New-NuGetPackage.ps1" -NuSpecFilePath ".\Some Folder\SomeNuSpecFile.nuspec"
```

```PowerShell
& .\New-NuGetPackage.ps1 -ProjectFilePath "C:\Some Folder\TestProject.csproj" -VersionNumber "1.1" -ReleaseNotes "Version 1.1 contains many bug fixes."
```

```PowerShell
& .\New-NuGetPackage.ps1 -ProjectFilePath "C:\Some Folder\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""C:\Output""" -UsePowerShellPrompts
```

```PowerShell
& .\New-NuGetPackage.ps1 -NuSpecFilePath "C:\Some Folder\SomeNuSpecFile.nuspec" -NoPrompt
```

```PowerShell
& .\New-NuGetPackage.ps1 -NuSpecFilePath ".\Some Folder\SomeNuSpecFile.nuspec" -VersionNumber "9.9.9.9" -DoNotUpdateNuSpecFile
```

```PowerShell
& .\New-NuGetPackage.ps1 -PushPackageToNuGetGallery -PushOptions "-Source ""http://my.server.com/MyNuGetGallery"" -ApiKey ""EAE1E980-5ECB-4453-9623-F0A0250E3A57"""
```

```PowerShell
& .\New-NuGetPackage.ps1 -NuGetExecutableFilePath "C:\Utils\NuGet.exe"
```

```PowerShell
& .\New-NuGetPackage.ps1 -PackageFilePath "C:\Some Folder\MyPackage.nupkg"
```

<!-- Links -->
[NuGetExeReleasesUrl]: https://github.com/NuGet/Home/releases
[New-NuGetPackageFileUrl]: https://github.com/deadlydog/New-NuGetPackage/blob/master/src/New-NuGetPackage.ps1