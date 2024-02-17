-- original source from here:  https://github.com/AstroNvim/user_example/blob/main/mappings.lua

-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  -- normal modej
  n = {
    -- second key is the lefthand side of the map

    -- navigate buffer tabs with `H` and `L`
    -- L = {
    --   function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
    --   desc = "Next buffer",
    -- },
    -- H = {
    --   function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
    --   desc = "Previous buffer",
    -- },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- mappings seen under group name "Buffer"

    -- gt/T for moving tabs
    ["gt"] = { ":tabnext<cr>", desc = "Next tab", },
    ["gT"] = { ":tabprevious<cr>", desc = "Previous tab", },
    -- tn for new tab
    ["tn"] = { ":tabnew<cr>", desc = "Previous tab", },
    -- gb/B for moving tabs
    ["gb"] = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer"
    },
    ["gB"] = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end, desc = "Previous buffer",
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
    ["<space>"] = { "za", desc = "Toggle fold at current cursor location"},

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
  i = {
    -- LSP
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
