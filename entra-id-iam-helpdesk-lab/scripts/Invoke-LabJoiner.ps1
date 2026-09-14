[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$true)][string]$EmployeeId,
    [Parameter(Mandatory=$true)][string]$UsersCsv,
    [Parameter(Mandatory=$true)][string]$MembershipPlanCsv,
    [Parameter(Mandatory=$true)][string]$TenantDomain,
    [Parameter(Mandatory=$true)][securestring]$InitialPassword,
    [string]$SkuPartNumber
)

$ErrorActionPreference='Stop'
Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Groups
Import-Module Microsoft.Graph.Users.Actions
Import-Module Microsoft.Graph.Identity.DirectoryManagement

$u = Import-Csv $UsersCsv | Where-Object EmployeeId -eq $EmployeeId
if (-not $u) { throw "EmployeeId not found: $EmployeeId" }
$upn = ($u.Alias + '@' + $TenantDomain).ToLower()
$existing = Get-MgUser -Filter "userPrincipalName eq '$upn'" -ErrorAction SilentlyContinue

if (-not $existing) {
    $plain = [System.Net.NetworkCredential]::new('', $InitialPassword).Password
    $params = @{
        AccountEnabled = $true
        DisplayName = $u.DisplayName
        MailNickname = $u.Alias
        UserPrincipalName = $upn
        Department = $u.Department
        JobTitle = $u.JobTitle
        EmployeeId = $u.EmployeeId
        UsageLocation = $u.UsageLocation
        PasswordProfile = @{ Password=$plain; ForceChangePasswordNextSignIn=$true }
    }
    if ($PSCmdlet.ShouldProcess($upn,'Create lab user')) {
        $existing = New-MgUser @params
    }
    $plain = $null
} else {
    Write-Host "User already exists: $upn" -ForegroundColor Yellow
}

if (-not $existing) { $existing = Get-MgUser -UserId $upn }
$plans = Import-Csv $MembershipPlanCsv | Where-Object EmployeeId -eq $EmployeeId
foreach ($p in $plans) {
    $gname=$p.GroupName.Replace("'","''")
    $g=Get-MgGroup -Filter "displayName eq '$gname'" -ConsistencyLevel eventual
    if (-not $g) { throw "Missing group: $($p.GroupName)" }
    $members=Get-MgGroupMember -GroupId $g.Id -All
    if ($members.Id -notcontains $existing.Id -and $PSCmdlet.ShouldProcess("$upn -> $($p.GroupName)",'Add group membership')) {
        New-MgGroupMemberByRef -GroupId $g.Id -BodyParameter @{ '@odata.id'="https://graph.microsoft.com/v1.0/directoryObjects/$($existing.Id)" }
    }
}

if ($SkuPartNumber) {
    $sku = Get-MgSubscribedSku -All | Where-Object SkuPartNumber -eq $SkuPartNumber
    if (-not $sku) { throw "SKU not found: $SkuPartNumber" }
    if ($PSCmdlet.ShouldProcess($upn,"Assign license $SkuPartNumber")) {
        Set-MgUserLicense -UserId $existing.Id -AddLicenses @(@{SkuId=$sku.SkuId}) -RemoveLicenses @() | Out-Null
    }
}

# Independent verification
$verify=Get-MgUser -UserId $existing.Id -Property DisplayName,UserPrincipalName,Department,JobTitle,AccountEnabled,AssignedLicenses
Write-Host "VERIFY user=$($verify.UserPrincipalName) enabled=$($verify.AccountEnabled) department=$($verify.Department) licenses=$($verify.AssignedLicenses.Count)" -ForegroundColor Cyan
foreach ($p in $plans) {
    $g=Get-MgGroup -Filter "displayName eq '$($p.GroupName.Replace("'","''"))'" -ConsistencyLevel eventual
    $members=Get-MgGroupMember -GroupId $g.Id -All
    Write-Host "VERIFY group=$($p.GroupName) member=$($members.Id -contains $existing.Id)" -ForegroundColor Cyan
}
