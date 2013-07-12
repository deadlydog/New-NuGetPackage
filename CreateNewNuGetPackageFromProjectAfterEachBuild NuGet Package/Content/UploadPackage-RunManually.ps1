$THIS_SCRIPTS_DIRECTORY = Split-Path $script:MyInvocation.MyCommand.Path

# The NuGet gallery to upload to. If not provided, the DefaultPushSource in your NuGet.config file is used (typically nuget.org).
$sourceToUploadTo = ""

# The API Key to use to upload the package to the gallery. If not provided and a system-level one does not exist for the specified Source, you will be prompted for it.
$apiKey = ""

# Specify any additional NuGet Pack options to pass to nuget.exe.
# Rather than specifying the -Source or -ApiKey here, use the variables above.
$additionalPushOptions = ""

# Add the Source and ApiKey to the Push Options if there were provided.
if (![string]::IsNullOrWhiteSpace($sourceToUploadTo)) { $additionalPushOptions += " -Source ""$sourceToUploadTo"" " }
if (![string]::IsNullOrWhiteSpace($apiKey)) { $additionalPushOptions += " -ApiKey ""$apiKey"" " }

# Create the new NuGet package.
& "$THIS_SCRIPTS_DIRECTORY\New-NuGetPackage.ps1" -PushOptions "$additionalPushOptions"