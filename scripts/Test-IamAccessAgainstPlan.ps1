[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$UsersExport,
  [Parameter(Mandatory=$true)][string]$MembershipExport,
  [Parameter(Mandatory=$true)][string]$UsersSource,
  [Parameter(Mandatory=$true)][string]$MembershipPlan,
  [string]$OutputCsv='./access-review-findings.csv'
)
$expectedUsers=Import-Csv $UsersSource
$plan=Import-Csv $MembershipPlan
$actualUsers=Import-Csv $UsersExport
$actualMembership=Import-Csv $MembershipExport
$findings=@()
foreach ($p in $plan) {
  $source=$expectedUsers | Where-Object EmployeeId -eq $p.EmployeeId
  if (-not $source) { continue }
  $actualU=$actualUsers | Where-Object EmployeeId -eq $p.EmployeeId
  if (-not $actualU) {
    $findings += [pscustomobject]@{Type='MissingUser';EmployeeId=$p.EmployeeId;User=$source.DisplayName;Group=$p.GroupName;Risk='High';Detail='Expected identity not found in exported tenant users'}
    continue
  }
  $hit=$actualMembership | Where-Object {$_.GroupName -eq $p.GroupName -and ($_.MemberUPN -eq $actualU.UserPrincipalName -or $_.MemberId -eq $actualU.Id)}
  if (-not $hit) {
    $findings += [pscustomobject]@{Type='MissingExpectedAccess';EmployeeId=$p.EmployeeId;User=$actualU.UserPrincipalName;Group=$p.GroupName;Risk='Medium';Detail="Expected by plan; approval=$($p.ApprovalReference)"}
  }
}
foreach ($u in $actualUsers | Where-Object {$_.AccountEnabled -eq 'False'}) {
  $residual=$actualMembership | Where-Object {$_.MemberUPN -eq $u.UserPrincipalName -or $_.MemberId -eq $u.Id}
  foreach ($r in $residual) {
    $findings += [pscustomobject]@{Type='DisabledUserResidualAccess';EmployeeId=$u.EmployeeId;User=$u.UserPrincipalName;Group=$r.GroupName;Risk='High';Detail='Disabled identity still has group membership; investigate whether expected or stale'}
  }
}
$findings | Export-Csv $OutputCsv -NoTypeInformation
Write-Host "Findings: $($findings.Count). Exported to $OutputCsv" -ForegroundColor Cyan
