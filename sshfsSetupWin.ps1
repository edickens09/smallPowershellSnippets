#needs run as admin
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process powershell.exe "-No Profile -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

$User = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
winget install WinFsp.WinFsp
winget install SSHFS-Win.SSHFS-Win

#this is for SSH host
$TargetPath = ""
$Path = "C:\Users\$User\sshd"

if (!(Test-Path $Path)) {
    New-Item -ItemType Junction -Path $Path -Target $TargetPath
}

