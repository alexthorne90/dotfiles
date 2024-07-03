-- Customize None-ls sources

--- @type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    -- local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- Set a formatter
      --null_ls.builtins.formatting.stylua,
      --null_ls.builtins.formatting.prettier,
      --null_ls.builtins.formatting.black,
      --null_ls.builtins.formatting.isort,
      --null_ls.builtins.formatting.clang_format,
      --null_ls.builtins.formatting.shfmt.with {
      --  args = { "-i", "2" },
      --},
      --null_ls.builtins.diagnostics.luacheck,
      ---- null_ls.builtins.diagnostics.flake8,
      ---- Currently favoring pylint per our coding standard
      --null_ls.builtins.diagnostics.pylint,
      ---- null_ls.builtins.diagnostics.mypy,
    }
    return config -- return final config table
  end,
}
