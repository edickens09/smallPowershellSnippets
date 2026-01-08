$User = "wbra.admin"

if (Get-LocalUser -Name $User -ErrorAction SilentlyContinue) {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRol]'Administrator')) {
		Start-Process powershell.exe "-NoProfile -File `"$PSCommandPath`"" -Verb RunAs
		Exit
	}

	Remove-LocalUser -Name $User
	Get-CimInstance -Class Win32_UserProfile | Where-Object {_.LocalPath.split('\')[-1] -eq $User } | Remove-CimInstance
	Write-Host "User has been removed"
}else{
	Write-Host "User not Present"
}
Read-Host -Prompt "Press Enter to exit"
