# .PARAMETER PlanName
# The Name of the Windows Power Plan that is required to set

Param
(
    [Parameter(Mandatory=$false)]
    [string]$PlanName = 'Ausbalanciert'
)

#Get all Power Plans from System (WMI)
$PowerPlans = Get-WmiObject -Namespace root\cimv2\power -Class win32_powerplan

#Get the current active Power Plan
$ActivPowerPlan = $PowerPlans | Where-Object { $_.IsActive }

#Compare the active Power Plan with the required one
if ($ActivPowerPlan.ElementName -eq $PlanName) 
{ 
    Write-Host "Power Plan Settings are correct!" 
}
else 
{
    try
    {
        #Get the required Power Plan
        $PowerPlan = $PowerPlans | Where-Object { $_.ElementName -eq $PlanName }

        #Activated the Power Plan / Method do not work anymore
        #Plan.Activate();
        
        #Activated the Power Plan using powercfg.exe
        powercfg /setactive ([string]$PowerPlan.InstanceID).Replace("Microsoft:PowerPlan\{","").Replace("}","")
        Write-Host ("Power Plan Settings are changed to {0}!" -f $PowerPlan.ElementName)  
    }
    catch
    {
        Write-Host ("Power Plan Settings are still {0}!" -f $ActivPowerPlan.ElementName)
    }
}
