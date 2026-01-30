$admin = ".admin"
$dadamin = ".dadmin"
$Users = Get-ChildItem C:\Users | Where-Object {$_.Name -like "*$admin*" or $_.Name -like "*$dadmin" }

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
        Start-Process powershell.exe "-NoProfile -File `"$PSCommandPath`"" -Verb RunAs
        Exit
	}
foreach ($User in $Users) {
    if (Get-LocalUser -Name $User -ErrorAction SilentlyContinue) {
        Remove-LocalUser -Name $User
        Write-Host "User has been removed"
    }else{
        Write-Host "User not Present"
    }

    $CimInstance = Get-CimInstance -Class Win32_UserProfile | Where-Object {$_.LocalPath.split('\')[-1] -eq $User}
    if ($CimInstance) {
        Remove-CimInstance $CimInstance
        Write-Host "User Profile is removed"
    }else {
        Write-Host "No Profile to remove"
    }
}

Read-Host -Prompt "Press Enter to exit"

