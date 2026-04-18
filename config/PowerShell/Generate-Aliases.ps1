param(
    [string]$Source,
    [string]$Output
)

if (-not $Source) {
    $Source = Join-Path $PSScriptRoot '..\..\dots2k\config\shell\aliases.sh'
}
if (-not $Output) {
    $Output = Join-Path $PSScriptRoot 'aliases.gen.ps1'
}

$Source = Resolve-Path $Source

$lines = @("# Generated from dots2k\config\shell\aliases.sh - do not edit manually")
foreach ($line in Get-Content $Source) {
    if ($line -match '^\s*alias\s+([^=]+)=(.+)$') {
        $name = $Matches[1].Trim()
        $value = $Matches[2].Trim()
        if (($value.StartsWith('"') -and $value.EndsWith('"')) -or
            ($value.StartsWith("'") -and $value.EndsWith("'"))) {
            $value = $value.Substring(1, $value.Length - 2)
        }
        $cmd = $value.Replace("'", "''")
        $lines += "Bash-Alias $name '${cmd} @args'"
    }
}

Set-Content -Path $Output -Value ($lines -join "`n") -NoNewline
Write-Host "Wrote $($lines.Count - 1) aliases to $Output"
