$DynamicGroupNamingConvention = "ADG-B2B-"
$DynamicGroupDisplayNameText  = "Dyanmic Group containing B2B users from "
$MailEnable = $False
 
#List External Users
$ExternalUsers = Get-AzureADUser -All $True | Where {$_.UserPrincipalName -like "*#EXT#*"} 
 
#Count users per unique domain
$Domains = @{}
$ExternalUsers | foreach-object {
    $UPN = $_.UserPrincipalName
    $Domain = $UPN -Split {$_ -eq "_" -or $_ -eq "#"}
    $Domains[$Domain[1]]++
}
 
#Create Dynamic Groups
$Domains.Keys | ForEach-Object {
    #Prefix Naming Convention to group name
    $DomainName = $_
    $GroupName = "$($DynamicGroupNamingConvention)$($DomainName)"
    $GroupDescription = "$($DynamicGroupDisplayNameText)$($DomainName)"
    
    #Create Dynamic groups
    New-AzureADMSGroup -Description $GroupDescription -DisplayName $GroupName -MailEnabled $MailEnable -SecurityEnabled $true -MailNickname $GroupName -GroupTypes “DynamicMembership” -MembershipRule “(user.userPrincipalName -contains ""$DomainName"")” -MembershipRuleProcessingState “On”
}
