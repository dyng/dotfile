local M = {}

local function assert_directory(path, label)
  assert(vim.fn.isdirectory(path) == 1, label .. " directory is missing: " .. path)
end

local function assert_glob(pattern, label)
  assert(vim.fn.glob(pattern) ~= "", label .. " artifact is missing: " .. pattern)
end

function M.initialize()
  require("lazy").load({ plugins = { "nvim-java" } })

  local config = assert(vim.g.nvim_java_config, "nvim-java configuration was not initialized")
  local resolve = require("pkgm.resolve")

  local jdtls = resolve.get_jdtls_root(config)
  assert_directory(jdtls, "JDTLS")
  assert_directory(jdtls .. "/config_win", "JDTLS Windows configuration")
  assert_glob(jdtls .. "/plugins/org.eclipse.equinox.launcher_*.jar", "JDTLS launcher")

  local java_test = resolve.get_extension_root("java-test", config.java_test)
  assert_directory(java_test, "Java Test")
  assert_glob(java_test .. "/server/*.jar", "Java Test server")

  local java_debug = resolve.get_extension_root("java-debug", config.java_debug_adapter)
  assert_directory(java_debug, "Java Debug")
  assert_glob(java_debug .. "/server/*.jar", "Java Debug server")

  local lombok = resolve.get_lombok_path(config)
  assert(vim.fn.filereadable(lombok) == 1, "Lombok artifact is missing: " .. lombok)

  print("nvim-java runtime packages are initialized")
end

return M
