[CmdletBinding(SupportsShouldProcess)]
param(
    [ValidateSet('PowerShell', 'Starship', 'Neovim', 'AutoHotkey', 'Terminal', 'Ditto')]
    [string[]] $Component,

    [switch] $BackupExisting
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$documents = [Environment]::GetFolderPath('MyDocuments')
$backupSuffix = Get-Date -Format 'yyyyMMdd-HHmmss'
$strictUtf8 = [System.Text.UTF8Encoding]::new($false, $true)

$links = @(
    [PSCustomObject]@{
        Id = 'PowerShell'
        Name = 'PowerShell profile'
        Source = Join-Path $repoRoot 'windows\powershell\Microsoft.PowerShell_profile.ps1'
        Target = $PROFILE.CurrentUserCurrentHost
        Format = 'Utf8'
    }
    [PSCustomObject]@{
        Id = 'Starship'
        Name = 'Starship config'
        Source = Join-Path $repoRoot 'windows\starship\starship.toml'
        Target = Join-Path $HOME '.config\starship.toml'
        Format = 'Utf8'
    }
    [PSCustomObject]@{
        Id = 'Neovim'
        Name = 'Neovim config directory'
        Source = Join-Path $repoRoot 'windows\neovim'
        Target = Join-Path $env:LOCALAPPDATA 'nvim'
        Format = 'Utf8Directory'
    }
    [PSCustomObject]@{
        Id = 'AutoHotkey'
        Name = 'AutoHotkey config'
        Source = Join-Path $repoRoot 'windows\app-hotkeys.ahk'
        Target = Join-Path $documents 'AutoHotkey\app-hotkeys.ahk'
        Format = 'Utf8'
    }
    [PSCustomObject]@{
        Id = 'Terminal'
        Name = 'Windows Terminal settings'
        Source = Join-Path $repoRoot 'windows\terminal\settings.json'
        Target = Join-Path $env:USERPROFILE 'scoop\persist\windows-terminal\settings\settings.json'
        Format = 'Json'
    }
    [PSCustomObject]@{
        Id = 'Ditto'
        Name = 'Ditto settings'
        Source = Join-Path $repoRoot 'windows\ditto\Ditto.Settings'
        Target = Join-Path $env:USERPROFILE 'scoop\persist\ditto\Ditto.Settings'
        Format = 'Binary'
    }
)

if ($Component) {
    $links = @($links | Where-Object { $_.Id -in $Component })
}

function Get-NormalizedPath {
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    [System.IO.Path]::GetFullPath($Path).TrimEnd('\')
}

function Get-SymbolicLinkTarget {
    param(
        [Parameter(Mandatory)]
        [System.IO.FileSystemInfo] $Item
    )

    $linkTarget = @($Item.Target)[0]
    if ([string]::IsNullOrWhiteSpace($linkTarget)) {
        return $null
    }

    if (-not [System.IO.Path]::IsPathRooted($linkTarget)) {
        $linkTarget = Join-Path $Item.DirectoryName $linkTarget
    }

    Get-NormalizedPath $linkTarget
}

function Test-CorrectSymbolicLink {
    param(
        [Parameter(Mandatory)]
        [string] $Source,

        [Parameter(Mandatory)]
        [string] $Target
    )

    $existing = Get-Item -LiteralPath $Target -Force -ErrorAction SilentlyContinue
    if ($null -eq $existing -or $existing.LinkType -ne 'SymbolicLink') {
        return $false
    }

    (Get-SymbolicLinkTarget -Item $existing) -eq (Get-NormalizedPath $Source)
}

function Assert-Utf8File {
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    try {
        $null = $strictUtf8.GetString([System.IO.File]::ReadAllBytes($Path))
    }
    catch {
        throw "File is not valid UTF-8: $Path"
    }
}

function Assert-JsonFile {
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    Assert-Utf8File -Path $Path
    $text = $strictUtf8.GetString([System.IO.File]::ReadAllBytes($Path))
    try {
        $null = $text | ConvertFrom-Json
    }
    catch {
        throw "File is not valid JSON: $Path`n$($_.Exception.Message)"
    }
}

function Test-IsElevated {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-DeveloperMode {
    $key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock'
    $value = Get-ItemPropertyValue -LiteralPath $key `
        -Name AllowDevelopmentWithoutDevLicense -ErrorAction SilentlyContinue
    $value -eq 1
}

# Validate every selected source before changing any target. Symbolic links do
# not transcode files, so the exact UTF-8 bytes in the repository remain the
# bytes read by the applications.
foreach ($link in $links) {
    if (-not (Test-Path -LiteralPath $link.Source)) {
        throw "Source does not exist: $($link.Source)"
    }

    switch ($link.Format) {
        'Utf8' {
            Assert-Utf8File -Path $link.Source
        }
        'Json' {
            Assert-JsonFile -Path $link.Source
        }
        'Utf8Directory' {
            foreach ($file in Get-ChildItem -LiteralPath $link.Source -File -Recurse) {
                Assert-Utf8File -Path $file.FullName
                if ($file.Extension -eq '.json') {
                    Assert-JsonFile -Path $file.FullName
                }
            }
        }
    }
}

$needsLinkCreation = $false
foreach ($link in $links) {
    if (-not (Test-CorrectSymbolicLink -Source $link.Source -Target $link.Target)) {
        $needsLinkCreation = $true
        break
    }
}

if ($needsLinkCreation -and -not $WhatIfPreference -and -not (Test-IsElevated) -and -not (Test-DeveloperMode)) {
    throw @'
Creating symbolic links as a standard user requires Windows Developer Mode.
Enable Settings > System > Advanced > For developers > Developer Mode, then run this script again.
Alternatively, run PowerShell as Administrator.
'@
}

$results = foreach ($link in $links) {
    $sourcePath = Get-NormalizedPath $link.Source
    $targetPath = Get-NormalizedPath $link.Target
    $targetParent = Split-Path -Parent $targetPath

    if (Test-CorrectSymbolicLink -Source $sourcePath -Target $targetPath) {
        [PSCustomObject]@{
            Component = $link.Id
            Status = 'Already linked'
            Target = $targetPath
            Source = $sourcePath
            Backup = $null
        }
        continue
    }

    $existing = Get-Item -LiteralPath $targetPath -Force -ErrorAction SilentlyContinue
    $backupPath = $null
    if ($null -ne $existing) {
        if (-not $BackupExisting) {
            throw "Target already exists: $targetPath. Re-run with -BackupExisting to preserve and replace it."
        }

        $backupPath = "$targetPath.backup-$backupSuffix"
        if (Test-Path -LiteralPath $backupPath) {
            throw "Backup path already exists: $backupPath"
        }
    }

    if (-not $PSCmdlet.ShouldProcess($targetPath, "Link to $sourcePath")) {
        [PSCustomObject]@{
            Component = $link.Id
            Status = 'Would link'
            Target = $targetPath
            Source = $sourcePath
            Backup = $backupPath
        }
        continue
    }

    if (-not (Test-Path -LiteralPath $targetParent)) {
        New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
    }

    if ($null -ne $backupPath) {
        Move-Item -LiteralPath $targetPath -Destination $backupPath
    }

    try {
        New-Item -ItemType SymbolicLink -Path $targetPath -Target $sourcePath | Out-Null
        if (-not (Test-CorrectSymbolicLink -Source $sourcePath -Target $targetPath)) {
            throw "Symbolic-link verification failed: $targetPath"
        }
        if ($link.Format -eq 'Json') {
            Assert-JsonFile -Path $targetPath
        }
    }
    catch {
        if (Test-Path -LiteralPath $targetPath) {
            Remove-Item -LiteralPath $targetPath -Force
        }
        if ($null -ne $backupPath -and (Test-Path -LiteralPath $backupPath)) {
            Move-Item -LiteralPath $backupPath -Destination $targetPath
        }
        throw
    }

    [PSCustomObject]@{
        Component = $link.Id
        Status = 'Linked'
        Target = $targetPath
        Source = $sourcePath
        Backup = $backupPath
    }
}

$results | Format-Table Component, Status, Target, Source, Backup -AutoSize

if ('AutoHotkey' -in $links.Id) {
    $autoHotkeyExe = Join-Path $HOME 'scoop\apps\autohotkey\current\v2\AutoHotkey64.exe'
    $autoHotkeyScript = Join-Path $documents 'AutoHotkey\app-hotkeys.ahk'
    if (-not (Test-Path -LiteralPath $autoHotkeyExe -PathType Leaf)) {
        throw "AutoHotkey v2 interpreter does not exist: $autoHotkeyExe"
    }

    $runKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
    $runName = 'AutoHotkeyAppHotkeys'
    $desiredCommand = '"{0}" "{1}"' -f $autoHotkeyExe, $autoHotkeyScript
    $currentCommand = Get-ItemPropertyValue -LiteralPath $runKey -Name $runName `
        -ErrorAction SilentlyContinue

    if ($currentCommand -ne $desiredCommand -and
        $PSCmdlet.ShouldProcess("$runKey\$runName", 'Set AutoHotkey startup command')) {
        Set-ItemProperty -LiteralPath $runKey -Name $runName -Value $desiredCommand
        $currentCommand = Get-ItemPropertyValue -LiteralPath $runKey -Name $runName
    }

    if (-not $WhatIfPreference -and $currentCommand -ne $desiredCommand) {
        throw "AutoHotkey startup-command verification failed: $runName"
    }
}
