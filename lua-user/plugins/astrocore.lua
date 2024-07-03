-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true,                                 -- enable autopairs at start
      cmp = true,                                       -- enable completion at start
      diagnostics_mode = 3,                             -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true,                              -- highlight URLs at start
      notifications = true,                             -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = {                  -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true,         -- sets vim.opt.number
        spell = false,         -- sets vim.opt.spell
        signcolumn = "yes",    -- sets vim.opt.signcolumn to yes
        wrap = false,          -- sets vim.opt.wrap
      },
      g = {                    -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- gt/T for moving tabs
        ["gt"] = { ":tabnext<cr>", desc = "Next tab", },
        ["gT"] = { ":tabprevious<cr>", desc = "Previous tab", },
        -- tn for new tab
        ["tn"] = { ":tabnew<cr>", desc = "Previous tab", },
        -- gb/B for moving tabs
        ["gb"] = {
          function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer"
        },
        ["gB"] = {
          function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end, desc =
        "Previous buffer",
        },
        -- ctrl+shift+direction to resize - don't seem to work work
        ["<C-S-h"] = { function(win) win:resize("width", -2) end, desc = "Increase size left" },
        ["<C-S-l"] = { function(win) win:resize("width", 2) end, desc = "Increase size right" },
        ["<C-S-j"] = { function(win) win:resize("height", -2) end, desc = "Increase size down" },
        ["<C-S-k"] = { function(win) win:resize("height", 2) end, desc = "Increase size up" },

        -- shift + r for redo
        ["<S-r>"] = { ":redo<cr>", desc = "Redo" },

        -- ctrl + n to open tree
        ["<C-n>"] = { "<cmd>Neotree toggle<cr>", desc = "Open neo-tree" },

        -- ctrl + p to open telescope find files
        ["<C-p>"] = {
          function() require("telescope.builtin").find_files() end,
          desc = "Open telescope find files"
        },

        -- my old ctrl/shift+u for diagnostic jumping
        ["<C-u>"] = { function() vim.diagnostic.goto_next() end, desc = "Next diagnostic" },
        ["<S-u>"] = { function() vim.diagnostic.goto_prev() end, desc = "Next diagnostic" },

        -- Space for fold toggle
        ["<space>"] = { "za", desc = "Toggle fold at current cursor location" },

        -- Shift+p to paste from clipboard
        -- ["<S-p>"] = { "\"+p", desc = "Paste from clipboard register"},
        -- seems like I don't need this

        -- LSP
        ["gi"] = { function() vim.lsp.buf.implementation() end, desc = "Go to implementation" },
        ["<leader>r"] = { function() vim.lsp.buf.rename() end, desc = "Rename current symbol" },
        ["<leader><space>"] = { function() vim.lsp.buf.code_action() end, desc = "Open LSP code actions" },

        -- Run tests with neotest
        ["<leader>tt"] = { function() require("neotest").run.run() end, desc = "Neotest Run Nearest" },
        ["<leader>tf"] = { function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Neotest Run File" },
        ["<leader>tT"] = { function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Neotest Run All Test Files" },
        ["<leader>ts"] = { function() require("neotest").summary.toggle() end, desc = "Neotest Toggle Summary" },
        ["<leader>to"] = { function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Neotest Show Output" },
        ["<leader>tO"] = { function() require("neotest").output_panel.toggle() end, desc = "Neotest Toggle Output Panel" },
        ["<leader>tS"] = { function() require("neotest").run.stop() end, desc = "Neotest Stop" },
      },
      -- insert mode
      i = {
        -- Good escape (jj and jk are already mapped by astronvim)
        ["Jj"] = { "<esc>" },
        ["JK"] = { "<esc>" },
      },
      -- visual mode
      v = {
        -- LSP
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },

      -- tables with just a `desc` key will be registered with which-key if it's installed
      -- this is useful for naming menus
      -- ["<Leader>b"] = { desc = "Buffers" },

      -- setting a mapping to false will disable it
      -- ["<C-S>"] = false,
    },
  },
}
