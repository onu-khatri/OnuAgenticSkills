[CmdletBinding()]
param(
    [string]$ProjectRoot = (Join-Path ([System.IO.Path]::GetTempPath()) ("agent-name-test-" + [guid]::NewGuid().ToString("N")))
)

$ErrorActionPreference = 'Stop'
$script:Failures = 0

$skillScripts = Join-Path $PSScriptRoot '..\scripts'
$resolveScript = Join-Path $skillScripts 'Resolve-AgentIdentity.ps1'
$reserveScript = Join-Path $skillScripts 'Reserve-AgentName.ps1'
$releaseScript = Join-Path $skillScripts 'Release-AgentName.ps1'

function Assert-Equal {
    param($Actual, $Expected, [string]$Message)
    if ($Actual -ne $Expected) {
        $script:Failures++
        Write-Host "FAIL: $Message" -ForegroundColor Red
        Write-Host "  Expected: [$Expected]" -ForegroundColor Red
        Write-Host "  Actual:   [$Actual]" -ForegroundColor Red
    }
    else {
        Write-Host "PASS: $Message" -ForegroundColor Green
    }
}

# 1. Picker name differs from the tool nickname -> nickname wins.
$r1 = & $resolveScript -ReservedName "Robert Downey Jr." -Nickname "Ramanujan" -Format object
Assert-Equal $r1.visible_name "Ramanujan" "different nickname: visible_name is the spawn nickname"
Assert-Equal $r1.reserved_name "Robert Downey Jr." "different nickname: reserved_name preserved as metadata"

# 2. Nickname is null/unavailable -> fall back to the reserved name.
$r2 = & $resolveScript -ReservedName "Robert Downey Jr." -Nickname $null -Format object
Assert-Equal $r2.visible_name "Robert Downey Jr." "null nickname: visible_name falls back to reserved name"
Assert-Equal $r2.reserved_name "Robert Downey Jr." "null nickname: reserved_name preserved"

# 3. Nickname matches the picker name -> identity is the same value.
$r3 = & $resolveScript -ReservedName "Robert Downey Jr." -Nickname "Robert Downey Jr." -Format object
Assert-Equal $r3.visible_name "Robert Downey Jr." "matching nickname: visible_name equals reserved name"

# 4. Closing the agent releases the reserved name.
& $reserveScript -Name "Iron Man" -SessionId "test-session" -ProjectRoot $ProjectRoot -Format json | Out-Null
$activePath = Join-Path $ProjectRoot '.tmp\agent-names\active.json'
$before = @(Get-Content -LiteralPath $activePath -Raw | ConvertFrom-Json | Where-Object { $_.name -eq 'Iron Man' })
Assert-Equal $before.Count 1 "close-release: reserved name is active before release"

$release = & $releaseScript -Name "Iron Man" -ProjectRoot $ProjectRoot -Format object
Assert-Equal $release.released $true "close-release: release reports released=true"

$after = @(Get-Content -LiteralPath $activePath -Raw | ConvertFrom-Json | Where-Object { $_.name -eq 'Iron Man' })
Assert-Equal $after.Count 0 "close-release: reserved name removed from active registry"

Remove-Item -LiteralPath $ProjectRoot -Recurse -Force -ErrorAction SilentlyContinue

if ($script:Failures -gt 0) {
    Write-Host "$script:Failures assertion(s) failed." -ForegroundColor Red
    exit 1
}
Write-Host "All agent identity tests passed." -ForegroundColor Green
exit 0
