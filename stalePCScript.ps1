$DateLimit = (Get-Date).AddDays(-90)
Get-ADComputer -Filter 'LastLogonate -le $DateLimit' -Properties LastLogonDate |
    Select-Object Name, LastLogonDate
