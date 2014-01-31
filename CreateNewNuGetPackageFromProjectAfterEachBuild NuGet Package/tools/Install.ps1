param($installPath, $toolsPath, $package, $project)

# Edits the project's packages.config file to make sure the reference to the given package uses the developmentDependency="true" attribute.
function Set-PackageToBeDevelopmentDependency($PackageId, $ProjectDirectoryPath)
{
    function Get-XmlNamespaceManager([xml]$XmlDocument, [string]$NamespaceURI = "")
    {
        # If a Namespace URI was not given, use the Xml document's default namespace.
	    if ([string]::IsNullOrEmpty($NamespaceURI)) { $NamespaceURI = $XmlDocument.DocumentElement.NamespaceURI }	
	
	    # In order for SelectSingleNode() to actually work, we need to use the fully qualified node path along with an Xml Namespace Manager, so set them up.
	    [System.Xml.XmlNamespaceManager]$xmlNsManager = New-Object System.Xml.XmlNamespaceManager($XmlDocument.NameTable)
	    $xmlNsManager.AddNamespace("ns", $NamespaceURI)
        return ,$xmlNsManager		# Need to put the comma before the variable name so that PowerShell doesn't convert it into an Object[].
    }

    function Get-FullyQualifiedXmlNodePath([string]$NodePath, [string]$NodeSeparatorCharacter = '.')
    {
        return "/ns:$($NodePath.Replace($($NodeSeparatorCharacter), '/ns:'))"
    }

    function Get-XmlNodes([xml]$XmlDocument, [string]$NodePath, [string]$NamespaceURI = "", [string]$NodeSeparatorCharacter = '.')
    {
	    $xmlNsManager = Get-XmlNamespaceManager -XmlDocument $XmlDocument -NamespaceURI $NamespaceURI
	    [string]$fullyQualifiedNodePath = Get-FullyQualifiedXmlNodePath -NodePath $NodePath -NodeSeparatorCharacter $NodeSeparatorCharacter

	    # Try and get the nodes, then return them. Returns $null if no nodes were found.
	    $nodes = $XmlDocument.SelectNodes($fullyQualifiedNodePath, $xmlNsManager)
	    return $nodes
    }

    # Get the path to the project's packages.config file.
    Write-Debug "Project directory is '$ProjectDirectoryPath'."
    $packagesConfigFilePath = Join-Path $ProjectDirectoryPath "packages.config"

    # If we found the packages.config file, try and update it.
    if (Test-Path -Path $packagesConfigFilePath)
    {
        Write-Debug "Found packages.config file at '$packagesConfigFilePath'."
    
        # Load the packages.config xml document and grab all of the <package> elements.
        $xmlFile = New-Object System.Xml.XmlDocument
        $xmlFile.Load($packagesConfigFilePath)
        $packageElements = Get-XmlNodes -XmlDocument $xmlFile -NodePath "packages.package"

        Write-Debug "Packages.config contents before modification are:`n$($xmlFile.InnerXml)"

        if (!($packageElements))
        {
            Write-Debug "Could not find any <package> elements in the packages.config xml file '$packagesConfigFilePath'."
            return
        }
    
        # Add the developmentDependency attribute to the NuGet package's entry.
        $packageElements | Where-Object { $_.id -eq $PackageId } | ForEach-Object { $_.SetAttribute("developmentDependency", "true") }

        # Save the packages.config file back now that we've changed it.
        $xmlFile.Save($packagesConfigFilePath)
    }
    # Else we coudn't find the packages.config file for some reason, so error out.
    else
    {
        Write-Debug "Could not find packages.config file at '$packagesConfigFilePath'."
    }
}

# Set this NuGet Package to be installed as a Development Dependency.
Set-PackageToBeDevelopmentDependency -PackageId $package.Id -ProjectDirectoryPath ([System.IO.Directory]::GetParent($project.FullName))

# Get the current Post-Build Event text.
$postBuildEventText = $project.Properties.Item(“PostBuildEvent”).Value

# If there is already a call to the powershell script in the post build event, then just exit.
if ($postBuildEventText -match "New-NuGetPackage.ps1")
{
    Write-Verbose "New-NuGetPackage.ps1 is already referenced in the Post-Build Event, so not updating post-build event code."
	return
}

# Define the Post-Build Event Code to add.
$postBuildEventCode = @'
REM Create a NuGet package for this project and place the .nupkg file in the project's output directory.
ECHO Building NuGet package in Post-Build event...
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '$(ProjectDir)PostBuildScripts\BuildNewPackage-RanAutomatically.ps1' -ProjectFilePath '$(ProjectPath)' -OutputDirectory '$(TargetDir)' -Configuration '$(ConfigurationName)' -Platform '$(PlatformName)'"
'@

# Add the Post-Build Event Code to the project and save it (prepend a couple newlines in case there is existing Post Build Event text).
$postBuildEventText += "`n`r`n`r$postBuildEventCode"
$project.Properties.Item(“PostBuildEvent”).Value = $postBuildEventText.Trim()
$project.Save()