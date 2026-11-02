local M = {}

M.packages = {
  "clangd",
  "pyright",
  "gopls",
  "rust-analyzer",
  "typescript-language-server",
  "bash-language-server",
  "powershell-editor-services",
  "black",
  "prettierd",
  "stylua",
  "debugpy",
  "delve",
}

local function registry()
  require("lazy").load({ plugins = { "mason.nvim" } })
  return require("mason-registry")
end

function M.install_missing()
  local mason_registry = registry()
  local missing = {}

  for _, name in ipairs(M.packages) do
    if not mason_registry.get_package(name):is_installed() then
      table.insert(missing, name)
    end
  end

  if #missing == 0 then
    print("All Mason tools are already installed")
    return
  end

  vim.cmd("MasonInstall " .. table.concat(missing, " "))
end

function M.validate()
  local mason_registry = registry()
  for _, name in ipairs(M.packages) do
    assert(mason_registry.get_package(name):is_installed(), "Mason package is missing: " .. name)
  end
end

return M
