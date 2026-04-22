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
                }
            Disable-ADAccount -Identity $User
            } else {
                Write-Output "User not found try again"
            }


        }
        #if selection equals 2
        2 {
            $User = Read-Host "Enter User you wish to remove from all groups: "
            if (Get-ADUser -Identity $User -or Get-ADUser -Filter 'Name -like "User*"') {
                $UserCount = @(Get-ADUser -Filter 'Name -like "$User*"')
                if ($UerCount.Count -gt 1) {
                    Write-Output "Multiple users found, pleae use a below name"
                    foreach ($user in $UserCount) {
                        Write-Output $user.SamAccountName
                    }
                    $User = Read-Host "User: "
                }
            }
            #Logic for removing user from all groups
            $Groups = @(Get-ADPrincipalGroupMembership $User | select name)
            foreach ($Group in $Groups) {
                Remove-ADGroupMember -Identity $Group -Members $User
            }
        }
        #if selection equals 3
        3 {
            $User = Read-Host "Enter User to want to convert to shared mailbox"
            if (Get-ADUser -Identity $User -or Get-ADUser -Filter 'Name -like "$User*"') {
                $UserCount = @(Get-ADUser -Filter 'Name -like "$User*"')
                if ($UserCount.Count -gt 1) {
                    Write-Output "Multiple users found, please use a below name"
                    foreach ($user in $UserCount) {
                        Write-Output $user.SamAccountName
                    }
                    $User = Read-Host "User: "
                }
            #Logic for converting $User to a shared mailbox
            }
        }
    }
}
