# Cache static system info once at startup for maximum prompt performance
$global:__isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$global:__computerName = $env:COMPUTERNAME

# Custom fast and lightweight prompt (ported from https://github.com/2kabhishek/dots2k/blob/main/config/shell/prompt.sh)
function prompt {
    $lastExitCode = $global:LASTEXITCODE

    $esc = [char]27
    $reset = "$esc[0m"
    $bold_blue = "$esc[1;34m"
    $blue = "$esc[34m"
    $green = "$esc[32m"
    $yellow = "$esc[33m"
    $bold_yellow = "$esc[1;33m"
    $cyan = "$esc[36m"
    $red = "$esc[31m"
    $bold_red = "$esc[1;31m"
    $bg_yellow_fg_black = "$esc[43;30m"

    if ($global:__isAdmin) {
        $user_part = "$bg_yellow_fg_black$env:USERNAME$reset"
        $prompt_char = "#"
    } else {
        $user_part = "$cyan$env:USERNAME$reset"
        $prompt_char = "$"
    }

    $prompt_char_part = "$bold_red$prompt_char$reset "
    $host_part = "$green$global:__computerName$reset"

    $path = $ExecutionContext.SessionState.Path.CurrentLocation.Path
    if ($path.StartsWith($HOME, [System.StringComparison]::OrdinalIgnoreCase)) {
        $path = "~" + $path.Substring($HOME.Length)
    }
    $dir_part = "$bold_yellow$path$reset"

    $git_part = ""
    $current = $ExecutionContext.SessionState.Path.CurrentLocation.ProviderPath
    $isGit = $false
    while ($current) {
        if ([System.IO.Directory]::Exists([System.IO.Path]::Combine($current, ".git")) -or [System.IO.File]::Exists([System.IO.Path]::Combine($current, ".git"))) {
            $isGit = $true
            break
        }
        $parent = [System.IO.Path]::GetDirectoryName($current)
        if ($parent -eq $current -or [string]::IsNullOrEmpty($parent)) { break }
        $current = $parent
    }

    if ($isGit) {
        [array]$status = git status --porcelain -b 2>$null
        if ($status) {
            $firstLine = $status[0]
            $branch = ""
            if ($firstLine -match '^##\s+([^\s]+)') {
                $branch = $Matches[1]
                if ($branch -match '^(.+)\.\.\.') {
                    $branch = $Matches[1]
                }
            }

            $status_color = $green
            $status_char = "o"
            if ($status.Count -gt 1) {
                $status_color = $red
                $status_char = "x"
            }
            $git_part = " on ${blue}git${cyan}:${branch}${status_color} ${status_char}${reset}"
        }
    }

    $time_esc = [System.DateTime]::Now.ToString("hh:mm:ss tt")

    $exit_part = ""
    if ($lastExitCode -and $lastExitCode -ne 0) {
        $exit_part = " ${red}C:$lastExitCode${reset}"
    }

    return "`n${bold_blue}#${reset} ${user_part} @ ${host_part} in ${dir_part}${git_part} ${time_esc}${exit_part}`n${prompt_char_part}"
}
