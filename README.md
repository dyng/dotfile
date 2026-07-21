dotfile
=======

All my dotfiles. Up to now the major are vim config files and plugins (with some self-custom)

list
-------
- vim
- pentadactyl
- shell
- irssi

Windows
-------

Windows configuration is stored under `windows/` and deployed with symbolic
links so edits in the live configuration are reflected in this repository:

```powershell
pwsh -File .\windows\deploy.ps1 -BackupExisting
```

The deploy script links the PowerShell profile, Starship configuration,
Neovim configuration directory, and AutoHotkey configuration. Existing targets
are moved to timestamped backup paths before the links are created. Creating
symbolic links requires Windows Developer Mode or an elevated PowerShell.
