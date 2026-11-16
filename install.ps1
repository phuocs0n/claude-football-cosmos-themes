# Installs the themes into the Claude Desktop Themes mod's own folder (%USERPROFILE%\.claude\themes-for-claude).
# Run from a clone:   powershell -ExecutionPolicy Bypass -File install.ps1
# Or straight from GitHub:
#   irm https://raw.githubusercontent.com/phuocs0n/claude-football-cosmos-themes/main/install.ps1 | iex
$ErrorActionPreference = 'Stop'
$ids = 'albiceleste', 'crimson-seventeen', 'canary-samba', 'cosmic-cliffs', 'spartan-sunset'
$raw = 'https://raw.githubusercontent.com/phuocs0n/claude-football-cosmos-themes/main/themes'
$dest = Join-Path $env:USERPROFILE '.claude\themes-for-claude'
New-Item -ItemType Directory -Force $dest | Out-Null

$local = if ($PSScriptRoot) { Join-Path $PSScriptRoot 'themes' } else { $null }
foreach ($id in $ids) {
  foreach ($ext in 'json', 'css') {
    $name = "$id.$ext"
    $out = Join-Path $dest $name
    if ($local -and (Test-Path (Join-Path $local $name))) {
      Copy-Item (Join-Path $local $name) $out -Force
    } else {
      Invoke-WebRequest -UseBasicParsing "$raw/$name" -OutFile $out
    }
  }
  Write-Host "installed $id"
}
Write-Host "Done. In Claude Desktop, run /themes and pick a theme in the 'Yours' tab."
