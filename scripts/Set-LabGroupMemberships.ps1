[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$true)][string]$MembershipPlanCsv,
    [Parameter(Mandatory=$true)][string]$UsersCsv,
    [Parameter(Mandatory=$true)][string]$TenantDomain,
    [string[]]$ExcludeEmployeeId = @()
)

$ErrorActionPreference='Stop'
Import-Module Microsoft.Graph.Groups
Import-Module Microsoft.Graph.Users

$users = Import-Csv $UsersCsv
$plan = Import-Csv $MembershipPlanCsv
foreach ($p in $plan) {
    if ($ExcludeEmployeeId -contains $p.EmployeeId) {
        Write-Host "SKIP SCENARIO MEMBERSHIP: $($p.EmployeeId) -> $($p.GroupName)" -ForegroundColor DarkYellow
        continue
    }
    $source=$users | Where-Object EmployeeId -eq $p.EmployeeId
    if (-not $source) { Write-Warning "Employee not found in source: $($p.EmployeeId)"; continue }
    $upn=($source.Alias+'@'+$TenantDomain).ToLower()
    $u=Get-MgUser -UserId $upn -ErrorAction SilentlyContinue
    if (-not $u) { Write-Warning "User missing in tenant: $upn"; continue }
    $escaped=$p.GroupName.Replace("'","''")
    $g=Get-MgGroup -Filter "displayName eq '$escaped'" -ConsistencyLevel eventual
    if (-not $g) { Write-Warning "Group missing: $($p.GroupName)"; continue }
    $members=Get-MgGroupMember -GroupId $g.Id -All
    if ($members.Id -contains $u.Id) {
        Write-Host "OK: $upn already in $($p.GroupName)"
    } elseif ($PSCmdlet.ShouldProcess("$upn -> $($p.GroupName)","Add membership [$($p.AccessClass)] approval=$($p.ApprovalReference)")) {
        New-MgGroupMemberByRef -GroupId $g.Id -BodyParameter @{ '@odata.id'="https://graph.microsoft.com/v1.0/directoryObjects/$($u.Id)" }
        Write-Host "ADDED: $upn -> $($p.GroupName)" -ForegroundColor Green
    }
}
