[CmdletBinding()]
param(
    [string[]]$Scopes = @(
        'User.ReadWrite.All',
        'Group.ReadWrite.All',
        'User.RevokeSessions.All',
        'LicenseAssignment.ReadWrite.All',
        'Organization.Read.All',
        'Directory.Read.All'
    )
)

$ErrorActionPreference='Stop'
Import-Module Microsoft.Graph.Authentication
Connect-MgGraph -Scopes $Scopes -NoWelcome
$ctx=Get-MgContext
Write-Host "Connected tenant: $($ctx.TenantId)" -ForegroundColor Green
Write-Host "Account: $($ctx.Account)" -ForegroundColor Cyan
Write-Host "Scopes:" ($ctx.Scopes -join ', ')
