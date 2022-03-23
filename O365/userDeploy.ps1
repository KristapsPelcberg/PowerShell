Install-Module MSOnline
$Msolcred = Get-credential -UserName <#admin user email#> -Message "Enter admin password"
Connect-MsolService -Credential $Msolcred

$tenantfqdn=($Msolcred.UserName -split ("@"))[1]

$users=Import-CSV -Path $PSScriptRoot/userlist.csv -Delimiter ';' -Encoding UTF8

foreach($user in $users){
$msolSKU = Get-MsolAccountSKu | Where-Object {$_.AccountSkuId -like "*ENTERPRISEPACK"}
$avaivable= $msolSKU.ActiveUnits - $msolSKU.ConsumedUnits
if($user.External -eq "True"){
    Write-Host -ForegroundColor DarkYellow "Creating External User: " $user.DisplayName
    $userCreate = New-MailContact -Name $user.DisplayName -ExternalEmailAddress $user.UserPrincipalName
}else{
    if ($available -eq "0") {
                    Write-Host -ForegroundColor Yellow "Creating user without licence" $user.DisplayName "in Department" $user.Department "with manager" $user.manager
                    $userCreate = New-MsolUser -UserPrincipalName ($user.UserPrincipalName + "@" + $tenantfqdn) -Department $user.Department -Country $user.Country -StreetAddress $user.StreetAddress -State $user.State -City $user.City -PostalCode $user.PostalCode -AlternateMobilePhones $user.AlternativeMobilePhone -MobilePhone $user.MobilePhone -PhoneNumber $user.HomePhone -Fax $user.Fax -FirstName $user.FirstName -LastName $user.LastName -Office $user.Office -UsageLocation $user.UsageLocation -DisplayName $user.DisplayName -Title $user.Title -Password $user.Password -ForceChangePassword $false 

                }
                else {
                    Write-Host -ForegroundColor Yellow "Creating & Licensing user" $user.DisplayName "in Department" $user.Department "with manager" $user.manager
                    $userCreate = New-MsolUser -UserPrincipalName ($user.UserPrincipalName + "@" + $tenantfqdn) -Department $user.Department -Country $user.Country -StreetAddress $user.StreetAddress -State $user.State -City $user.City -PostalCode $user.PostalCode -AlternateMobilePhones $user.AlternativeMobilePhone -MobilePhone $user.MobilePhone -PhoneNumber $user.HomePhone -Fax $user.Fax -FirstName $user.FirstName -LastName $user.LastName -Office $user.Office -UsageLocation $user.UsageLocation -DisplayName $user.DisplayName -Title $user.Title -Password $user.Password -ForceChangePassword $false -LicenseAssignment $msolSKU.AccountSkuId 
                }
}
}