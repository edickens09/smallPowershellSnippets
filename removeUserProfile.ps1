#Remove User Profile
#Display all users, run in loop and take input delete user input
#Exit on "Exit" and redisplay on 1
$User = #get user
Get-CimInstance -Class Win32_UserProfile | Where-Object {$_.LocalPath.split('\')[-1] -eq $User } | Remove-CimInstance

#See Users/get folders of path
Get-ChildItem C:\Users
