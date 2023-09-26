-- original source from here:  https://github.com/AstroNvim/user_example/blob/main/mappings.lua

-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
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
    -- ["<leader>b"] = { name = "Buffers" },  (though I'm making this one useless below)

    -- mappings seen under group name "Buffer"
    ["<leader>b"] = {
      function() require("astronvim.utils.buffer").close() end,
      desc = "Pick to close",
    },
    
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

    -- LSP
    ["gi"] = { function() vim.lsp.buf.implementation() end, desc = "Go to implementation" },

    -- Run tests with neotest
		["<leader>tt"] = { function() require("neotest").run.run() end, desc = "Neotest run nearest" },
		["<leader>tf"] = { function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Neotest run file" },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
