# Remove an Active Directory User
$Selection = 0
$User = ""

While ($Selection -ne "4" -and $Selection -ne "exit") {
    Write-Output "1 Disable User Account"
    Write-Output "2 Remove From Groups"
    Write-Output "3 Convert User to Shared Mailbox"
    Write-Output "4 Exit"
    $Selection = Read-Host "Please enter your selection: "
    switch ($Selection) {
        #if selection equals 1
        1 {
            $User = Read-Host "Enter User you want to disable: "
            if (Get-ADUser -Identity $User -or Get-ADUser -Filter 'Name -like "$User*"') {
                $UserCount = @(Get-ADUser -Filter 'Name -like "$User*"')
                if ($UserCount.Count -gt 1) {
                    Write-Output "Multiple users found, please use a below name"
                    foreach ($user in $UserCount) {
                        Write-Output $user.SamAccountName
                    }
                    $User = Read-Host "User: "
                    #need logic here so far Disable-ADAccount has to run 
                }
            Disable-ADAccount -Identity $User
            } else {
                Write-Output "User not found try again"
            }


        }
        #if selection equals 2
        2 {}
    }
}
