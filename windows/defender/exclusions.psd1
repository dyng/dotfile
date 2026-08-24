@{
    # Performance-first development paths. Defender skips real-time and
    # on-demand antivirus scanning for every path listed here.
    Paths = @(
        '%USERPROFILE%\worktrees'
        '%USERPROFILE%\projects'

        '%USERPROFILE%\.gradle'
        '%USERPROFILE%\.m2\repository'
        '%LOCALAPPDATA%\pnpm'
        '%LOCALAPPDATA%\pip\Cache'

        '%LOCALAPPDATA%\nvim-data'
        '%TEMP%\nvim'
        '%USERPROFILE%\scoop\apps\neovim'
        '%USERPROFILE%\scoop\apps\temurin21-jdk'
        '%USERPROFILE%\scoop\apps\temurin8-jdk'

        '%USERPROFILE%\scoop\apps\idea\current\profile\system'
    )
}
