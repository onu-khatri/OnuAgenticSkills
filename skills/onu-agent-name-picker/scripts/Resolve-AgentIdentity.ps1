[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$ReservedName,
    [string]$Nickname,
    [ValidateSet('json', 'object')][string]$Format = 'json'
)

# The spawn_agent `nickname` is the authoritative chat-visible identity.
# The picker-reserved name is metadata only and serves as the fallback.
$visibleName = if ([string]::IsNullOrWhiteSpace($Nickname)) { $ReservedName } else { $Nickname }

$result = [pscustomobject][ordered]@{
    reserved_name = $ReservedName
    nickname      = $Nickname
    visible_name  = $visibleName
}

if ($Format -eq 'json') {
    ConvertTo-Json -InputObject $result -Depth 4
}
else {
    $result
}
