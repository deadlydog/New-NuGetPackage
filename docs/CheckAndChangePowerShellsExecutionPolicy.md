# Check and Change PowerShell's Execution Policy

## Check PowerShell's Current Execution Policy

To check what your current PowerShell execution policy is set to:

1. Open the Windows PowerShell console
1. Type the following and hit enter: `Get-ExecutionPolicy`
	* If the policy is not `Unrestricted` then you will likely need to update the execution policy before you will be able to run the script.


## Update PowerShell's Execution Policy To Allow Scripts To Be Ran

To update the PowerShell execution policy so that you can run the script:

1. Open the Windows PowerShell console **as admin**
1. Type the following and hit enter: `Set-ExecutionPolicy Unrestricted -Force`
