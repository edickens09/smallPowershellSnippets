# Offboard an Active Directory User
$Selection = 0

function Get-User {
    $UserAccount = $null
    $UserAccounts = [System.Collections.Generic.List[Microsoft.ActiveDirectory.Management.ADUser]]::new()
    $User = Read-Host "User"

    $UserHolding = Get-ADUser -Filter "SamAccountName -eq '$User' -or Name -like '$User*' -or DisplayName -like '$User*'"

    if ($UserHolding) {

        if ($UserHolding.Count -gt 1) {
            foreach ($user in $UserHolding) {
                if ($UserAccounts.SamAccountName -notcontains $user.SamAccountName) {
                    $UserAccounts.Add($user)
                }
            }
            Write-Output "Multiple users found, pleae use a below name"
            $UserAccounts | Format-Table -Property SamAccountName, Enabled
            While ($null -eq $UserAccount) {
                $User = Read-Host "User"
                $UserAccount = Get-ADUser -Identity $User

            }
            return $UserAccount
        }
        $UserAccount = Get-ADUser -Identity $User
        return $UserAccount
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
            While ($null -eq $User) {
                $User = Get-User
            }
            Disable-ADAccount -Identity $User
            $Selection = 0
        }
        #if selection equals 2
        2 {

            While ($null -eq $User) {
                $User = Get-User 
            }
            #Logic for removing user from all groups
            $Groups = @(Get-ADPrincipalGroupMembership $User | select name)
            foreach ($Group in $Groups) {
                Remove-ADGroupMember -Identity $Group -Members $User
            }
            $Selection = 0
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
