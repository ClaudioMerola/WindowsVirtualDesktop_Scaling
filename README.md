# WindowsVirtualDesktop_Scaling

Those Scripts are 100% based on the great work of TRAVIS ROBERTS and KANDICE LYNNE.

For the Spring Update version follow this blog post: https://www.ciraltos.com/auto-start-and-stop-session-hosts-in-windows-virtual-desktop-spring-update-arm-edition-with-an-azure-function/

For the Classic Version follow this blog post: https://www.ciraltos.com/automatically-start-and-stop-wvd-vms-with-azure-automation/

###For the Classic version the steaps are: 

1) - Create Automation Account.
2) - Add the 3 powershell modules to the Automation Account (Az.Accounts, Az.Compute, Microsoft.RDInfra.RDPowershell)
2) - Create Variables (aadTenantId and azureSubId) in the Automation Account.
3) - Create the Credential (WVD-AutoScale-cred) in the Automation Account. (Use the WVD Service Principal credentials)
3) - Add the same WVD Service Principal Account the Role os Contributor to the Resource Group of the VMs
4) - Paste the script (WVD_Classic_Scalling.ps1) in the Automation
5) - Create a WebHook in the Automation
6) - Create a Function App 
7) - Create a TimeTrigger in the Function App
8) - In the TimeTrigger function, in the Run.ps1, paste the script WebHook.ps1


###For the Spring Update version the steaps are: 

1) - Create a Function App
2) - Enable the System Identity in the Function App
3) - In the Resource Group of the VMs add the new Function App Identity with Contributor rights
4) - Create a TimeTrigger in the Function App
5) - In the TimeTrigger function, in the Run.ps1, paste the script WVD_SpringUpdate_Scaling.ps1
