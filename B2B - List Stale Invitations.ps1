$Days = 10
$Daysago = "{0:s}" -f (get-date).AddDays(-$Days) + "Z"

#Determine default Azure domain
$DefaultDomain = (Get-MsolCompanyInformation).DirSyncServiceAccount.Split('@')
$DefaultDomain = $DefaultDomain[1]

#List External Users
$ExternalUsers = Get-MsolUser -All | Where {$_.UserPrincipalName -like "*#EXT#*"} 

#List users that haven't accepted the B2B inviation within $Days
$ExternalUsers | foreach-object{
    $Array = $_.SignInName.Split('@')
    If($Array[1] -Match $DefaultDomain -AND $_.WhenCreated -lt $Daysago ){"$($_.AlternateEmailAddresses) $($_.WhenCreated)"}

}
