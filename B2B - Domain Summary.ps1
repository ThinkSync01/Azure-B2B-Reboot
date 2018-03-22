$ExternalUsers = Get-MsolUser -All | Where {$_.UserPrincipalName -like "*#EXT#*"} 
$HashCount = @{}
$ExternalUsers | foreach-object {
    $Array = $_.SignInName.Split('@')
    $HashCount[$Array[1]]++
}

#Option 1: Sort alphabetically
$HashCount.GetEnumerator() | sort -Property name

#line break"
"`n"

#Option 2: Sort domains in descending order 
$HashCount.GetEnumerator() | sort -Descending -Property value
