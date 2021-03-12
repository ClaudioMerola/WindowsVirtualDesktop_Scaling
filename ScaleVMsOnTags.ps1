	Param
    (   
        [String]$AzureResourceGroup,
        [Boolean]$ScaleUp,
        [String]$AzureTag
    )
	
	$connectionName = "AzureRunAsConnection"

    try
    {
        # Get the connection "AzureRunAsConnection "
        $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

        Disable-AzContextAutosave –Scope Process

        while(!($connectionResult) -and ($logonAttempt -le 10))
            {
                $LogonAttempt++
                $connectionResult = Connect-AzAccount `
                    -ServicePrincipal `
                    -TenantId $servicePrincipalConnection.TenantId `
                    -ApplicationId $servicePrincipalConnection.ApplicationId `
                    -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
            
            Start-Sleep -Seconds 10
            }
    }
    catch {
        if (!$servicePrincipalConnection)
        {
            $ErrorMessage = "Connection $connectionName not found."
            throw $ErrorMessage
        } else{
            Write-Error -Message $_.Exception
            throw $_.Exception
        }
    }
	
	if($ScaleUp -eq $true){
		Write-Output "Scalling Up VMs in '$($AzureResourceGroup)' resource group with Tag: '$($AzureTag)'";
	}
	else{
		Write-Output "Scalling Down VMs in '$($AzureResourceGroup)' resource group with Tag: '$($AzureTag)'";
	}
	
    $VM = Get-AzVM -ResourceGroupName $AzureResourceGroup -Status | where {$_.Tags.Scale -eq $AzureTag}

    $VMsOn = $VM | where {$_.PowerState -eq 'VM running'}
    $VMsOff = $VM | where {$_.PowerState -eq 'VM deallocated'}

    if($ScaleUp -eq $true)
        {
            if($VMsOff.count -ge 1)
                {
                    Write-Output "Starting '$($VMsOff[0].Name)' ...";
                    Start-AzVM -ResourceGroupName $AzureResourceGroup -Name $VMsOff[0].Name;
                }
            else
                {
                    Write-Output "No servers left to Power On";
                }
        }
    else
        {
            if($VMsOn.count -ge 2)
                {
                    Write-Output "Stopping '$($VMsOn[0].Name)' ...";			
                    Stop-AzVM -ResourceGroupName $AzureResourceGroup -Name $VMsOn[0].Name;
                }
            else
                {
                    Write-Output "No servers left to Power Off";
                }			
    }
