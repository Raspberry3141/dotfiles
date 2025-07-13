vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.statuscolumn = " %s %l %r "
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 15
vim.opt.signcolumn = 'yes'
vim.keymap.set('n','<C-c>','<cmd>nohlsearch<cr>')
vim.keymap.set('n','<leader>e','<cmd>edit .<cr>')
local term_buff_number = nil
vim.keymap.set('t','<C-c>','<C-\\><C-N><C-o>')
vim.keymap.set({'n'},'<leader>t',function ()
	if term_buff_number==nil then
		last_bufnr = vim.api.nvim_get_current_buf()
		term_buff_number = vim.api.nvim_create_buf(true,false)
		vim.api.nvim_set_current_buf(term_buff_number)
		vim.fn.termopen(os.getenv("SHELL"))
		vim.cmd("startinsert")
	else
		last_bufnr = vim.api.nvim_get_current_buf()
		vim.api.nvim_set_current_buf(term_buff_number)
		vim.cmd("startinsert")
	end
end)

vim.api.nvim_create_autocmd({'BufRead'}, {
	desc = 'move cursor to last changed pos when reading a buf',
	callback = function()
		if vim.api.nvim_buf_get_mark(0, ".")[1] ==0 and vim.api.nvim_buf_get_mark(0, ".")[2] == 0 then
			return
		elseif vim.api.nvim_buf_get_mark(0, ".")[1] >= vim.api.nvim_buf_line_count(0) then
			return
		end
		vim.api.nvim_win_set_cursor(0,{vim.api.nvim_buf_get_mark(0, ".")[1],vim.api.nvim_buf_get_mark(0, ".")[2]})
	end})
vim.schedule(function()
	vim.opt.clipboard = 'unnamedplus'
end)

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Flash highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.keymap.set('n','<leader>]', function()
	vim.diagnostic.jump({count = 1, float=true})
end)

vim.keymap.set('n','<leader>[', function()
	vim.diagnostic.jump({count = -1, float=true})
end)

vim.keymap.set('n','<leader>d', ':lua vim.diagnostic.open_float(nil, { focus = false, })<cr>')

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
-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{'nvim-telescope/telescope.nvim', tag = '0.1.8',
			dependencies = { 'nvim-lua/plenary.nvim' },
			config = function()
				local builtin = require('telescope.builtin')
				vim.keymap.set('n', '<leader>f', function()
					builtin.find_files()
				end
				, { desc = 'Telescope find files' })
				require('telescope').setup({
				pickers = {
					find_files = {
						-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
				}
			})
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
				local function my_on_attach(bufnr)
					local api = require "nvim-tree.api"

					local function opts(desc)
						return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
					end
					-- default mappings
					api.config.mappings.default_on_attach(bufnr)

				end
				--UNCOMMENT TO ENABLE TREE
				--vim.keymap.set('n', '<leader>r', ":NvimTreeToggle<cr>",{desc = "toggle tree"})
				-- pass to setup along with your other options
				--require("nvim-tree").setup {
					---
				--	on_attach = my_on_attach,
					---
				--}
			end},

		{'hrsh7th/nvim-cmp',
		dependencies = {
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			{'hrsh7th/cmp-nvim-lua'},
		},
		config = function()
			local cmp = require('cmp')

			cmp.setup({
				sources = {
					{name = 'path'},
					{name = 'nvim_lsp'},
					{name = 'buffer', keyword_length = 3},
				},
				mapping = cmp.mapping.preset.insert({
						["<Tab>"] = cmp.mapping.select_next_item(),
						["<s-Tab>"] = cmp.mapping.select_prev_item(),
						["<Enter>"] = cmp.mapping.confirm({select = true}),
					}),

				})
			end
		},

		{"neovim/nvim-lspconfig",
			config = function()

				-- Add borders to floating windows
				vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
					vim.lsp.handlers.hover,
					{border = 'rounded'}
				)
				vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
					vim.lsp.handlers.signature_help,
					{border = 'rounded'}
				)

				-- Configure error/warnings interface
				vim.diagnostic.config({
					virtual_text = true,
					severity_sort = true,
					float = {
						style = 'minimal',
						update_in_insert = true,
						-- border = 'rounded',
						header = '',
						prefix = '',
					},
					signs = {
						text = {
							[vim.diagnostic.severity.ERROR] = '✘',
							[vim.diagnostic.severity.WARN] = '▲', [vim.diagnostic.severity.HINT] = '⚑', [vim.diagnostic.severity.INFO] = '»', }, }, })
				-- Add cmp_nvim_lsp capabilities settings to lspconfig
				-- This should be executed before you configure any language server
				local lspconfig_defaults = require('lspconfig').util.default_config
				lspconfig_defaults.capabilities = vim.tbl_deep_extend(
					'force',
					lspconfig_defaults.capabilities,
					require('cmp_nvim_lsp').default_capabilities()
				)

				-- This is where you enable features that only work
				-- if there is a language server active in the file
				vim.api.nvim_create_autocmd('LspAttach', {
					callback = function(event)
						local opts = {buffer = event.buf}

						vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
						vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
						vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
						vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
						vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
						vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
						vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
						vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
						vim.keymap.set('n', 'ge', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
						vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
						vim.keymap.set('n', 'gA', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
					end,
				})
			end
		},


		{"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
			end
		},

		{
			"williamboman/mason-lspconfig.nvim",
			config = function()
				require('mason-lspconfig').setup({
					handlers = {
						function(server_name)
							require('lspconfig')[server_name].setup({})
						end,

						require('lspconfig').lua_ls.setup({
							settings = {
								Lua = {
									runtime = {
										version = 'LuaJIT',
									},
									diagnostics = {
										globals = {'vim'},
									},
									workspace = {
										library = {vim.env.VIMRUNTIME},
									},
							t},
							},
						})
					}
				})
			end
		},

		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				local harpoon = require("harpoon")
				harpoon:setup()
				vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
				vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
				vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
				vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
				vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
				vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
				vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end)
			end
		},

		{'m4xshen/autoclose.nvim',
			opts = {
				close = true,
				keys = {
					["<"] = { escape = false ,close = true, pair = "<>", disabled_filetypes = {"c","cpp","cc"} },
				}
			},

		},

		{"rrethy/vim-illuminate"},

		{'kevinhwang91/nvim-fFHighlight',
			config = function()
					require('fFHighlight').setup({})
			end
		},

		{'numToStr/Comment.nvim',
			opts = {
				toggler = {

					line = "<leader>c",
				},
				opleader = {
					line = "<leader>c",
				}
			}


		},


	},
	install = { colorscheme = { "habamax" } },
	checker = {
		enabled = false,
		notification = false
	},
})

