[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$true)][string]$UserPrincipalName,
    [Parameter(Mandatory=$true)][string]$NewDepartment,
    [string]$NewJobTitle,
    [Parameter(Mandatory=$true)][string]$AccessMatrixCsv,
    [string]$BeforeExport = './mover-before.csv',
    [string]$AfterExport = './mover-after.csv'
)

$ErrorActionPreference='Stop'
Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Groups

$user=Get-MgUser -UserId $UserPrincipalName -Property Id,UserPrincipalName,Department,JobTitle
if (-not $user) { throw "User not found: $UserPrincipalName" }
$matrix=Import-Csv $AccessMatrixCsv
$departmentGroups=@($matrix | Where-Object AccessPurpose -eq 'Baseline department access' | Select-Object -ExpandProperty GroupName)
$newRow=$matrix | Where-Object { $_.Department -eq $NewDepartment -and $_.AccessPurpose -eq 'Baseline department access' }
if (-not $newRow) { throw "No baseline group configured for department: $NewDepartment" }
$newGroupName=$newRow.GroupName

function Get-DirectGroups($uid) {
    $objects=Get-MgUserMemberOf -UserId $uid -All
    foreach ($o in $objects) {
        if ($o.AdditionalProperties['@odata.type'] -eq '#microsoft.graph.group') {
            [pscustomobject]@{GroupId=$o.Id;GroupName=$o.AdditionalProperties['displayName']}
        }
    }
}
$before=@(Get-DirectGroups $user.Id)
$before | Export-Csv $BeforeExport -NoTypeInformation

foreach ($g in $before | Where-Object GroupName -in $departmentGroups) {
    if ($g.GroupName -ne $newGroupName -and $PSCmdlet.ShouldProcess("$UserPrincipalName from $($g.GroupName)",'Remove obsolete department membership')) {
        Remove-MgGroupMemberByRef -GroupId $g.GroupId -DirectoryObjectId $user.Id
    }
}

$target=Get-MgGroup -Filter "displayName eq '$($newGroupName.Replace("'","''"))'" -ConsistencyLevel eventual
if (-not $target) { throw "Missing target group $newGroupName" }
$current=Get-MgGroupMember -GroupId $target.Id -All
if ($current.Id -notcontains $user.Id -and $PSCmdlet.ShouldProcess("$UserPrincipalName -> $newGroupName",'Add new department membership')) {
    New-MgGroupMemberByRef -GroupId $target.Id -BodyParameter @{ '@odata.id'="https://graph.microsoft.com/v1.0/directoryObjects/$($user.Id)" }
}

$update=@{Department=$NewDepartment}
if ($NewJobTitle) { $update.JobTitle=$NewJobTitle }
if ($PSCmdlet.ShouldProcess($UserPrincipalName,"Update department to $NewDepartment")) { Update-MgUser -UserId $user.Id @update }

$after=@(Get-DirectGroups $user.Id)
$after | Export-Csv $AfterExport -NoTypeInformation
Write-Host "Mover verification complete. Review before/after exports and sensitive access separately." -ForegroundColor Green
