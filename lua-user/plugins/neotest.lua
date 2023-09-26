return { 
  {
    "nvim-neotest/neotest",
    ft = { "python", "cs" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "Issafalcon/neotest-dotnet",
      "nvim-neotest/neotest-vim-test",
    },
    opts = function()
      return {
        -- your neotest config here
        adapters = {
          require "neotest-dotnet",
          require "neotest-vim-test",
        },
      }
    end,
    config = function(_, opts)
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup(opts)
    end
  }
  -- config = true,
  -- keys = {
	-- 	{ "<leader>Tt", function() require("neotest").run.run() end },
	-- 	{ "<leader>Tm", function() require("neotest").summary.marked() end },
	-- 	{ "<leader>Ts", function() require("neotest").summary.toggle() end },
	-- },
}
