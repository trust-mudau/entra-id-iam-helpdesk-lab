[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$modules = @('Microsoft.Graph','ExchangeOnlineManagement')
foreach ($m in $modules) {
    if (-not (Get-Module -ListAvailable -Name $m)) {
        Write-Host "Installing $m for CurrentUser..." -ForegroundColor Cyan
        Install-Module $m -Scope CurrentUser -Repository PSGallery -Force
    } else {
        Write-Host "$m already installed." -ForegroundColor Green
    }
}
Write-Host 'Prerequisites ready. Review module versions before production use.' -ForegroundColor Green
