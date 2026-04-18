# File for Current User, Current Host - $PROFILE.CurrentUserCurrentHost

oh-my-posh init pwsh --config "$HOME/Documents/posh2k/posh2k.toml" | Invoke-Expression

$localPwsh = Join-Path $env:USERPROFILE 'local.ps1'
if (Test-Path -LiteralPath $localPwsh) {
    . $localPwsh
}
