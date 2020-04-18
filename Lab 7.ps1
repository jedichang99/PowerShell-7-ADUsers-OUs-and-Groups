<#
    PowerShell Lab 7
    Manipulate users, ous, groups, and group membership
    Date: 04/13/2020, week 13
    Created by: Jedidiah Chang
#>

cls

$Choice = Read-Host "Choose form the following Menu Items
      A. VIEW one OU`t`t`t   B. VIEW all OUs
      C. VIEW one group`t`t`t   D. VIEW all groups
      E.VIEW one user`t`t       F. VIEW all users`n

    G. CREATE one OU`t`t        H. CREATE one group
    I. CREATE one user`t`t`t    J. CREATE user from csv file
   
    K. ADD user to group`t       L. REMOVE user form group
    M. DELETE one group`t`t       N. DELETE one user
       


  "
write-host "Enter anything other than A - N to quit"


    If ($Choice -eq "A") {
   
        $name1 = Read-host "What is the name of the OU?"
        Get-ADOrganizationalUnit -filter "name -like'$name1'" -properties Name, DistinguishedName
        Read-Host "Press enter to continue..."
        }
    ElseIf ($Choice -eq "B") {
   
        Get-AdOrganizationalUnit -Filter * -properties *|format-table -property Name, DistinguishedName
        Read-Host "Press enter to continue..."
        }
    ElseIf ($Choice -eq "C") {
   
        $name2 = Read-host "What is the name of the Group?"
        Get-AdGroup -filter "name -like '$name2'" |format-table -property Name, GroupScope, GroupCategory
        Read-Host "Press enter to continue"
        }
    ElseIf ($Choice -eq "D") {
   
        Get-AdGroup -filter *  -properties Name, GroupScope, GroupCategory|format-table Name,Groupscope,GroupCategory
        Read-Host "Press enter to continue"
        }
    ElseIf ($choice -eq "E") {
   
        $name3 = Read-host "What is the name of the User?"
        Get-AdUser -filter "name -like'$name3'"|format-table -property Name, DistinguishedName
        Read-Host "Press enter to continue"
        }
    ElseIf ($choice -eq "F") {
   
        Get-AdUser -filter * |format-table -property Name, DistinguishedName, GivenName, surName
        Read-Host "Press enter to continue"
        }
    ElseIf ($choice -eq "G") {
   
        $name4 = Read-host "What is the name of the OU you want to create?"
        new-AdOrganizationalUnit -name $name4
        Get-AdOrganizationalUnit -filter "name -like'$name4'" -properties Name, DistinguishedName
        Read-Host "Press enter to continue"
        }
    ElseIf ($Choice -eq "H") {
        'Item H chosen'
        $name5 = Read-host "What is the name of the Group you want to create?"
        new-AdGroup -name $name5 -GroupScope Global -GroupCategory Security
        Get-AdGroup -filter "name -like'$name5'"|format-table -property Name, GroupScope, GroupCategory
        Read-Host "Press enter to continue"
        }
    ElseIf ($choice -eq "I") {
   
        $name6 = Read-host "What is the name of the User you want to create?"
        $FirstName = Read-host "what is the first name?"
        $LastName = Read-host "what is the Last name?"
        $StreetAddress = Read-Host "What is the Street Address?"
        $City = Read-Host "What is the City?"
        $State = Read-Host "What is the State?"
        $PostalCode = Read-Host "What is the Postal Code?"
        $Organization = Read-Host "What is the Organization Name?"
        $Office = Read-Host "What is the Office Name?"
   
        $Location = Read-Host "Where would you like this user to go? A.User Container B.OU?"
        If ($Location -eq "A") {
       
            $Path = "CN=Users, DC=Adatum, DC=Com"
            }
        Elseif($Location -eq "B") {
       
            $Path2 = Read-Host "which OU do you want to put the user in?"
            $Path = "OU=$Path2, DC=Adatum, DC=Com"
            }
            $password= (convertto-securestring -string "Password01" -asplaintext -force)
       
   
        new-ADUser -name $name6 -SamAccountName $name6 -UserPrincipalName $name6 -GivenName $FirstName -Surname $LastName -StreetAddress $StreetAddress -City $City -State $State -PostalCode $PostalCode -Organization $Organization -Office $Office -Path $Path -AccountPassword $password -Enabled $True

        Get-ADUser -filter "name -like'$name6'" -properties *| Format-List -property Name, SAMAccountName, UserPrincipalName, GivenName, Surname, StreetAddress, City, State, PostalCode, Organization, Office

        Read-Host "Press enter to continue"
        }
        ElseIf ($Choice -eq "J") {
        foreach ($CSVuser in $CSVusers){
            $CSVName = $CSVuser.Name
            $CSVSamAccountName = $CSVuser.SamAccountName
            $CSVUserPrincipalName = $CSVuser.UserPrincipalName
            $CSVGivenName = $CSVuser.GivenName
            $CSVSurname = $CSVuser.Surname
            $CSVAddress = $CSVuser.Address
            $CSVcity = $CSVuser.city
            $CSVstate = $CSVuser.state
            $CSVPostalCode = $CSVuser.PostalCode
            $CSVDepartment = $CSVuser.Department
            $CSVcompany = $CSVuser.company
            New-ADUser -Name $CSVName -SamAccountName $CSVSamAccountName -UserPrincipalName $CSVUserPrincipalName -GivenName $CSVGivenName -Surname $CSVSurname -StreetAddress $CSVAddress -city $CSVcity -state $CSVcity -PostalCode $CSVPostalCode -Department $CSVDepartment -company $CSVcompany -Path "CN=Users, DC=Adatum, DC=COM" -AccountPassword (ConvertTo-SecureString $CSVuserPassword -AsPlainText -Force) -Enabled 1

    }
    ElseIf ($Choice -eq "K") {
   
        $name7 = Read-host "What is the name of the Group you want to add a user to?"
        $username = Read-host "What is the name of the user you want to add?"
        add-ADgroupmember -Identity $name7 -members $username
        Get-AdGroupmember -Identity $name7 |format-table -property Name, SamAccountName, DistinguishedName
        Read-Host "Press enter to continue"
        }
    ElseIf ($Choice -eq "L") {
        'Item L chosen'
        $name8 = Read-host "What is the name of the Group you want to remove a user from?"
        Get-AdGroupmember -Identity $name8 |format-table -property Name, SamAccountName, DistinguishedName
        $remuser=Read-host "Do you want one of these users to be removed? (Y or N)"
            If ($remuser -eq "Y") {
            $username = Read-host "What is the name of the user you want to remove?"
            remove-ADGroupmember -Identity $name8 -Members $username
            Read-Host "Press enter to continue"
            }
            Elseif($remuser -eq "N") {
            Read-host "Try Again"
            }
        Read-Host "Press enter to continue"
        }
    ElseIf ($Choice -eq "M") {
   
        $name8 = Read-host "Which group do you want to delete?"
        Remove-ADGroup -name $name8
        Get-AdGroup -filter "name -like'$name8'" -properties Name, groupscope, groupcategory
        Read-Host "Press enter to continue"
        }
    ElseIf ($Choice -eq "N") {
   
        $name9 = Read-host "What is the name of the User you want to delete?"
        Remove-AdUser -name $name9
        Get-ADUser -filter "name -like'$name9" |format-table -property
        Read-Host "Press enter to continue"
        }
