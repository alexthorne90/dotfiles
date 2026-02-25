-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
	"AstroNvim/astrocommunity",
	{ import = "astrocommunity.pack.lua" },
	{ import = "astrocommunity.colorscheme.catppuccin" },
	{ import = "astrocommunity.colorscheme.nordic-nvim" },
	{ import = "astrocommunity.pack.cpp" },
	{ import = "astrocommunity.pack.python" },
	{ import = "astrocommunity.pack.typescript" },
	{ import = "astrocommunity.pack.json" },
	{ import = "astrocommunity.completion.copilot-lua" },
	{ import = "astrocommunity.completion.copilot-cmp" },
	{ import = "astrocommunity.editing-support.ultimate-autopair-nvim" },
	{ import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
	{ import = "astrocommunity.scrolling.mini-animate" },
	{ import = "astrocommunity.bars-and-lines.lualine-nvim" },
	{ import = "astrocommunity.bars-and-lines.bufferline-nvim" },
}
