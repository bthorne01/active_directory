param([Parameter(Mandatory=$true)] $JSONFile)

function CreateADGroup()
{
    param([Parameter(Mandatory=$true)] $groupObject)

    $name = $groupObject.name
    New-ADGroup -name $name -GroupScope Global

}



function createADUser ()
{
    param([Parameter(Mandatory=$true)] $UserObject)

    #pull out the name from json object
    $name = $UserObject.name
    $password = $UserObject.password
    #generate first initial lastname structure for username and sam account name
    $samAccountName = ($name[0] + $name.split(" ")[1]).ToLower()
    $username = ($name[0] + $name.split(" ")[1]).ToLower()
    $firstname, $lastname = $name.split(" ")
    $principalname = $username
    # Create AD User object
    New-ADUser -Name "$name" -GivenName $firstname -surname $lastname -samaccountname $samAccountName -userprincipalname $principalname@$Global:Domain -accountpassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount
    
    #add users to appropriate group 
    foreach($group in $UserObject.groups)
    {
        try 
        {
            get-adgroup  -Identity "$group"
            Add-ADGroupMember -Identity $group -Members $username
        }
            catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
                {
                    Write-Warning "AD Group object not found - $group does not exist."
                }
        
    }


    echo $UserObject

}



$json = (get-content $JSONFile | ConvertFrom-Json)
$Global:Domain = $json.domain

foreach($group in $json.groups)
{
    CreateADGroup $group
}

foreach ($user in $json.users)
{
    createADUser $user
}