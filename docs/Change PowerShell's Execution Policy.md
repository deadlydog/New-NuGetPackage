# Check PowerShell's Current Execution Policy
To check what your current PowerShell execution policy is set to:
# Open the Windows PowerShell console
# Type the following and hit enter: **Get-ExecutionPolicy**
	* If the policy is not "Unrestricted" then you will likely need to update the execution policy before you will be able to run the script.

# Update PowerShell's Execution Policy To Allow Scripts To Be Ran
To update the PowerShell execution policy so that you can run the script:
# Open the Windows PowerShell console +as admin+
# Type the following and hit enter: **Set-ExecutionPolicy Unrestricted -Force**

