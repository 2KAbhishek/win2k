# File for Current User, Current Host - $PROFILE.CurrentUserCurrentHost

function StartTiling {
    komorebic start -c "$Env:USERPROFILE\.config\komorebi\komorebi.json" --whkd
}

function StopTiling {
    taskkill /f /im komorebi.exe
}

oh-my-posh init pwsh --config "$HOME/Documents/posh2k/posh2k.omp.json" | Invoke-Expression
