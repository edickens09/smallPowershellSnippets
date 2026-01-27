# Admin setup script
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
	Start-Process powershell.exe "-No Profile -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}

#Setup RSAT tools for server administration
$RsatTools = @(
	"Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"
	"Rsat.Dns.Tools~~~~0.0.1.0"
	"Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0"
	"Rsat.Servermanager.Tools~~~~0.0.1.0"
)

foreach ($tool in $RsatTools) {
	Add-WindowsCapability -Online -Name $tool
}

winget upgrade --all
