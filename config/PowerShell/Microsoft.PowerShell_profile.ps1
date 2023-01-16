# File for Current User, Current Host - $PROFILE.CurrentUserCurrentHost

function StartTiling {
    # $Env:KOMOREBI_CONFIG_HOME = '$HOME\.komorebi'
    # $Env:KOMOREBI_AHK_V1_EXE = 'C:\Program Files\AutoHotkey\v1.1.34.04\AutoHotkeyU64.exe'
    # $Env:KOMOREBI_AHK_V2_EXE = 'C:\Program Files\AutoHotkey\v2.0-beta.12\AutoHotkey64.exe'
    Start-Process komorebi.exe -WindowStyle hidden
    # Start-Process 'C:\Program Files\AutoHotkey\v2.0-beta.12\AutoHotkey64.exe' 'C:\Users\DELL\komorebi.ahk'
    # Start-Process python.exe $Home\Projects\yasb\src\main.py  -WindowStyle hidden
}

function StopTiling {
    taskkill /f /im komorebi.exe
}

oh-my-posh init pwsh --config "$HOME/Documents/Posh2K/posh2k.omp.json" | Invoke-Expression
