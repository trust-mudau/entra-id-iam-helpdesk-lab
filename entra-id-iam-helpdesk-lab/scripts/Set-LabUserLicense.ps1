[CmdletBinding(SupportsShouldProcess=$true)]
param(
  [Parameter(Mandatory=$true)][string]$UserPrincipalName,
  [Parameter(Mandatory=$true)][string]$SkuPartNumber,
  [ValidateSet('Assign','Remove')][string]$Action='Assign'
)
$ErrorActionPreference='Stop'
Import-Module Microsoft.Graph.Users.Actions
Import-Module Microsoft.Graph.Identity.DirectoryManagement
Import-Module Microsoft.Graph.Users
$u=Get-MgUser -UserId $UserPrincipalName
$sku=Get-MgSubscribedSku -All | Where-Object SkuPartNumber -eq $SkuPartNumber
if (-not $sku) { throw "SKU not found: $SkuPartNumber" }
if ($Action -eq 'Assign') {
  if ($PSCmdlet.ShouldProcess($UserPrincipalName,"Assign $SkuPartNumber")) { Set-MgUserLicense -UserId $u.Id -AddLicenses @(@{SkuId=$sku.SkuId}) -RemoveLicenses @() | Out-Null }
} else {
  if ($PSCmdlet.ShouldProcess($UserPrincipalName,"Remove $SkuPartNumber")) { Set-MgUserLicense -UserId $u.Id -AddLicenses @() -RemoveLicenses @($sku.SkuId) | Out-Null }
}
Get-MgUserLicenseDetail -UserId $u.Id | Select-Object SkuId,SkuPartNumber
