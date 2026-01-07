New#Escalate to higher privileges
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}

#Chech for Network Discovery and Disable if turned on
$networkDiscovery = Get-NetFirewallRule -DisplayGroup "Network Discovery"
if ($networkDiscovery.Enabled -eq 'True') {
    Set-NetFirewallRule -DisplayGroup "Network Discovery" -Enabled False -Profile Any
    Write-Host "Network discovery has been turned off."
} else {
    Write-Host "Network discovery is already disabled."
}

#Reboot if system has an uptime of more than 30 days
$lastBootUpTime = (Get-WmiObject -Class Win32_OperatingSystem).LastBootUpTime
$uptime = (Get-Date) - [System.Management.ManagementDateTimeConverter]::ToDateTime($lastBootUpTime)

if ($uptime.Days -gt 30) {
    Write-Host "System uptime exceeds 30 days. Restarting the machine."
    Restart-Computer -Force
} else {
    Write-Host "System uptime is within 30 days."
}