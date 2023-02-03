return {
	  {
		"L3MON4D3/LuaSnip",
		opts = {
		  history = true,
		  delete_check_events = "TextChanged",
		},
	  },
	  {
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
		  "hrsh7th/cmp-nvim-lsp",
		  "hrsh7th/cmp-buffer",
		  "hrsh7th/cmp-path",
		  "saadparwaiz1/cmp_luasnip",
		},
		opts = function()
			local cmp = require("cmp")
			return {
			  completion = {
				completeopt = "menu,menuone,noinsert",
			  },
			  snippet = {
				expand = function(args)
				  require("luasnip").lsp_expand(args.body)
				end,
			  },
			  mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			  }),
			  sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			  }),
			  experimental = {
				ghost_text = {
				  hl_group = "LspCodeLens",
				},
			  },
			}
		  end,
		},
}