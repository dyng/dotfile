[CmdletBinding()]
param(
    [ValidateSet('Audit', 'Apply', 'Remove')]
    [string] $Action = 'Audit'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdministrator)) {
    $argumentLine = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -Action $Action"
    $process = Start-Process powershell.exe -Verb RunAs -ArgumentList $argumentLine -Wait -PassThru
    exit $process.ExitCode
}

$manifestPath = Join-Path $PSScriptRoot 'exclusions.psd1'
$manifest = Import-PowerShellDataFile -LiteralPath $manifestPath
$desiredPaths = @(
    $manifest.Paths |
        ForEach-Object { [Environment]::ExpandEnvironmentVariables($_) } |
        ForEach-Object { [IO.Path]::GetFullPath($_).TrimEnd('\') } |
        Sort-Object -Unique
)

$forbiddenPaths = @(
    [IO.Path]::GetPathRoot($env:SystemRoot).TrimEnd('\')
    [IO.Path]::GetFullPath($env:USERPROFILE).TrimEnd('\')
    [IO.Path]::GetFullPath($env:LOCALAPPDATA).TrimEnd('\')
    [IO.Path]::GetFullPath($env:TEMP).TrimEnd('\')
    [IO.Path]::GetFullPath((Join-Path $env:USERPROFILE 'scoop')).TrimEnd('\')
    [IO.Path]::GetFullPath((Join-Path $env:USERPROFILE 'scoop\apps')).TrimEnd('\')
)

foreach ($path in $desiredPaths) {
    if ($forbiddenPaths -contains $path) {
        throw "Refusing dangerously broad Defender exclusion: $path"
    }
}

function Get-CurrentExclusions {
    return @((Get-MpPreference).ExclusionPath | ForEach-Object {
        [IO.Path]::GetFullPath($_).TrimEnd('\')
    })
}

$before = Get-CurrentExclusions
$missing = @($desiredPaths | Where-Object { $before -notcontains $_ })
$managedPresent = @($desiredPaths | Where-Object { $before -contains $_ })

switch ($Action) {
    'Apply' {
        if ($missing.Count -gt 0) {
            Add-MpPreference -ExclusionPath $missing
        }
    }
    'Remove' {
        if ($managedPresent.Count -gt 0) {
            Remove-MpPreference -ExclusionPath $managedPresent
        }
    }
}

$after = Get-CurrentExclusions
$desiredPaths | ForEach-Object {
    [PSCustomObject]@{
        Path = $_
        Exists = Test-Path -LiteralPath $_
        Excluded = $after -contains $_
        Managed = $true
    }
} | Format-Table -AutoSize

$unmanaged = @($after | Where-Object { $desiredPaths -notcontains $_ })
if ($unmanaged.Count -gt 0) {
    Write-Host 'Existing exclusions not managed by this manifest:' -ForegroundColor Yellow
    $unmanaged | ForEach-Object { Write-Host "  $_" }
}
