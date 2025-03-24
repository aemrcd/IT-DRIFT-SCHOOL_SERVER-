Import-Module ActiveDirectory

$csvfile = "<File Location of the INFO.csv> "

$users = import-Csv -Path $csvfile

foreach($user in $users){
$FirstName = $user.Name
$GivenName = $user.GivenName
$LastName = $user.Surname
$DisplayName = $user.DisplayName
$Username = $user.SAMAccountName
$Password = $user.Password
$Description = $user.Description
$OU = $user.OU

New-ADUser -Name "$FirstName $LastName" `-GivenName $GivenName `-Surname $LastName `-DisplayName $DisplayName `-SamAccountName "$Username" `-AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `-Description $Description `-Path $OU `-Enabled $true `-PassThru

}