# Make Scoop commands available even before a Windows sign-out refreshes the user environment.
$scoopShims = Join-Path $HOME 'scoop\shims'
$starshipDir = Join-Path $HOME 'scoop\apps\starship\current'
foreach ($pathEntry in @($scoopShims, $starshipDir)) {
    if (($env:Path -split ';') -notcontains $pathEntry) {
        $env:Path = $pathEntry + ';' + $env:Path
    }
}

# Use Neovim as the default terminal editor.
$env:EDITOR = 'nvim'
$env:VISUAL = 'nvim'

# PSReadLine: history search, predictions, and an ergonomic editing baseline.
Import-Module PSReadLine
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -HistoryNoDuplicates
if (-not [Console]::IsOutputRedirected) {
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
}
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# fzf: Ctrl+R searches command history; Ctrl+T inserts a selected path.
Set-PSReadLineKeyHandler -Chord 'Ctrl+r' -ScriptBlock {
    $historyPath = (Get-PSReadLineOption).HistorySavePath
    if (-not (Test-Path -LiteralPath $historyPath)) {
        return
    }

    $selection = Get-Content -LiteralPath $historyPath |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        Select-Object -Unique |
        fzf --tac --no-sort --height=40% --layout=reverse --border

    if ($selection) {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($selection)
    }
}

Set-PSReadLineKeyHandler -Chord 'Ctrl+t' -ScriptBlock {
    $selection = fzf --walker=file,dir,follow,hidden --scheme=path --height=40% --layout=reverse --border
    if ($selection) {
        $insertText = if ($selection -match '\s') {
            "'" + $selection.Replace("'", "''") + "'"
        } else {
            $selection
        }
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($insertText)
    }
}

# Starship Pure preset.
$env:STARSHIP_CONFIG = Join-Path $HOME '.config\starship.toml'
$starshipExe = Join-Path $HOME 'scoop\apps\starship\current\starship.exe'
Invoke-Expression (& $starshipExe init powershell)

# zoxide must initialize after Starship so its directory-tracking prompt hook
# wraps the final prompt implementation instead of being overwritten by it.
Invoke-Expression (& zoxide init powershell | Out-String)
