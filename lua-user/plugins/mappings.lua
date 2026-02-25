return {
	{
		"AstroNvim/astrocore",
		---@type AstroCoreOpts
		opts = {
			mappings = {
				-- first key is the mode
				n = {
					-- second key is the lefthand side of the map

					-- navigate buffer tabs
					["]b"] = {
						function()
							require("astrocore.buffer").nav(vim.v.count1)
						end,
						desc = "Next buffer",
					},
					["[b"] = {
						function()
							require("astrocore.buffer").nav(-vim.v.count1)
						end,
						desc = "Previous buffer",
					},

					-- gt/T for moving tabs
					["gt"] = { ":tabnext<cr>", desc = "Next tab" },
					["gT"] = { ":tabprevious<cr>", desc = "Previous tab" },
					-- tn for new tab
					["tn"] = { ":tabnew<cr>", desc = "Previous tab" },
					-- gb/B for moving buffers
					["gb"] = {
						function()
							require("bufferline.commands").cycle(vim.v.count1)
						end,
						desc = "Next buffer",
					},
					["gB"] = {
						function()
							require("bufferline.commands").cycle(-vim.v.count1)
						end,
						desc = "Previous buffer",
					},

					-- shift+direction to resize using "smart-splits" functions (only doing sideways so I don't lose S-J normal functionality)
					["<S-H>"] = {
						function()
							require("smart-splits").resize_left()
						end,
						desc = "Resize split left",
					},
					["<S-L>"] = {
						function()
							require("smart-splits").resize_right()
						end,
						desc = "Increase size right",
					},

					-- shift + r for redo
					["<S-r>"] = { ":redo<cr>", desc = "Redo" },

					-- ctrl + n to open tree
					["<C-n>"] = { "<cmd>Neotree toggle<cr>", desc = "Open neo-tree" },

					-- ctrl + p to open telescope find files
					["<C-p>"] = {
						':lua Snacks.picker.pick({source="files"})<cr>',
						desc = "Open Snacks find files",
					},

					-- my old ctrl/shift+u for diagnostic jumping
					["<C-u>"] = {
						function()
							vim.diagnostic.jump({ count = 1, float = true })
						end,
						desc = "Next diagnostic",
					},
					["<S-u>"] = {
						function()
							vim.diagnostic.jump({ count = -1, float = true })
						end,
						desc = "Next diagnostic",
					},

					-- Space for fold toggle
					["<space>"] = { "za", desc = "Toggle fold at current cursor location" },

					-- LSP
					["gi"] = {
						function()
							vim.lsp.buf.implementation()
						end,
						desc = "Go to implementation",
					},
					["<leader>r"] = {
						function()
							vim.lsp.buf.rename()
						end,
						desc = "Rename current symbol",
					},
					["<leader><space>"] = {
						function()
							vim.lsp.buf.code_action()
						end,
						desc = "Open LSP code actions",
					},
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
	},
	{
		"AstroNvim/astrolsp",
		---@type AstroLSPOpts
		opts = {
			mappings = {
				n = {
					-- this mapping will only be set in buffers with an LSP attached
					K = {
						function()
							vim.lsp.buf.hover()
						end,
						desc = "Hover symbol details",
					},
					-- condition for only server with declaration capabilities
					gD = {
						function()
							vim.lsp.buf.declaration()
						end,
						desc = "Declaration of current symbol",
						cond = "textDocument/declaration",
					},
				},
			},
		},
	},
}
