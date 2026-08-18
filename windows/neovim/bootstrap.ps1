[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$nvim = Join-Path $HOME 'scoop\apps\neovim\current\bin\nvim.exe'
if (-not (Test-Path -LiteralPath $nvim -PathType Leaf)) {
    throw "Neovim executable does not exist: $nvim"
}

function Install-Libgit2 {
    $version = '1.7.2'
    $expectedCommit = 'a418d9d4ab87bae16b87d8f37143a4687ae0e4b2'
    $dataDirectory = Join-Path $env:LOCALAPPDATA 'nvim-data'
    $installDirectory = Join-Path $dataDirectory 'libgit2'
    $library = Join-Path $installDirectory 'bin\libgit2.dll'
    if (Test-Path -LiteralPath $library -PathType Leaf) {
        return
    }

    foreach ($command in @('git', 'cmake', 'ninja', 'gcc')) {
        if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
            throw "Building libgit2 requires '$command' on PATH."
        }
    }

    $sourceDirectory = Join-Path $dataDirectory "libgit2-source-v$version"
    if (-not (Test-Path -LiteralPath (Join-Path $sourceDirectory '.git'))) {
        if (Test-Path -LiteralPath $sourceDirectory) {
            throw "libgit2 source path exists but is not a Git repository: $sourceDirectory"
        }

        Write-Host "==> Clone libgit2 v$version"
        & git clone --branch "v$version" --depth 1 `
            'https://github.com/libgit2/libgit2.git' $sourceDirectory
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to clone libgit2 v$version."
        }
    }

    $actualCommit = (& git -C $sourceDirectory rev-parse HEAD).Trim()
    if ($LASTEXITCODE -ne 0 -or $actualCommit -ne $expectedCommit) {
        throw "libgit2 source revision mismatch: expected=$expectedCommit actual=$actualCommit"
    }

    $sourceStatus = @(& git -C $sourceDirectory status --porcelain)
    if ($LASTEXITCODE -ne 0 -or $sourceStatus.Count -ne 0) {
        throw "libgit2 source repository is dirty: $sourceDirectory"
    }

    $buildDirectory = Join-Path $sourceDirectory 'build'
    Write-Host "==> Build libgit2 v$version"
    & cmake -S $sourceDirectory -B $buildDirectory -G Ninja `
        -DCMAKE_BUILD_TYPE=Release `
        "-DCMAKE_INSTALL_PREFIX=$installDirectory" `
        -DBUILD_TESTS=OFF `
        -DBUILD_CLI=OFF `
        -DUSE_SSH=OFF
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to configure libgit2 v$version."
    }

    & cmake --build $buildDirectory --target install
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to build libgit2 v$version."
    }
    if (-not (Test-Path -LiteralPath $library -PathType Leaf)) {
        throw "libgit2 build artifact is missing: $library"
    }
}

function Invoke-NvimStep {
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string[]] $Arguments
    )

    Write-Host "==> $Name"
    $errorGate = "+lua if vim.v.errmsg ~= '' then vim.api.nvim_err_writeln(vim.v.errmsg); vim.cmd('cquit 1') end"
    & $nvim @Arguments $errorGate '+qa'
    if ($LASTEXITCODE -ne 0) {
        throw "$Name failed with exit code $LASTEXITCODE"
    }
}

function Reset-GeneratedHelpTags {
    $vimCdocDirectory = Join-Path $env:LOCALAPPDATA 'nvim-data\lazy\vimcdoc'
    $localizedTags = Join-Path $vimCdocDirectory 'doc\tags-cn'
    if ((Test-Path -LiteralPath (Join-Path $vimCdocDirectory '.git')) -and
        (Test-Path -LiteralPath $localizedTags)) {
        & git -C $vimCdocDirectory restore --source=HEAD -- doc/tags-cn
        if ($LASTEXITCODE -ne 0) {
            throw 'Failed to reset vimcdoc generated help tags.'
        }
    }
}

function Assert-LazyLock {
    $lockPath = Join-Path $PSScriptRoot 'lazy-lock.json'
    $lock = Get-Content -LiteralPath $lockPath -Raw -Encoding utf8 | ConvertFrom-Json
    $lazyDirectory = Join-Path $env:LOCALAPPDATA 'nvim-data\lazy'
    $count = 0

    foreach ($entry in $lock.PSObject.Properties) {
        $count++
        $pluginDirectory = Join-Path $lazyDirectory $entry.Name
        if (-not (Test-Path -LiteralPath (Join-Path $pluginDirectory '.git'))) {
            throw "Locked plugin repository is missing: $($entry.Name)"
        }

        $head = (& git -C $pluginDirectory rev-parse HEAD).Trim()
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to read plugin revision: $($entry.Name)"
        }
        if ($head -ne $entry.Value.commit) {
            throw "Plugin revision mismatch: $($entry.Name) expected=$($entry.Value.commit) actual=$head"
        }

        $status = @(& git -C $pluginDirectory status --porcelain)
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to read plugin status: $($entry.Name)"
        }
        if ($status.Count -ne 0) {
            throw "Plugin repository is dirty: $($entry.Name)`n$($status -join "`n")"
        }
    }

    Write-Host "Validated $count locked plugin repositories."
}

Install-Libgit2

# Keep plugin installation reproducible: install missing repositories, restore
# every repository to lazy-lock.json, remove unmanaged plugin directories, then
# run all declared build steps. Unlike `Lazy sync`, this does not update locks.
Invoke-NvimStep -Name 'Install missing plugins' -Arguments @(
    '--headless',
    '+Lazy! install'
)
Reset-GeneratedHelpTags
Invoke-NvimStep -Name 'Restore plugins from lazy-lock.json' -Arguments @(
    '--headless',
    '+Lazy! restore'
)
Reset-GeneratedHelpTags
Invoke-NvimStep -Name 'Remove unmanaged plugin directories' -Arguments @(
    '--headless',
    '+Lazy! clean'
)

$lazyDirectory = Join-Path $env:LOCALAPPDATA 'nvim-data\lazy'
$fzfLibrary = Join-Path $lazyDirectory 'telescope-fzf-native.nvim\build\libfzf.dll'
if (-not (Test-Path -LiteralPath $fzfLibrary -PathType Leaf)) {
    Invoke-NvimStep -Name 'Build telescope-fzf-native.nvim' -Arguments @(
        '--headless',
        '+Lazy! build telescope-fzf-native.nvim'
    )
}
if (-not (Test-Path -LiteralPath $fzfLibrary -PathType Leaf)) {
    throw "telescope-fzf-native.nvim build artifact is missing: $fzfLibrary"
}

$markdownPreviewDependency = Join-Path $lazyDirectory 'markdown-preview.nvim\app\node_modules\log4js\package.json'
if (-not (Test-Path -LiteralPath $markdownPreviewDependency -PathType Leaf)) {
    Invoke-NvimStep -Name 'Build markdown-preview.nvim' -Arguments @(
        '--headless',
        '+Lazy! build markdown-preview.nvim'
    )
}
if (-not (Test-Path -LiteralPath $markdownPreviewDependency -PathType Leaf)) {
    throw "markdown-preview.nvim dependencies are missing: $markdownPreviewDependency"
}
Assert-LazyLock

Invoke-NvimStep -Name 'Install Treesitter parsers' -Arguments @(
    '--headless',
    "+lua require('dotfiles.treesitter').install()"
)

$treesitterValidation = @"
local languages = require('dotfiles.treesitter').languages
for _, language in ipairs(languages) do
  assert(vim.treesitter.language.add(language), 'Treesitter parser is missing: ' .. language)
end
"@ -replace "`r?`n", ' '
Invoke-NvimStep -Name 'Validate Treesitter parsers' -Arguments @(
    '--headless',
    "+lua $treesitterValidation"
)

Invoke-NvimStep -Name 'Install missing Mason tools' -Arguments @(
    '--headless',
    "+lua require('dotfiles.mason').install_missing()"
)

Invoke-NvimStep -Name 'Validate Mason tools' -Arguments @(
    '--headless',
    "+lua require('dotfiles.mason').validate()"
)

Invoke-NvimStep -Name 'Initialize and validate nvim-java runtime packages' -Arguments @(
    '--headless',
    "+lua require('dotfiles.java').initialize()"
)

Write-Host 'Neovim bootstrap completed successfully.'
