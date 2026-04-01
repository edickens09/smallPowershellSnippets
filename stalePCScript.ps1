$DateLimit = (Get-Date).AddDays(-90)
$StaleComputers = Get-ADComputer -Filter 'LastLogonate -le $DateLimit' -Properties LastLogonDate |
    Select-Object Name, LastLogonDate

$StaleComputers | Out-File -FilePath "C:\Users\edickens\stalePC.txt"
