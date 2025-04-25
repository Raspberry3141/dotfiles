-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.number = true
--vim.opt.relativenumber = true
vim.o.statuscolumn = " %s %l %r "





vim.opt.clipboard = 'unnamedplus'
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{"folke/tokyonight.nvim",
			lazy = false,

			config = function()
				require("tokyonight").setup({
					style = "storm", 
				})
				vim.cmd.colorscheme "tokyonight"
			end},

		{'nvim-telescope/telescope.nvim', tag = '0.1.8',
			dependencies = { 'nvim-lua/plenary.nvim' },
			config = function()
				local builtin = require('telescope.builtin')
				vim.keymap.set('n', '<leader>f', builtin.find_files, { 
					desc = 'Telescope find files' })
			end},

		{"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function () 
				local configs = require("nvim-treesitter.configs")

				configs.setup({
					ensure_installed = { 
						"c", "python", "lua", "vim", "vimdoc", "heex", "javascript", "html" },
					sync_install = false,
					highlight = { enable = true },
					indent = { enable = true },  
				})
			end},

		{"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				vim.keymap.set('n', '<leader>t', ":NvimTreeToggle<cr>",{desc = "toggle tree"})
				local function my_on_attach(bufnr)
					local api = require "nvim-tree.api"

					local function opts(desc)
						return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
					end

					-- default mappings
					api.config.mappings.default_on_attach(bufnr)

				end

				-- pass to setup along with your other options
				require("nvim-tree").setup {
					---
					on_attach = my_on_attach,
					---
				}
			end},

		{"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
			end
		},

		{'VonHeikemen/lsp-zero.nvim',
			branch = 'v1.x',
			dependencies = {
				-- LSP Support
				{'neovim/nvim-lspconfig'},             
				{'williamboman/mason.nvim'},          
				{'williamboman/mason-lspconfig.nvim'},

				-- Autocompletion
				{'hrsh7th/nvim-cmp'},         
				{'hrsh7th/cmp-nvim-lsp'},    
				{'hrsh7th/cmp-buffer'},     
				{'hrsh7th/cmp-path'},      
				{'saadparwaiz1/cmp_luasnip'}, 
				{'hrsh7th/cmp-nvim-lua'},    

				-- Snippets
				{'L3MON4D3/LuaSnip'},             
				{'rafamadriz/friendly-snippets'},
			},
			config = function()
				local lsp = require('lsp-zero').preset({
					name = 'minimal',
					set_lsp_keymaps = true,
					manage_nvim_cmp = true,
					suggest_lsp_servers = false,
				})

				lsp.setup()

				vim.diagnostic.config({
					virtual_text = true,
					signs = true,
					update_in_insert = false,
					underline = true,
					severity_sort = false,
					float = true,
				})
			end},
		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				local harpoon = require("harpoon")
				-- REQUIRED
				harpoon:setup()
				-- REQUIRED
				vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
				vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

				vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
				vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
				vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
				vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

				-- Toggle previous & next buffers stored within Harpoon list
				vim.keymap.set("n", "<C-P>", function() harpoon:list():prev() end)
				vim.keymap.set("n", "<C-N>", function() harpoon:list():next() end)

			end
		},

		{'mbbill/undotree',
		config = function()
				vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
		end},




	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

