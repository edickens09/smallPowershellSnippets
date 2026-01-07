$computers = (Get-ADComputer -Filter * -SearchBase "OU=Desktops, OU=Workstations, OU=Blue Ridge PBS Corporate Offices, DC=blueridge, DC=int").name
$currentdate = Get-Date

foreach($computer in $computers){
$rebootoptions = 
$Bootuptime = (Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computer).LastBootUpTime
   $uptime = $currentdate - $Bootuptime
   Write-Output "$computer Uptime : $($uptime.Days) Days, $($uptime.Hours) Hours, $($uptime.Minutes) Minutes"
}
