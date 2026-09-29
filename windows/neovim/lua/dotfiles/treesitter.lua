local M = {}

M.languages = {
  'javascript',
  'typescript',
  'tsx',
  'python',
  'java',
  'c',
  'cpp',
  'go',
  'rust',
  'bash',
  'markdown',
  'markdown_inline',
  'sql',
}

function M.setup()
  local treesitter = require('nvim-treesitter')
  treesitter.setup({
    install_dir = vim.fn.stdpath('data') .. '/site',
  })

  -- nvim-treesitter main delegates highlighting to Neovim's built-in API.
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('treesitter_features', { clear = true }),
    callback = function(args)
      local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
      if not lang then
        return
      end

      local ok, parser_loaded = pcall(vim.treesitter.language.add, lang)
      if not ok or not parser_loaded then
        return
      end

      vim.treesitter.start(args.buf, lang)
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end

function M.install()
  require('nvim-treesitter').install(M.languages):wait(10 * 60 * 1000)
end

return M
