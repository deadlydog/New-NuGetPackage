# Creating A .nuspec File For Your Project


## Why Use A .nuspec File

Using a .nuspec file allows you to customize your package more than simply packing a project file directly.  It allows you to add additional information to your package, such as tags, release notes, a license URL, etc., and to include additional files in your package.

Below I show you how to quickly create a .nuspec file for your project.  For more information on .nuspec files see the NuGet's [Nuspec Reference page](http://docs.nuget.org/docs/reference/nuspec-reference), and their [page on creating new packages](http://docs.nuget.org/docs/creating-packages/creating-and-publishing-a-package).


## Create A .nuspec File

There are a couple different ways to create a .nuspec file, both of which involve running nuget.exe from a command prompt.

Once the .nuspec file has been generated, make the desired changes to it and save it before running the New-NuGetPackage.ps1 script against it.

### Option 1: Spec a project or dll file directly

Command to run: `nuget spec "C:\Path To\FileToSpec.csproj"`

This would create `FileToSpec.csproj.nuspec` with some invalid placeholder contents that would need to be updated before packing (e.g. the id is not valid, and the SampleDependency does not exist.):

```Xml
<?xml version="1.0"?>
<package >
  <metadata>
    <id>C:\Path To\File.csproj</id>
    <version>1.0.0</version>
    <authors>Dan Schroeder</authors>
    <owners>Dan Schroeder</owners>
    <licenseUrl>http://LICENSE_URL_HERE_OR_DELETE_THIS_LINE</licenseUrl>
    <projectUrl>http://PROJECT_URL_HERE_OR_DELETE_THIS_LINE</projectUrl>
    <iconUrl>http://ICON_URL_HERE_OR_DELETE_THIS_LINE</iconUrl>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <description>Package description</description>
    <releaseNotes>Summary of changes made in this release of the package.</releaseNotes>
    <copyright>Copyright 2013</copyright>
    <tags>Tag1 Tag2</tags>
    <dependencies>
      <dependency id="SampleDependency" version="1.0" />
    </dependencies>
  </metadata>
</package>
```

### Option 2: Create a tokenized .nuspec file from a project file

First navigate to the folder containing the project file, and then run the command.
Command to run: `nuget spec`

This would create a tokenized .nuspec file, where the tokens (e.g. $id$) will the value from the project at pack time.  If we ran the command in a directory that contained "MyProject.csproj", it would generate "MyProject.nuspec" with contents:

```Xml
<?xml version="1.0"?>
<package >
  <metadata>
    <id>$id$</id>
    <version>$version$</version>
    <title>$title$</title>
    <authors>$author$</authors>
    <owners>$author$</owners>
    <licenseUrl>http://LICENSE_URL_HERE_OR_DELETE_THIS_LINE</licenseUrl>
    <projectUrl>http://PROJECT_URL_HERE_OR_DELETE_THIS_LINE</projectUrl>
    <iconUrl>http://ICON_URL_HERE_OR_DELETE_THIS_LINE</iconUrl>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <description>$description$</description>
    <releaseNotes>Summary of changes made in this release of the package.</releaseNotes>
    <copyright>Copyright 2013</copyright>
    <tags>Tag1 Tag2</tags>
  </metadata>
</package>
```
