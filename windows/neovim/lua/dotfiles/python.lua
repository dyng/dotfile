local M = {}

function M.find_python(root)
  if not root then
    return nil
  end
  local dir = vim.fs.normalize(root)
  while dir do
    for _, name in ipairs({ ".venv", "venv" }) do
      local executable = vim.fs.joinpath(dir, name,
        vim.fn.has("win32") == 1 and "Scripts/python.exe" or "bin/python")
      if vim.fn.executable(executable) == 1 then
        return executable
      end
    end
    -- A worktree's .git is a file; do not borrow another repository's env.
    if vim.uv.fs_stat(vim.fs.joinpath(dir, ".git")) then
      break
    end
    local parent = vim.fs.dirname(dir)
    if parent == dir then
      break
    end
    dir = parent
  end
end

function M.before_init(_, config)
  config.settings = config.settings or {}
  config.settings.python = config.settings.python or {}
  local python = config.settings.python
  -- Explicit settings and venv-selector choices take priority over discovery.
  if not python.pythonPath then
    python.pythonPath = M.find_python(config.root_dir)
  end
end

return M
