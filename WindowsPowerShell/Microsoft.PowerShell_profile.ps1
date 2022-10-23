# File for Current User, Current Host - $PROFILE.CurrentUserCurrentHost
$Env:KOMOREBI_CONFIG_HOME = '$Home\.komorebi'
$Env:KOMOREBI_AHK_V2_EXE = 'C:\Program Files\AutoHotkey\v2.0-beta.12\AutoHotkey64.exe'

function Startup {
    Start-Process komorebi.exe -WindowStyle hidden
    Start-Process '$Env:KOMOREBI_AHK_V2_EXE' '$Env:KOMOREBI_CONFIG_HOME\mappings.ahk'
    Start-Process python.exe '$Home\Projects\yasb\src\main.py' -WindowStyle hidden
}

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression
