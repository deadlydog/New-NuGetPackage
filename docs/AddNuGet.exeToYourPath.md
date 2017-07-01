# Check If NuGet.exe Is Already In Your PATH

To check if nuget.exe is already in your system's PATH:

1. Open a command prompt.
1. Type `nuget` and hit enter.
	* If the nuget help documentation is displayed, then nuget.exe is already in your PATH.
	* If you received the message, "'nuget' is not recognized as an internal or external command, operable program or batch file." then nugexe.exe is not in your PATH yet and still needs to be added.

## Add NuGet.exe To Your PATH

If nuget.exe was located on your PC at "C:\My Utilities\nuget.exe", to add nuget.exe to your PATH:

1. Open a command prompt.
1. Type the following and hit enter:

```set PATH=%PATH%;C:\My Utilities```
