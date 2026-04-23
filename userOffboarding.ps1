# Offboard an Active Directory User
$Selection = 0

function Get-User {
    $User = Read-Host "User: "
    if ((Get-ADUser -Filter "SamAccountName -eq '$User' -or Name -like '$User*' -or DisplayName -like '$User*'") {
        #this isn't what I need maybe I need to changin the logice?
        $UserCountName = @(Get-ADUser -Filter "Name -like '*$User*'")
        $UserCountDisplayName = @(Get-ADUser -Filter "DisplayName -like '*$User*'")

        if ($UserCountName.Count > $UserCountDisplayName.Count) {
            $UserCount = $UserCountName
        } else {
            $UserCount = $UserCountDisplayName
        }

        if ($UserCount.Count -gt 1) {
            Write-Output "Multiple users found, pleae use a below name"
            foreach ($user in $UserCount) {
                Write-Output $user.SamAccountName
            }
            $User = Read-Host "User: "
            return $User
        }
        return $User
    }
}

While ($Selection -ne "4" -and $Selection -ne "exit") {
    $User = ""
    Write-Output "1 Disable User Account"
    Write-Output "2 Remove From Groups"
    Write-Output "3 Convert User to Shared Mailbox"
    Write-Output "4 Exit"
    $Selection = Read-Host "Please enter your selection: "
    switch ($Selection) {
        #if selection equals 1
        1 {
            While ($User -eq "") {
                $User = Get-User
            }
            Disable-ADAccount -Identity $User
        }
        #if selection equals 2
        2 {

            While ($User -eq "") {
                $User = Get-User 
            }
            #Logic for removing user from all groups
            $Groups = @(Get-ADPrincipalGroupMembership $User | select name)
            foreach ($Group in $Groups) {
                Remove-ADGroupMember -Identity $Group -Members $User
            }
    }
        #if selection equals 3
        3 {
            While ($User -eq "") {
                $User = Get-User
            }
            # Logic for converting user to Shared Mailbox
        }
        #if selection equals 4
        4 {

            return
        }
    }
}
