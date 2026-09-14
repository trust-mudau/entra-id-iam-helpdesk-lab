[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$true)][string]$CsvPath,
    [Parameter(Mandatory=$true)][string]$TenantDomain,
    [Parameter(Mandatory=$true)][securestring]$InitialPassword
)

$ErrorActionPreference='Stop'
Import-Module Microsoft.Graph.Users
$plain=[System.Net.NetworkCredential]::new('', $InitialPassword).Password
$users=Import-Csv $CsvPath
foreach ($u in $users) {
    $upn=($u.Alias+'@'+$TenantDomain).ToLower()
    $existing=Get-MgUser -Filter "userPrincipalName eq '$upn'" -ErrorAction SilentlyContinue
    if ($existing) { Write-Host "SKIP: $upn exists" -ForegroundColor Yellow; continue }
    $params=@{
      AccountEnabled=$true; DisplayName=$u.DisplayName; MailNickname=$u.Alias; UserPrincipalName=$upn;
      Department=$u.Department; JobTitle=$u.JobTitle; EmployeeId=$u.EmployeeId; UsageLocation=$u.UsageLocation;
      PasswordProfile=@{Password=$plain;ForceChangePasswordNextSignIn=$true}
    }
    if ($PSCmdlet.ShouldProcess($upn,'Create fictional lab user')) {
      New-MgUser @params | Out-Null
      Write-Host "CREATED: $upn" -ForegroundColor Green
    }
}
$plain=$null
