# Offboard an Active Directory User
$Selection = 0

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuildtInRol]'Administrator')) {
    Start-Process powershell.exe "-NoProfile -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

function Get-User {
    $UserAccount = $null
    $UserAccounts = [System.Collections.Generic.List[PSObject]]::new()
    $User = Read-Host "User"

    # Call to Server to get all possible users
    $UserHolding = Get-ADUser -Filter "SamAccountName -eq '$User' -or Name -like '$User*' -or DisplayName -like '$User*'"

    if ($UserHolding) {
        if ($UserHolding.Count -gt 1) {

            # Looping through and creating an array of usernames without calling server directly.
            foreach ($user in $UserHolding) {
                if ($UserAccounts.SamAccountName -notcontains $user.SamAccountName) {
                    $UserAccounts.Add($user)
                }
            }
            Write-Host "Multiple users found, pleae use a below name"
            foreach ($user in $UserAccounts) { 
                Write-Host $user
                }
            # Checking that user inputs an accurate Sam Account Name
            While ($null -eq $UserAccount) {
                $User = Read-Host "New User"
                $UserAccount = Get-ADUser -Filter "SamAccountName -eq '$User'"

            }
            return $UserAccount
        }
        $UserAccount = Get-ADUser -Filter "SamAccountName -eq '$User'"
        return $UserAccount
    }
}

While ($Selection -ne "5" -and $Selection -ne "exit") {
    $User = $null
    Write-Output "1 Disable User Account"
    Write-Output "2 Remove From Groups"
    Write-Output "3 Convert User to Shared Mailbox"
    Write-Output "4 Remove Microsoft Licenses from User"
    Write-Output "5 Exit"
    $Selection = Read-Host "Please enter your selection: "
    switch ($Selection) {
        #if selection equals 1
        1 {
            While ($null -eq $User) {
                $User = Get-User
            }
            try {
                Disable-ADAccount -Identity $User
            } catch {
                Write-Output "Error Disabling account"
            }

            $Selection = 0
            continue
        }
        #if selection equals 2
        2 {

            While ($null -eq $User) {
                $User = Get-User 
            }
            #Logic for removing user from all groups
            $Groups = @(Get-ADPrincipalGroupMembership $User | select name)
            foreach ($Group in $Groups) {
                if ($Group.Name -ne "Domain Users") {
                    try {
                        Remove-ADGroupMember -Identity $Group -Members $User
                    } catch {
                        Write-Output "Error removing $User from $Group"
                    }
                }
            }
            $Selection = 0
    }
        #if selection equals 3
        3 {
            While ($User -eq "") {
                $User = Get-User
            }

            # logic for converting to a shared mailbox in exchange online
            if ($User.mailNickname) {

                Connect-ExchangeOnline
                try {
                    Set-Mailbox -Identity $User.UserPrincipalName -Type Shared
                } catch {
                    Write-Host "Error Converting $User.SamAccountName to Shared"
                }
            }
            
            $Selection = 0
            continue
        }
        #if selection equals 4
        4 {

            While ($User -eq "") {
                $User = Get-User
            }

            $Selection = 0
            continue
        }

        5 {
            continue
        }
    }
}
