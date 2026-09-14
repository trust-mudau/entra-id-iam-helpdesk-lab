[CmdletBinding(SupportsShouldProcess=$true)]
param(
  [Parameter(Mandatory=$true)][string]$Mailbox,
  [Parameter(Mandatory=$true)][string]$User,
  [ValidateSet('GrantFullAccess','RemoveFullAccess')][string]$Action
)
$ErrorActionPreference='Stop'
Import-Module ExchangeOnlineManagement
if (-not (Get-ConnectionInformation -ErrorAction SilentlyContinue)) {
  throw 'Connect to Exchange Online first with Connect-ExchangeOnline.'
}
if ($Action -eq 'GrantFullAccess') {
  if ($PSCmdlet.ShouldProcess("$User -> $Mailbox",'Grant FullAccess')) {
    Add-MailboxPermission -Identity $Mailbox -User $User -AccessRights FullAccess -InheritanceType All -AutoMapping:$true | Out-Null
  }
} else {
  if ($PSCmdlet.ShouldProcess("$User -> $Mailbox",'Remove FullAccess')) {
    Remove-MailboxPermission -Identity $Mailbox -User $User -AccessRights FullAccess -InheritanceType All -Confirm:$false
  }
}
Write-Host 'Verification:' -ForegroundColor Cyan
Get-EXOMailboxPermission -Identity $Mailbox | Where-Object {$_.User -like "*$User*"} | Format-Table User,AccessRights,Deny,IsInherited
