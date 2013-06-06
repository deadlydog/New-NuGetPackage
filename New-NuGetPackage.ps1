<#
	.SYNOPSIS
	Creates a NuGet Package (.nupkg) file from the given Project or NuSpec file, and optionally uploads it to a NuGet Gallery.
	
	.DESCRIPTION
	Creates a NuGet Package (.nupkg) file from the given Project or NuSpec file.
	Additional parameters may be provided to also upload the new NuGet package to a NuGet Gallery.
	
	.PARAMETER NuSpecFilePath
	The path to the .nuspec file to pack.
	If you intend to pack a project file that has an accompanying .nuspec file, use the ProjectFilePath parameter instead.

	.PARAMETER ProjectFilePath
	The path to the project file (e.g. .csproj, .vbproj, .fsproj) to pack.
	If packing a project file that has an accompanying .nuspec file, the nuspec file will automatically be picked up by the nuget executable.

	.PARAMETER VersionNumber
	The version number to use for the nuget package.
	The version element in the .nuspec file (if available) will be updated with the given value unless the DoNotUpdateNuSpecFile switch is provided.
	If this parameter is not provided then you will be prompted for the version number to use (unless the NoPrompt or NoPromptForVersionNumber switch is provided).
	If the "-Version" parameter is provided in the PackOptions, that version will be used for the nuget package, but this version will be used to update the .nuspec file (if available).

	.PARAMETER ReleaseNotes
	The release notes to use for the nuget package.
	The release notes element in the .nuspec file (if available) will be updated with the given value unless the DoNotUpdateNuSpecFile switch is provided.
	
	.PARAMETER PackOptions
	The arguments to pass to NuGet's Pack command. These will be passed to the nuget executable as-is, so be sure to follow the nuget's required syntax.	
	By default this is set to "-Build" in order to be able to create a package from a project that has not been manually built yet.
	See http://docs.nuget.org/docs/reference/command-line-reference for valid parameters.

	.PARAMETER PushPackageToNuGetGallery
	If this switch is provided the nuget package will be pushed to the nuget gallery.
	Use the PushOptions to specify a custom gallery to push to, or an API key if required.

	.PARAMETER PushOptions
	The arguments to pass to NuGet's Push command. These will be passed to the nuget executable as-is, so be sure to follow the nuget's required syntax.	
	See http://docs.nuget.org/docs/reference/command-line-reference for valid parameters.
	
	.PARAMETER NoPrompt
	If this switch is provided the user will not be prompted for the version number or release notes; the current ones in the .nuspec file will be used (if available).
	They will not be prompted for any other form of input either, such as if they want to push the package to a gallery, or to give input before the script exits when an error occurs.
	
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
	If not provided it is assumed that NuGet.exe has been added to your PATH and can be called directly from the command prompt.

	.EXAMPLE
	& .\New-NuGetPackage.ps1

	Run the script without any parameters (e.g. as if it was ran directly from Windows Explorer).
	This will prompt the user for a .nuspec or project file if one is not found in the same directory as the script, as well as for any other input that is required.
	This assumes that you are currently in the same directory as the New-NuGetPackage.ps1 script, since a relative path is supplied.

	.EXAMPLE
	& "C:\Some Folder\New-NuGetPackage.ps1" -NuSpecFilePath ".\Some Folder\SomeNuSpecFile.nuspec"

	Create a new package from the SomeNuSpecFile.nuspec file.
	This can be ran from any directory since an absolute path to the New-NuGetPackage.ps1 script is supplied.
	
	.EXAMPLE
	& .\New-NuGetPackage.ps1 -ProjectFilePath "C:\Some Folder\TestProject.csproj" -VersionNumber "1.1" -ReleaseNotes "Version 1.1 contains many bug fixes."

	Create a new package from the TestProject.csproj file.
	Because the VersionNumber and ReleaseNotes parameters are provided, the user will not be prompted for them.
	If "C:\Some Folder\TestProject.nuspec" exists, it will automatically be picked up and used when creating the package; if it contained a version number or release notes, they will be overwritten with the ones provided.

	.EXAMPLE
	& .\New-NuGetPackage.ps1 -ProjectFilePath "C:\Some Folder\TestProject.csproj" -PackOptions "-Build -OutputDirectory ""C:\Output""" -UsePowerShellPrompts

	Create a new package from the TestProject.csproj file, building the project before packing it and saving the nuget package in "C:\Output".
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

	Create a new package from SomeNuSpecFile.nuspec by specifying the path to the NuGet executable (required when nuget.exe is not in the user's PATH).

	.EXAMPLE
	& .\New-NuGetPackage.ps1 -NoPromptForInputOnError

	Create a new package by auto-finding the .nuspec or project file to use, and prompting for one if none are found.
	Will not prompt the user for input before exitting the script when an error occurs.

	.LINK
	Project home: https://newnugetpackage.codeplex.com

	.NOTES
	Author: Daniel Schroeder
	Version: 1.0
	
	This script is designed to be called from PowerShell or ran directly from Windows Explorer.
	If this script is ran without the $NuSpecFilePath and $ProjectFilePath parameters, it will automatically search for a .nuspec or project file in the 
	same directory as the script and use it if one is found. If none or more than one are found, the user will be prompted to specify the file to use.
#>
[CmdletBinding(DefaultParameterSetName="PackUsingNuSpec")]
param
(
	[parameter(Position=1,Mandatory=$false,ParameterSetName="PackUsingNuSpec")]
	[ValidateScript({Test-Path $_ -PathType Leaf})]
	[string] $NuSpecFilePath,

	[parameter(Position=1,Mandatory=$false,ParameterSetName="PackUsingProject")]
	[ValidateScript({Test-Path $_ -PathType Leaf})]
	[string] $ProjectFilePath,

	[parameter(Position=2,Mandatory=$false,HelpMessage="The new version number to use for the NuGet Package.")]
	[ValidatePattern('(?i)(^(\d{1,5}(\.\d{1,5}){1,3})|(\$version\$)$)')]	# This validation is duplicated in the UpdateNuSpecFile function, so update it in both places.
	[Alias("Version")]
	[Alias("V")]
	[string] $VersionNumber,

	[Alias("Notes")]
	[string] $ReleaseNotes,
	
	[Alias("PackP")]
	[string] $PackOptions = "-Build",	# Build projects by default to make sure the files to pack exist.

	[Alias("Push")]
	[switch] $PushPackageToNuGetGallery,

	[Alias("PushP")]
	[string] $PushOptions,
	
	[Alias("NP")]
	[switch] $NoPrompt,
	
	[Alias("NPEOE")]
	[switch] $NoPromptExceptOnError,
	
	[Alias("NPFVN")]
	[switch] $NoPromptForVersionNumber,
	
	[Alias("NPFRN")]
	[switch] $NoPromptForReleaseNotes,
	
	[Alias("NPFPPTNG")]
	[switch] $NoPromptForPushPackageToNuGetGallery,
	
	[Alias("NPFIOE")]
	[switch] $NoPromptForInputOnError,
	
	[Alias("UPSP")]
	[switch] $UsePowerShellPrompts, 
	
	[Alias("NoUpdate")]
	[switch] $DoNotUpdateNuSpecFile,
	
	[Alias("NuGet")]
	[string] $NuGetExecutableFilePath = "nuget.exe"
)

# Turn on Strict Mode to help catch syntax-related errors.
# 	This must come after a script's/function's param section.
# 	Forces a function to be the first non-comment code to appear in a PowerShell Module.
Set-StrictMode -Version Latest

#==========================================================
# Define any necessary global variables, such as file paths.
#==========================================================

# Import any necessary assemblies.
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic

# Get the directory that this script is in.
$THIS_SCRIPTS_DIRECTORY = Split-Path $script:MyInvocation.MyCommand.Path

# The list of project type extensions that NuGet supports packing.
$VALID_NUGET_PROJECT_TYPE_EXTENSIONS_ARRAY = @(".csproj", ".vbproj", ".fsproj")

$VALID_NUGET_PROJECT_TYPE_EXTENSIONS_WITH_WILDCARD_ARRAY = @()
foreach ($extension in $VALID_NUGET_PROJECT_TYPE_EXTENSIONS_ARRAY)
{ 
	$VALID_NUGET_PROJECT_TYPE_EXTENSIONS_WITH_WILDCARD_ARRAY += "*$extension"
}

#==========================================================
# Define functions used by the script.
#==========================================================

# Catch any exceptions thrown, display the error message, wait for input if appropriate, and then stop the script.
trap [Exception] 
{
	$errorMessage = $_
	Write-Host "An error occurred while running New-NuGetPackage script:`n$errorMessage`n" -Foreground Red
	
	if (!$NoPromptForInputOnError)
	{
		# If we should prompt directly from Powershell.
		if ($UsePowershellPrompts)
		{
			Write-Host "Press any key to continue ..."
			$x = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
		}
		# Else use a nice GUI prompt.
		else
		{
			$VersionNumber = Read-MessageBoxDialog -Message $errorMessage -WindowTitle "Error Occurred Running New-NuGetPackage Script" -Buttons OK -Icon Error
		}
	}
	break
}

# Function to return if we should create the NuGet package from a Project (e.g. .csproj) or not.
function PackUsingProject
{
	return (!([string]::IsNullOrEmpty($ProjectFilePath)))
}

function BackupNuSpecFilePath { return "$NuSpecFilePath.backup" }

# Function to update the $NuSpecFilePath (.nuspec file) with the appropriate information before using it to create the NuGet package.
function UpdateNuSpecFile
{	
	# Try and check the file out of TFS (if not using TFS a warning will be thrown, but script will continue).
	Tfs-Checkout -Path $NuSpecFilePath
	
	# If we shouldn't update to the .nuspec file permanently, create a backup that we can restore from after.
	if ($DoNotUpdateNuSpecFile)
	{
		Copy-Item -Path $NuSpecFilePath -Destination (BackupNuSpecFilePath) -Force
	}

	# If an explicit Version Number was not provided, prompt for it.
	if ([string]::IsNullOrWhiteSpace($VersionNumber))
	{
		# Get the current version number from the .nuspec file.
		$currentVersionNumber = Get-NuSpecVersionNumber -NuSpecFilePath $NuSpecFilePath

		# If we shouldn't prompt for a version number, just use the existing one from the NuSpec file (if it exists).
		if ($NoPromptForVersionNumber)
		{
			$VersionNumber = $currentVersionNumber
		}
		# Else prompt the user for the version number to use.
		else
		{
			$promptMessage = 'Enter the NuGet package version number to use (x.x[.x.x] or $version$ if packing a project file)'
			
			# If we should prompt directly from Powershell.
			if ($UsePowershellPrompts)
			{
				$VersionNumber = Read-Host "$promptMessage. Current value in the .nuspec file is:`n$currentVersionNumber`n"
			}
			# Else use a nice GUI prompt.
			else
			{
				$VersionNumber = Read-InputBoxDialog -Message "$promptMessage`:" -WindowTitle "NuGet Package Version Number" -DefaultText $currentVersionNumber
			}
		}
		
		# The script's parameter validation does not seem to be enforced (probably because this is inside a function), so re-enforce it here.
		$rxVersionNumberValidation = [regex] '(?i)(^(\d{1,5}(\.\d{1,5}){1,3})|(\$version\$)$)'
		
		# If the user cancelled the prompt or did not provide a valid version number.
		if ([string]::IsNullOrWhiteSpace($VersionNumber) -or !$rxVersionNumberValidation.IsMatch($VersionNumber))
		{
			throw "A valid version number to use for the NuGet package was not provided."
		}
	}
	
	# Insert the given version number into the .nuspec file.
	Set-NuSpecVersionNumber -NuSpecFilePath $NuSpecFilePath -NewVersionNumber $VersionNumber
	
	# If the Release Notes were not provided, prompt for them.
	if ([string]::IsNullOrWhiteSpace($ReleaseNotes))
	{
		# Get the current release notes from the .nuspec file.
		$currentReleaseNotes = Get-NuSpecReleaseNotes -NuSpecFilePath $NuSpecFilePath
		
		# If we shouldn't prompt for the release notes, just use the existing ones from the NuSpec file (if it exists).
		if ($NoPromptForReleaseNotes)
		{
			$ReleaseNotes = $currentReleaseNotes
		}
		# Else prompt the user for the Release Notes to add to the .nuspec file.
		else
		{
			$promptMessage = "Please enter the release notes to include in the new NuGet package"
			
			# If we should prompt directly from Powershell.
			if ($UsePowershellPrompts)
			{
				$ReleaseNotes = Read-Host "$promptMessage. Current value in the .nuspec file is:`n$currentReleaseNotes`n"
			}
			# Else use a nice GUI prompt.
			else
			{
				$ReleaseNotes = Read-MultiLineInputBoxDialog -Message "$promptMessage`:" -WindowTitle "Enter Release Notes For New Package" -DefaultText $currentReleaseNotes
			}
		}		
	}
	
	# If the user cancelled the release notes prompt, exit the script.
	if ($ReleaseNotes -eq $null)
	{ 
		throw "User cancelled the Release Notes prompt, so exiting script."
	}

	# Insert the given Release Notes into the .nuspec file if some were provided.
	Set-NuSpecReleaseNotes -NuSpecFilePath $NuSpecFilePath -NewReleaseNotes $ReleaseNotes
}

function Get-NuSpecVersionNumber([parameter(Position=1,Mandatory)][ValidateScript({Test-Path $_ -PathType Leaf})][string] $NuSpecFilePath)
{	
	# Read in the file contents and return the version element's value.
	[xml]$fileContents = Get-Content -Path $NuSpecFilePath
	return Get-XmlElementsTextValue -XmlDocument $fileContents -ElementPath "package.metadata.version"
}

function Set-NuSpecVersionNumber([parameter(Position=1,Mandatory)][ValidateScript({Test-Path $_ -PathType Leaf})][string] $NuSpecFilePath, [parameter(Position=2,Mandatory)][string] $NewVersionNumber)
{	
	# Read in the file contents, update the version element's value, and save the file.
	[xml]$fileContents = Get-Content -Path $NuSpecFilePath
	Set-XmlElementsTextValue -XmlDocument $fileContents -ElementPath "package.metadata.version" -TextValue $NewVersionNumber
	$fileContents.Save($NuSpecFilePath)
}

function Get-NuSpecReleaseNotes([parameter(Position=1,Mandatory)][ValidateScript({Test-Path $_ -PathType Leaf})][string] $NuSpecFilePath)
{	
	# Read in the file contents and return the version element's value.
	[xml]$fileContents = Get-Content -Path $NuSpecFilePath
	return Get-XmlElementsTextValue -XmlDocument $fileContents -ElementPath "package.metadata.releaseNotes"
}

function Set-NuSpecReleaseNotes([parameter(Position=1,Mandatory)][ValidateScript({Test-Path $_ -PathType Leaf})][string] $NuSpecFilePath, [parameter(Position=2)][string] $NewReleaseNotes)
{
	# Read in the file contents, update the version element's value, and save the file.
	[xml]$fileContents = Get-Content -Path $NuSpecFilePath
	Set-XmlElementsTextValue -XmlDocument $fileContents -ElementPath "package.metadata.releaseNotes" -TextValue $NewReleaseNotes
	$fileContents.Save($NuSpecFilePath)
}

function Get-XmlNode([xml]$XmlDocument, [string]$NodePath, [string]$NamespaceURI = "", [string]$NodeSeparatorCharacter = '.')
{
	# If a Namespace URI was not given, use the Xml document's default namespace.
	if ([string]::IsNullOrEmpty($NamespaceURI)) { $NamespaceURI = $XmlDocument.DocumentElement.NamespaceURI }	
	
	# In order for SelectSingleNode() to actually work, we need to use the fully qualified node path along with an Xml Namespace Manager, so set them up.
	$xmlNsManager = New-Object System.Xml.XmlNamespaceManager($XmlDocument.NameTable)
	$xmlNsManager.AddNamespace("ns", $NamespaceURI)
	$fullyQualifiedNodePath = "/ns:$($NodePath.Replace($($NodeSeparatorCharacter), '/ns:'))"
	
	# Try and get the node, then return it. Returns $null if the node was not found.
	$node = $XmlDocument.SelectSingleNode($fullyQualifiedNodePath, $xmlNsManager)
	return $node
}

function Get-XmlElementsTextValue([xml]$XmlDocument, [string]$ElementPath, [string]$NamespaceURI = "", [string]$NodeSeparatorCharacter = '.')
{
	# Try and get the node.	
	$node = Get-XmlNode -XmlDocument $XmlDocument -NodePath $ElementPath -NamespaceURI $NamespaceURI -NodeSeparatorCharacter $NodeSeparatorCharacter
	
	# If the node already exists, return its value, otherwise return null.
	if ($node) { return $node.InnerText } else { return $null }
}

function Set-XmlElementsTextValue([xml]$XmlDocument, [string]$ElementPath, [string]$TextValue, [string]$NamespaceURI = "", [string]$NodeSeparatorCharacter = '.')
{
	# Try and get the node.	
	$node = Get-XmlNode -XmlDocument $XmlDocument -NodePath $ElementPath -NamespaceURI $NamespaceURI -NodeSeparatorCharacter $NodeSeparatorCharacter
	
	# If the node already exists, update its value.
	if ($node)
	{ 
		$node.InnerText = $TextValue
	}
	# Else the node doesn't exist yet, so create it with the given value.
	else
	{
		# Create the new element with the given value.
		$elementName = $ElementPath.Substring($ElementPath.LastIndexOf($NodeSeparatorCharacter) + 1)
 		$element = $XmlDocument.CreateElement($elementName, $XmlDocument.DocumentElement.NamespaceURI)		
		$textNode = $XmlDocument.CreateTextNode($TextValue)
		$element.AppendChild($textNode) > $null
		
		# Try and get the parent node.
		$parentNodePath = $ElementPath.Substring(0, $ElementPath.LastIndexOf($NodeSeparatorCharacter))
		$parentNode = Get-XmlNode -XmlDocument $XmlDocument -NodePath $parentNodePath -NamespaceURI $NamespaceURI -NodeSeparatorCharacter $NodeSeparatorCharacter
		
		if ($parentNode)
		{
			$parentNode.AppendChild($element) > $null
		}
		else
		{
			throw "$parentNodePath does not exist in the xml."
		}
	}
}

# Show an Open File Dialog and return the file selected by the user.
function Read-OpenFileDialog([string]$WindowTitle, [string]$InitialDirectory, [string]$Filter = "All files (*.*)|*.*", [switch]$AllowMultiSelect)
{  
	Add-Type -AssemblyName System.Windows.Forms
	$openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
	$openFileDialog.Title = $WindowTitle
	if (![string]::IsNullOrWhiteSpace($InitialDirectory)) { $openFileDialog.InitialDirectory = $InitialDirectory }
	$openFileDialog.Filter = $Filter
	if ($AllowMultiSelect) { $openFileDialog.MultiSelect = $true }
	$openFileDialog.ShowHelp = $true	# Without this line the ShowDialog() function may hang depending on system configuration and running from console vs. ISE.
	$openFileDialog.ShowDialog() > $null
	if ($AllowMultiSelect) { return $openFileDialog.Filenames } else { return $openFileDialog.Filename }
}

# Show message box popup and return the button clicked by the user.
function Read-MessageBoxDialog([string]$Message, [string]$WindowTitle, [System.Windows.Forms.MessageBoxButtons]$Buttons = [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]$Icon = [System.Windows.Forms.MessageBoxIcon]::None)
{
	Add-Type -AssemblyName System.Windows.Forms
	return [System.Windows.Forms.MessageBox]::Show($Message, $WindowTitle, $Buttons, $Icon)
}

# Show input box popup and return the value entered by the user.
function Read-InputBoxDialog([string]$Message, [string]$WindowTitle, [string]$DefaultText)
{
	Add-Type -AssemblyName Microsoft.VisualBasic
	return [Microsoft.VisualBasic.Interaction]::InputBox($Message, $WindowTitle, $DefaultText)
}

function Read-MultiLineInputBoxDialog([string]$Message, [string]$WindowTitle, [string]$DefaultText)
{
<#
	.SYNOPSIS
	Prompts the user with a multi-line input box and returns the text they enter, or null if they cancelled the prompt.
	
	.DESCRIPTION
	Prompts the user with a multi-line input box and returns the text they enter, or null if they cancelled the prompt.
	
	.PARAMETER Message
	The message to display to the user explaining what text we are asking them to enter.
	
	.PARAMETER WindowTitle
	The text to display on the prompt window's title.
	
	.PARAMETER DefaultText
	The default text to show in the input box.
	
	.EXAMPLE
	$userText = Read-MultiLineInputDialog "Input some text please:" "Get User's Input"
	
	Shows how to create a simple prompt to get mutli-line input from a user.
	
	.EXAMPLE
	# Setup the default multi-line address to fill the input box with.
	$defaultAddress = @'
	John Doe
	123 St.
	Some Town, SK, Canada
	A1B 2C3
	'@
	
	$address = Read-MultiLineInputDialog "Please enter your full address, including name, street, city, and postal code:" "Get User's Address" $defaultAddress
	if ($address -eq $null)
	{
		Write-Error "You pressed the Cancel button on the multi-line input box."
	}
	
	Prompts the user for their address and stores it in a variable, pre-filling the input box with a default multi-line address.
	If the user pressed the Cancel button an error is written to the console.
	
	.EXAMPLE
	$inputText = Read-MultiLineInputDialog -Message "If you have a really long message you can break it apart`nover two lines with the powershell newline character:" -WindowTitle "Window Title" -DefaultText "Default text for the input box."
	
	Shows how to break the second parameter (Message) up onto two lines using the powershell newline character (`n).
	If you break the message up into more than two lines the extra lines will be hidden behind or show ontop of the TextBox.
	
	.NOTES
	Name: Show-MultiLineInputDialog
	Author: Daniel Schroeder (originally based on the code shown at http://technet.microsoft.com/en-us/library/ff730941.aspx)
	Version: 1.0
#>
	Add-Type -AssemblyName System.Drawing
	Add-Type -AssemblyName System.Windows.Forms
	
	# Create the Label.
	$label = New-Object System.Windows.Forms.Label
	$label.Location = New-Object System.Drawing.Size(10,10) 
	$label.Size = New-Object System.Drawing.Size(280,20)
	$label.AutoSize = $true
	$label.Text = $Message
	
	# Create the TextBox used to capture the user's text.
	$textBox = New-Object System.Windows.Forms.TextBox 
	$textBox.Location = New-Object System.Drawing.Size(10,40) 
	$textBox.Size = New-Object System.Drawing.Size(575,200)
	$textBox.AcceptsReturn = $true
	$textBox.AcceptsTab = $false
	$textBox.Multiline = $true
	$textBox.ScrollBars = 'Both'
	$textBox.Text = $DefaultText
	
	# Create the OK button.
	$okButton = New-Object System.Windows.Forms.Button
	$okButton.Location = New-Object System.Drawing.Size(510,250)
	$okButton.Size = New-Object System.Drawing.Size(75,25)
	$okButton.Text = "OK"
	$okButton.Add_Click({ $form.Tag = $textBox.Text; $form.Close() })
	
	# Create the Cancel button.
	$cancelButton = New-Object System.Windows.Forms.Button
	$cancelButton.Location = New-Object System.Drawing.Size(415,250)
	$cancelButton.Size = New-Object System.Drawing.Size(75,25)
	$cancelButton.Text = "Cancel"
	$cancelButton.Add_Click({ $form.Tag = $null; $form.Close() })
	
	# Create the form.
	$form = New-Object System.Windows.Forms.Form 
	$form.Text = $WindowTitle
	$form.Size = New-Object System.Drawing.Size(610,320)
	$form.FormBorderStyle = 'FixedSingle'
	$form.StartPosition = "CenterScreen"
	$form.AutoSizeMode = 'GrowAndShrink'
	$form.Topmost = $True
	$form.AcceptButton = $okButton
	$form.CancelButton = $cancelButton
	$form.ShowInTaskbar = $true
	
	# Add all of the controls to the form.
	$form.Controls.Add($label)
	$form.Controls.Add($textBox)
	$form.Controls.Add($okButton)
	$form.Controls.Add($cancelButton)
	
	# Initialize and show the form.
	$form.Add_Shown({$form.Activate()})
	$form.ShowDialog() > $null	# Trash the text of the button that was clicked.
	
	# Return the text that the user entered.
	return $form.Tag
}

function Get-TfExecutablePath
{	
	# Get the latest visual studio IDE path.
	$vsIdePath = "" 
	$vsCommonToolsPaths = @($env:VS110COMNTOOLS,$env:VS100COMNTOOLS)
	$vsCommonToolsPaths = @($VsCommonToolsPaths | Where-Object {$_ -ne $null})
		
	# Loop through each version from largest to smallest.
	foreach ($vsCommonToolsPath in $vsCommonToolsPaths)
	{
		if ($vsCommonToolsPath -ne $null)
		{
			$vsIdePath = "${vsCommonToolsPath}..\IDE\"
			break
		}
		throw "Unable to find Visual Studio Common Tool Path in order to locate tf.exe to check file out of TFS source control."
	}

	# Get the path to tf.exe.
	$tfPath = "${vsIdePath}tf.exe"
	return $tfPath
}

function Tfs-Checkout
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true, Position=0, HelpMessage="The local path to the file or folder to checkout from TFS source control.")]
		[string]$Path,
		
		[switch]$Recursive
	)
	
	$tfPath = Get-TfExecutablePath
	
	# Construct the checkout command to run.
	$tfCheckoutCommand = "& ""$tfPath"" checkout ""$Path"""
	if ($Recursive) { $tfCheckoutCommand += " /recursive" }
	
	# Check the file out of TFS, eating any output.
	Write-Debug "About to run command '$tfCheckoutCommand'."
	Invoke-Expression -Command $tfCheckoutCommand 2>&1 > $null
}

function Get-ProjectsAssociatedNuSpecFilePath([parameter(Position=1,Mandatory)][ValidateScript({Test-Path $_ -PathType Leaf})][string]$ProjectFilePath)
{
	# Construct what the project's nuspec file path would be if it has one (i.e. a [Project File Name].nupsec file in the same directory as the project file).
	$projectsNuSpecFilePath = Join-Path ([System.IO.Path]::GetDirectoryName($ProjectFilePath)) ([System.IO.Path]::GetFileNameWithoutExtension($ProjectFilePath))
	$projectsNuSpecFilePath += ".nuspec"
	
	# If this Project has a .nuspec that will be used to package with.
	if (Test-Path $projectsNuSpecFilePath -PathType Leaf)
	{
		return $projectsNuSpecFilePath
	}
	return $null
}

function Get-NuSpecsAssociatedProjectFilePath([parameter(Position=1,Mandatory)][ValidateScript({Test-Path $_ -PathType Leaf})][string]$NuSpecFilePath)
{
	# Construct what the nuspec's associated project file path would be if it has one (i.e. a [NuSpec File Name].[project extension] file in the same directory as the .nuspec file).
	$nuSpecsProjectFilePath = Join-Path ([System.IO.Path]::GetDirectoryName($NuSpecFilePath)) ([System.IO.Path]::GetFileNameWithoutExtension($NuSpecFilePath))
	
	# Loop through each possible project extension type to see if it exists in the
	foreach ($extension in $VALID_NUGET_PROJECT_TYPE_EXTENSIONS_ARRAY)
	{
		# If this .nuspec file has an associated Project that can be used to pack with, return the project's file path.
		$nuSpecsProjectFilePath += $extension
		if (Test-Path $nuSpecsProjectFilePath -PathType Leaf)
		{
			return $nuSpecsProjectFilePath
		}
	}
	return $null
}


#==========================================================
# Perform the script tasks.
#==========================================================

try
{
	# If we should not show any prompts, disable them all.
	if ($NoPrompt -or $NoPromptExceptOnError)
	{
		if ($NoPrompt) { $NoPromptForInputOnError = $true }
		$NoPromptForPushPackageToNuGetGallery = $true
		$NoPromptForReleaseNotes = $true
		$NoPromptForVersionNumber = $true		
	}
	
	# If a path to a NuSpec or Project file to use was not provided, look for one in the same directory as this script or prompt for one.
	if ([string]::IsNullOrWhiteSpace($NuSpecFilePath) -and [string]::IsNullOrWhiteSpace($ProjectFilePath))
	{
		# Get all of the .nuspec files in the script's directory.
		$nuSpecFiles = Get-ChildItem "$THIS_SCRIPTS_DIRECTORY\*" -Include "*.nuspec" -Name
		
		# Get all of the project files in the script's directory.
		$projectFiles = Get-ChildItem "$THIS_SCRIPTS_DIRECTORY\*" -Include $VALID_NUGET_PROJECT_TYPE_EXTENSIONS_WITH_WILDCARD_ARRAY -Name
	
		# Get the number of files found.
		$numberOfNuSpecFilesFound = @($nuSpecFiles).Length
		$numberOfProjectFilesFound = @($projectFiles).Length
	
		# If we only found one project file, see if we should use it.
		if ($numberOfProjectFilesFound -eq 1)
		{
			$projectPath = Join-Path $THIS_SCRIPTS_DIRECTORY ($projectFiles | Select-Object -First 1)
			$projectsNuSpecFilePath = Get-ProjectsAssociatedNuSpecFilePath -ProjectFilePath $projectPath
			
			# If we didn't find any .nuspec files, then use this project file.
			if ($numberOfNuSpecFilesFound -eq 0)
			{
				$ProjectFilePath = $projectPath
			}
			# Else if we found one .nuspec file, see if we should use this project file.
			elseif ($numberOfNuSpecFilesFound -eq 1)
			{
				# If the .nuspec file belongs to this project file, use this project file.
				$nuSpecFilePathInThisScriptsDirectory = Join-Path $THIS_SCRIPTS_DIRECTORY ($nuSpecFiles | Select-Object -First 1)
				if ((![string]::IsNullOrWhiteSpace($projectsNuSpecFilePath)) -and ($projectsNuSpecFilePath -eq $nuSpecFilePathInThisScriptsDirectory))
				{
					$ProjectFilePath = $projectPath
				}
			}
		}
		# Else if we only found one .nuspec file and no project files, use the .nuspec file.
		elseif (($numberOfNuSpecFilesFound -eq 1) -and ($numberOfProjectFilesFound -eq 0))
		{
			$NuSpecFilePath = Join-Path $THIS_SCRIPTS_DIRECTORY ($nuSpecFiles | Select-Object -First 1)
		}
		
		# If we didn't find a clear .nuspec or project file to use, prompt for one.
		if ([string]::IsNullOrWhiteSpace($NuSpecFilePath) -and [string]::IsNullOrWhiteSpace($ProjectFilePath))
		{
			# If we should prompt directly from Powershell.
			if ($UsePowershellPrompts)
			{
				# Construct the prompt message with all of the supported project extensions.
				# $promptmessage should end up looking like: "Enter the path to the .nuspec or project file (.csproj, .vbproj, .fsproj) to use"
				$promptMessage = "Enter the path to the .nuspec or project file ("
				foreach ($extension in $VALID_NUGET_PROJECT_TYPE_EXTENSIONS_ARRAY)
				{
					$promptMessage += "$extension, "
				}
				$promptMessage = $promptMessage.Substring(0, $promptMessage.Length - 2)	# Trim off the last character, as it will be a ", ".
				$promptMessage += ") to use"
				
				$filePathToUse = Read-Host $promptMessage
				$filePathToUse = $filePathToUse.Trim('"')
			}
			# Else use a nice GUI prompt.
			else
			{
				# Construct the strings to use in the OpenFileDialog filter to allow all of the supported project file types.
				# $filter should end up looking like: "NuSpec and project files (*.nuspec, *.csproj, *.vbproj, *.fsproj)|*.nuspec;*.csproj;*.vbproj;*.fsproj"
				$filterMessage = "NuSpec and project files (*.nuspec, "
				$filterTypes = "*.nuspec;"
				foreach ($extension in $VALID_NUGET_PROJECT_TYPE_EXTENSIONS_ARRAY) 
				{
					$filterMessage += "*$extension, "
					$filterTypes += "*$extension;"
				}
				$filterMessage = $filterMessage.Substring(0, $filterMessage.Length - 2)		# Trim off the last 2 characters, as they will be a ", ".
				$filterMessage += ")"
				$filterTypes = $filterTypes.Substring(0, $filterTypes.Length - 1)			# Trim off the last character, as it will be a ";".
				$filter = "$filterMessage|$filterTypes"
			
				$filePathToUse = Read-OpenFileDialog -WindowTitle "Select the .nuspec or project file to use..." -InitialDirectory $THIS_SCRIPTS_DIRECTORY -Filter $filter
			}
			
			# If the user cancelled the file dialog, throw an error since we don't have a .nuspec file to use.
			if ([string]::IsNullOrWhiteSpace($filePathToUse))
			{
				throw "No .nuspec or project file was specified. You must specify a valid file to use."
			}

			# If a .nuspec file was specified, double check that we should use it.
			if ([System.IO.Path]::GetExtension($filePathToUse) -eq ".nuspec")
			{
				# If this .nuspec file is associated with a project file, prompt to see if they want to pack the project instead (as that is preferred).
				$projectPath = Get-NuSpecsAssociatedProjectFilePath -NuSpecFilePath $filePathToUse
				if (![string]::IsNullOrWhiteSpace($projectPath))
				{
					$promptMessage = "The selected .nuspec file appears to be associated with the project file:`n`n$projectPath`n`nIt is generally preferred to pack the project file, and the .nuspec file will automatically get picked up.`nDo you want to pack the project file instead?"
				
					# If we should prompt directly from Powershell.
					if ($UsePowershellPrompts)
					{
						$promptMessage += " (Yes|No|Cancel)"
						$answer = Read-Host $promptMessage
					}
					# Else use a nice GUI prompt.
					else
					{
						$answer = Read-MessageBoxDialog -Message $promptMessage -WindowTitle "Pack using the Project file instead?" -Buttons YesNoCancel -Icon Question
					}
					
					# If the user wants to use the Project file, use it.
					if (($answer -is [string] -and $answer.StartsWith("Y", [System.StringComparison]::InvariantCultureIgnoreCase)) -or $answer -eq [System.Windows.Forms.DialogResult]::Yes)
					{
						$ProjectFilePath = $projectPath
					}
					# Else if the user wants to use the .nuspec file, use it.
					elseif (($answer -is [string] -and $answer.StartsWith("N", [System.StringComparison]::InvariantCultureIgnoreCase)) -or $answer -eq [System.Windows.Forms.DialogResult]::No)
					{
						$NuSpecFilePath = $filePathToUse
					}
					# Else the user cancelled the prompt, so exit the script.
					else
					{
						throw "User cancelled the .nuspec or project file prompt, so exiting script."
					}
				}
				# Else this .nuspec file is not associated with a project file, so use the .nuspec file.
				else
				{
					$NuSpecFilePath = $filePathToUse
				}
			}
			# Else a .nuspec file was not specified, so assume it is a project file.
			else
			{
				$ProjectFilePath = $filePathToUse
			}
		}
	}
	
	# Make sure we have the absolute file paths.
	if (![string]::IsNullOrWhiteSpace($NuSpecFilePath)) { $NuSpecFilePath = Resolve-Path $NuSpecFilePath }
	if (![string]::IsNullOrWhiteSpace($ProjectFilePath)) { $ProjectFilePath = Resolve-Path $ProjectFilePath }
	
	# If we were given a Project to package.
	if (PackUsingProject)
	{
		# Get the project's .nuspec file path, if it has a .nuspec file.
		$projectNuSpecFilePath = Get-ProjectsAssociatedNuSpecFilePath -ProjectFilePath $ProjectFilePath
	
		# If this Project has a .nuspec that will be used to package with.
		if (![string]::IsNullOrWhiteSpace($projectNuSpecFilePath))
		{
			# Update .nuspec file based on user input.
			$NuSpecFilePath = $projectNuSpecFilePath
			UpdateNuSpecFile
		}
		# Else we aren't using a .nuspec file, so if a Version Number was given in the script parameters but not the pack parameters, add it to the pack parameters.
		elseif (![string]::IsNullOrWhiteSpace($VersionNumber) -and $PackOptions -notmatch '-Version')
		{
			$PackOptions += " -Version ""$VersionNumber"""
		}
		
		# Save the directory that the project file is in as the directory to create the package in.
		$backupOutputDirectory = [System.IO.Path]::GetDirectoryName($ProjectFilePath)
		
		# Record that we want to pack using the project file, not a NuSpec file.
		$fileToPack = $ProjectFilePath
	}
	# Else we are supposed to package using a NuSpec.
	else
	{	
		# Update .nuspec file based on user input.
		UpdateNuSpecFile
		
		# Save the directory that the .nuspec file is in as the directory to create the package in.
		$backupOutputDirectory = [System.IO.Path]::GetDirectoryName($NuSpecFilePath)
		
		# Record that we want to pack using the NuSpec file, not a project file.
		$fileToPack = $NuSpecFilePath
	}
	
	# Make sure our Backup Output Directory is an absolute path.
	if (![System.IO.Path]::IsPathRooted($backupOutputDirectory))
	{
		$backupOutputDirectory = Resolve-Path $directoryToPackFrom
	}
	
	# If the user did not specify an Output Directory, insert our Backup Output Directory into the Additional Pack Parameters.
	if ($PackOptions -notmatch '-OutputDirectory')
	{
		$PackOptions += " -OutputDirectory ""$backupOutputDirectory"""
	}
	
	# Create the package.
	$packCommand = "& ""$NuGetExecutableFilePath"" pack ""$fileToPack"" $PackOptions"
	Write-Debug "About to run command '$packCommand'."
	Invoke-Expression -Command $packCommand | Tee-Object -Variable packOutput
	
	# Get the path the Nuget Package was created to.
	$rxNugetPackagePath = [regex] "(?i)(Successfully created package '(?<FilePath>.*?)'.)"
	$match = $rxNugetPackagePath.Match($packOutput)
	if ($match.Success)
	{
		$nugetPackageFilePath = $match.Groups["FilePath"].Value
	}
	else
	{
		throw "Could not determine where NuGet Package was created to. Perhaps an error occurred while packing it. Look for errors from NuGet above (in the console window)."
	}
	
	# If the switch to push the package to the gallery was not provided and we are allowed to prompt, prompt the user if they want to push the package.
	if (!$PushPackageToNuGetGallery -and !$NoPromptForPushPackageToNuGetGallery)
	{
		$promptMessage = "Do you want to push this new package to the NuGet Gallery?"
		
		# If we should prompt directly from Powershell.
		if ($UsePowershellPrompts)
		{
			$promptMessage += " (Yes|No)"
			$answer = Read-Host $promptMessage
		}
		# Else use a nice GUI prompt.
		else
		{
			$answer = Read-MessageBoxDialog -Message $promptMessage -WindowTitle "Push Package To Gallery?" -Buttons YesNo -Icon Question
		}
		
		# If the user wants to push the new package, record it.
		if (($answer -is [string] -and $answer.StartsWith("Y", [System.StringComparison]::InvariantCultureIgnoreCase)) -or $answer -eq [System.Windows.Forms.DialogResult]::Yes)
		{
			$PushPackageToNuGetGallery = $true
		}	
	}
	
	# Push the Nuget package to the gallery.
	if ($PushPackageToNuGetGallery)
	{
		$pushCommand = "& ""$NuGetExecutableFilePath"" push ""$nugetPackageFilePath"" $PushOptions"
		Write-Debug "About to run command '$pushCommand'."
		Invoke-Expression -Command $pushCommand | Tee-Object -Variable pushOutput
	}
}
finally
{
	# If we created a backup of the NuSpec file before updating it, restore the backed up version.
	$backupNuSpecFilePath = BackupNuSpecFilePath
	if ($DoNotUpdateNuSpecFile -and (Test-Path $backupNuSpecFilePath -PathType Leaf))
	{
		Copy-Item -Path $backupNuSpecFilePath -Destination $NuSpecFilePath
		Remove-Item -Path $backupNuSpecFilePath -Force
	}
}