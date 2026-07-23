[CmdletBinding(SupportsShouldProcess)]
param(
    [switch] $BackupExisting
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$documents = [Environment]::GetFolderPath('MyDocuments')
$backupSuffix = Get-Date -Format 'yyyyMMdd-HHmmss'

$links = @(
    [PSCustomObject]@{
        Name = 'PowerShell profile'
        Source = Join-Path $repoRoot 'windows\powershell\Microsoft.PowerShell_profile.ps1'
        Target = $PROFILE.CurrentUserCurrentHost
    }
    [PSCustomObject]@{
        Name = 'Starship config'
        Source = Join-Path $repoRoot 'windows\starship\starship.toml'
        Target = Join-Path $HOME '.config\starship.toml'
    }
    [PSCustomObject]@{
        Name = 'Neovim config directory'
        Source = Join-Path $repoRoot 'windows\neovim'
        Target = Join-Path $env:LOCALAPPDATA 'nvim'
    }
    [PSCustomObject]@{
        Name = 'AutoHotkey config'
        Source = Join-Path $repoRoot 'windows\app-hotkeys.ahk'
        Target = Join-Path $documents 'AutoHotkey\app-hotkeys.ahk'
    }
    [PSCustomObject]@{
        Name = 'Windows Terminal settings'
        Source = Join-Path $repoRoot 'windows\terminal\settings.json'
        Target = Join-Path $env:USERPROFILE 'scoop\persist\windows-terminal\settings\settings.json'
    }
    [PSCustomObject]@{
        Name = 'Ditto settings'
        Source = Join-Path $repoRoot 'windows\ditto\Ditto.Settings'
        Target = Join-Path $env:USERPROFILE 'scoop\persist\ditto\Ditto.Settings'
    }
)

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

$results = foreach ($link in $links) {
    if (-not (Test-Path -LiteralPath $link.Source)) {
        throw "Source does not exist: $($link.Source)"
    }

    $sourcePath = Get-NormalizedPath $link.Source
    $targetPath = Get-NormalizedPath $link.Target
    $targetParent = Split-Path -Parent $targetPath

    if (-not (Test-Path -LiteralPath $targetParent)) {
        New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
    }

    $existing = Get-Item -LiteralPath $targetPath -Force -ErrorAction SilentlyContinue
    if ($null -ne $existing -and $existing.LinkType -eq 'SymbolicLink') {
        $existingTarget = Get-SymbolicLinkTarget $existing
        if ($existingTarget -eq $sourcePath) {
            [PSCustomObject]@{
                Name = $link.Name
                Target = $targetPath
                Source = $sourcePath
                Backup = $null
                Status = 'Already linked'
            }
            continue
        }
    }

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
            Name = $link.Name
            Target = $targetPath
            Source = $sourcePath
            Backup = $backupPath
            Status = 'Would link'
        }
        continue
    }

    if ($null -ne $backupPath) {
        Move-Item -LiteralPath $targetPath -Destination $backupPath
    }

    try {
        New-Item -ItemType SymbolicLink -Path $targetPath -Target $sourcePath | Out-Null
    }
    catch {
        if ($null -ne $backupPath -and -not (Test-Path -LiteralPath $targetPath)) {
            Move-Item -LiteralPath $backupPath -Destination $targetPath
        }
        throw
    }

    [PSCustomObject]@{
        Name = $link.Name
        Target = $targetPath
        Source = $sourcePath
        Backup = $backupPath
        Status = 'Linked'
    }
}

$results | Format-Table Name, Status, Target, Source, Backup -AutoSize
