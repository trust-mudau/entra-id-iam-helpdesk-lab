[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$true)][string]$AccessMatrixCsv
)

$ErrorActionPreference='Stop'
Import-Module Microsoft.Graph.Groups

$rows = Import-Csv $AccessMatrixCsv
$names = $rows.GroupName | Sort-Object -Unique
foreach ($name in $names) {
    $escaped = $name.Replace("'","''")
    $existing = Get-MgGroup -Filter "displayName eq '$escaped'" -ConsistencyLevel eventual -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "EXISTS: $name" -ForegroundColor Yellow
        continue
    }
    $nick = ($name -replace '[^a-zA-Z0-9]','').ToLower()
    if ($PSCmdlet.ShouldProcess($name,'Create Entra security group')) {
        New-MgGroup -DisplayName $name -MailEnabled:$false -MailNickname $nick -SecurityEnabled:$true | Out-Null
        Write-Host "CREATED: $name" -ForegroundColor Green
    }
}
