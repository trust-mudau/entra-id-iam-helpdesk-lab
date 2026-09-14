[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$OutputDirectory)
$ErrorActionPreference='Stop'
Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Groups
Import-Module Microsoft.Graph.Identity.DirectoryManagement
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$users=Get-MgUser -All -Property Id,DisplayName,UserPrincipalName,Department,JobTitle,EmployeeId,AccountEnabled,AssignedLicenses,UserType
$users | Select-Object Id,EmployeeId,DisplayName,UserPrincipalName,Department,JobTitle,UserType,AccountEnabled,@{n='AssignedLicenseCount';e={$_.AssignedLicenses.Count}} |
  Export-Csv (Join-Path $OutputDirectory 'users.csv') -NoTypeInformation
$groups=Get-MgGroup -All -Property Id,DisplayName,SecurityEnabled,MailEnabled,GroupTypes,MembershipRule
$groups | Select-Object Id,DisplayName,SecurityEnabled,MailEnabled,@{n='GroupTypes';e={$_.GroupTypes -join ';'}},MembershipRule |
  Export-Csv (Join-Path $OutputDirectory 'groups.csv') -NoTypeInformation
$membershipRows=foreach ($g in $groups) {
  $members=Get-MgGroupMember -GroupId $g.Id -All -ErrorAction SilentlyContinue
  foreach ($m in $members) {
    [pscustomobject]@{GroupId=$g.Id;GroupName=$g.DisplayName;MemberId=$m.Id;MemberDisplayName=$m.AdditionalProperties['displayName'];MemberUPN=$m.AdditionalProperties['userPrincipalName']}
  }
}
$membershipRows | Export-Csv (Join-Path $OutputDirectory 'group-memberships.csv') -NoTypeInformation
try {
  Get-MgSubscribedSku -All | Select-Object SkuId,SkuPartNumber,ConsumedUnits,@{n='EnabledUnits';e={$_.PrepaidUnits.Enabled}} |
    Export-Csv (Join-Path $OutputDirectory 'subscribed-skus.csv') -NoTypeInformation
} catch { Write-Warning "Could not export SKUs: $($_.Exception.Message)" }
Write-Host "Audit snapshot exported to $OutputDirectory" -ForegroundColor Green
