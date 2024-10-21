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

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
  	 {'folke/tokyonight.nvim'},
	 {'VonHeikemen/lsp-zero.nvim', branch = 'v4.x'},
	 {'williamboman/mason.nvim'},
	 {'williamboman/mason-lspconfig.nvim'},
	 {'neovim/nvim-lspconfig'},
	 {'hrsh7th/cmp-nvim-lsp'},
	 {'hrsh7th/nvim-cmp'},
	 {'nvim-telescope/telescope.nvim', tag = '0.1.8',dependencies = { 'nvim-lua/plenary.nvim' }},
	 {'ThePrimeagen/harpoon'}
},
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- automatically check for plugin updates
  checker = { enabled = true },
})
-----------------------------------------------------------------------------------------
vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')
vim.wo.relativenumber = true
------------------------------------------------------------------------------------------
local lsp_zero = require('lsp-zero')

-- lsp_attach is where you enable features that only work
-- if there is a language server active in the file
local lsp_attach = function(client, bufnr)
  local opts = {buffer = bufnr}

  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})
-----------------------------------------------------------------------------------------
local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
  ---
  -- code omitted for brevity...
  ---
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})
--------------------------------------------------------------------------------------
local lsp_zero = require('lsp-zero')

require('lspconfig').lua_ls.setup({
  on_init = function(client)
    lsp_zero.nvim_lua_settings(client, {})
  end,
})
--------------------------------------------------------------------------------------
local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  mapping = cmp.mapping.preset.insert({
   ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        local entries = cmp.get_entries()
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })

        if #entries == 1 then
          cmp.confirm()
        end
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<Enter>"] = function(fallback)
	    -- Don't block <CR> if signature help is active
	    -- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/issues/13
	    if not cmp.visible() or not cmp.get_selected_entry() or cmp.get_selected_entry().source.name == 'nvim_lsp_signature_help' then
		    fallback()
	    else
		    cmp.confirm({
			    -- Replace word if completing in the middle of a word
			    -- https://github.com/hrsh7th/nvim-cmp/issues/664
			    behavior = cmp.ConfirmBehavior.Replace,
			    -- Don't select first item on CR if nothing was selected
			    select = false,
		    })
	    end
    end,
    }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
})
-----------------------------------------------------------------------------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
-----------------------------------------------------------------------------------------
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a",mark.add_file)
vim.keymap.set("n", "<leader>e",ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>w",ui.nav_next)

