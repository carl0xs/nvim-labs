local nvim_lsp = require("lspconfig")
local null_ls = require("null-ls")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local languages = {
  "ruby_lsp", 
  "elixirls",
	"bashls",
	"clangd",
	"cssls",
	"gopls",
	"jsonls",
	"pyright",
	"rust_analyzer",
	"ts_ls",
	"lua_ls",
	"denols",
}

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true }

	buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "gK", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
end

null_ls.setup({
	on_attach = on_attach,
	debounce = 150,
	sources = {
		null_ls.builtins.code_actions.gitsigns,
		null_ls.builtins.code_actions.eslint,
		null_ls.builtins.code_actions.refactoring,
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.formatting.prettier.with({
			condition = function(utils)
				return utils.root_has_file({ ".prettierrc.json", ".prettierrc.js", ".prettierrc" })
			end,
		}),
		null_ls.builtins.formatting.stylua,
	},
})

for _, lang in ipairs(languages) do
	nvim_lsp[lang].setup({
		on_attach = on_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
	})
end

nvim_lsp.ts_ls.setup({
	on_attach = function(client, buffer)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
		on_attach(client, buffer)
	end,
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
	root_dir = nvim_lsp.util.root_pattern("package.json"),
})

nvim_lsp.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {
			completion = {
				postfix = {
					enable = false,
				},
			},
			cargo = {
				features = "all",
				allFeatures = true,
			},
		},
	},
})
