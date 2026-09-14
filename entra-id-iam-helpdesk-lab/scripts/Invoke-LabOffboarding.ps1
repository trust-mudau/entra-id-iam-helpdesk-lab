[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$true)][string]$UserPrincipalName,
    [switch]$RemoveDirectLicenses,
    [string[]]$DoNotRemoveGroups = @(),
    [string]$EvidenceCsv = './offboarding-verification.csv'
)

$ErrorActionPreference='Stop'
Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Groups
Import-Module Microsoft.Graph.Users.Actions

$user=Get-MgUser -UserId $UserPrincipalName -Property Id,DisplayName,UserPrincipalName,AssignedLicenses,AccountEnabled
if (-not $user) { throw "User not found: $UserPrincipalName" }
Write-Host "Offboarding $($user.DisplayName) [$UserPrincipalName]" -ForegroundColor Cyan

if ($PSCmdlet.ShouldProcess($UserPrincipalName,'Disable account sign-in')) {
    Update-MgUser -UserId $user.Id -AccountEnabled:$false
}
if ($PSCmdlet.ShouldProcess($UserPrincipalName,'Revoke sign-in sessions')) {
    Revoke-MgUserSignInSession -UserId $user.Id | Out-Null
}

$memberships=Get-MgUserMemberOf -UserId $user.Id -All
foreach ($m in $memberships) {
    if ($m.AdditionalProperties['@odata.type'] -ne '#microsoft.graph.group') { continue }
    $name=$m.AdditionalProperties['displayName']
    if ($DoNotRemoveGroups -contains $name) { Write-Warning "Preserving excluded group: $name"; continue }
    try {
        if ($PSCmdlet.ShouldProcess("$UserPrincipalName from $name",'Remove direct group membership')) {
            Remove-MgGroupMemberByRef -GroupId $m.Id -DirectoryObjectId $user.Id -ErrorAction Stop
        }
    } catch {
        Write-Warning "Could not remove $name. It may be dynamic or protected. $($_.Exception.Message)"
    }
}

if ($RemoveDirectLicenses) {
    $fresh=Get-MgUser -UserId $user.Id -Property AssignedLicenses
    $skuIds=@($fresh.AssignedLicenses | ForEach-Object {$_.SkuId})
    if ($skuIds.Count -gt 0 -and $PSCmdlet.ShouldProcess($UserPrincipalName,'Remove direct licenses')) {
        Set-MgUserLicense -UserId $user.Id -AddLicenses @() -RemoveLicenses $skuIds | Out-Null
    }
}

$verify=Get-MgUser -UserId $user.Id -Property AccountEnabled,AssignedLicenses
$remaining=Get-MgUserMemberOf -UserId $user.Id -All | Where-Object {$_.AdditionalProperties['@odata.type'] -eq '#microsoft.graph.group'}
[pscustomobject]@{
    UserPrincipalName=$UserPrincipalName
    AccountEnabled=$verify.AccountEnabled
    AssignedLicenseCount=$verify.AssignedLicenses.Count
    RemainingGroupCount=@($remaining).Count
    VerificationUtc=(Get-Date).ToUniversalTime().ToString('o')
} | Export-Csv $EvidenceCsv -NoTypeInformation
Write-Host "VERIFY enabled=$($verify.AccountEnabled), licenses=$($verify.AssignedLicenses.Count), remainingGroups=$(@($remaining).Count)" -ForegroundColor Cyan
Write-Host "Exchange/data-retention handling remains a separate policy-controlled step." -ForegroundColor Yellow
