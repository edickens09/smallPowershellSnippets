#Remove User Profile
#Display all users, run in loop and take input delete user input
#Exit on "Exit" and redisplay on 1
$Selection = 0

While ($Selection -ne "4" -and $Selection -ne "exit") {
    Write-Output "1 Delete User"
    Write-Output "4 Exit"
    $Selection = Read-Host "Please Enter your selection: "

    if ($Selection -eq "1") {
        Get-ChildItem C:\Users

        $User = Read-Host "Enter user to delete"
        Get-CimInstance -Class Win32_UserProfile | Where-Object {$_.LocalPath.split('\')[-1] -eq $User } | Remove-CimInstance

    }
}
