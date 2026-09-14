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

$user=Get-MgUser -UserId $UserPrincipalName -Property Id,DisplayName,UserPrincipalName,AssignedLicenses,LicenseAssignmentStates,AccountEnabled
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
    $fresh=Get-MgUser -UserId $user.Id -Property AssignedLicenses,LicenseAssignmentStates
    # A null AssignedByGroup indicates a direct license assignment. Group-inherited
    # licenses must be removed by changing the relevant group membership instead.
    $directSkuIds=@(
        $fresh.LicenseAssignmentStates |
        Where-Object { -not $_.AssignedByGroup -and $_.SkuId } |
        Select-Object -ExpandProperty SkuId -Unique
    )
    if ($directSkuIds.Count -gt 0 -and $PSCmdlet.ShouldProcess($UserPrincipalName,'Remove directly assigned licenses')) {
        Set-MgUserLicense -UserId $user.Id -AddLicenses @() -RemoveLicenses $directSkuIds | Out-Null
    }
}

$verify=Get-MgUser -UserId $user.Id -Property AccountEnabled,AssignedLicenses,LicenseAssignmentStates
$remaining=Get-MgUserMemberOf -UserId $user.Id -All | Where-Object {$_.AdditionalProperties['@odata.type'] -eq '#microsoft.graph.group'}
$remainingDirectLicenses=@(
    $verify.LicenseAssignmentStates |
    Where-Object { -not $_.AssignedByGroup -and $_.SkuId }
).Count

[pscustomobject]@{
    UserPrincipalName=$UserPrincipalName
    AccountEnabled=$verify.AccountEnabled
    AssignedLicenseCount=$verify.AssignedLicenses.Count
    RemainingDirectLicenseCount=$remainingDirectLicenses
    RemainingGroupCount=@($remaining).Count
    VerificationUtc=(Get-Date).ToUniversalTime().ToString('o')
} | Export-Csv $EvidenceCsv -NoTypeInformation
Write-Host "VERIFY enabled=$($verify.AccountEnabled), totalLicenses=$($verify.AssignedLicenses.Count), directLicenses=$remainingDirectLicenses, remainingGroups=$(@($remaining).Count)" -ForegroundColor Cyan
Write-Host "Exchange/data-retention handling remains a separate policy-controlled step." -ForegroundColor Yellow
