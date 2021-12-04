local keymap = require("my_plugins.keymap")

vim.g.mapleader = " "

keymap.map_lua_function("n|t <leader><Esc>", "my_plugins.window_mode", "window_mode")
keymap.map_lua_function("n|t <leader>w", "my_plugins.window_mode", "window_mode")
keymap.map_lua_function("n <leader>r", "my_plugins.utils", "reload")

keymap.map("n <leader>s", keymap.action({ name = "save", command = ":w<cr>" }))
-- terminal
local cmd_escape_terminal = "<C-\\><C-n>"

for _, key in ipairs({ "h", "j", "k", "l" }) do
	local keybind = "<" .. "A" .. "-" .. key .. ">"
	local action_cmd = "<C-w>" .. key
	keymap.map("t " .. keybind, cmd_escape_terminal .. action_cmd)
	keymap.map("n " .. keybind, action_cmd)
end

-- telescope
local telescope_keys = {}

function telescope_keys.map(mapping, options)
	options = options or {}
	local mode = options.mode or "n"
	local prefix = options.prefix or "<leader>f"

	for keybind, action in pairs(mapping) do
		keybind = prefix .. keybind
		keymap.map_lua_function(mode .. " " .. keybind, "telescope.builtin", action)
	end
end

function telescope_keys.action(action_name)
	return "<cmd>lua require('telescope.builtin')." .. action_name .. "()<cr>"
end

telescope_keys.map({
	["?"] = "builtin",

	lb = "buffers",
	lx = "marks",

	c = "commands",
	s = "live_grep",
	h = "help_tags",

	gb = "git_branches",
	gc = "git_commits",
	gs = "git_status",

	ls = "lsp_document_symbols",
	lS = "lsp_workspace_symbols",

	lD = "ls_implementations",
	lt = "lsp_type_definitions",

	li = "lsp_document_diagnostics",
	lI = "lsp_workspace_diagnostics",
})

telescope_keys.map({
	p = "find_files",
	["/"] = "current_buffer_fuzzy_find",
	gd = "lsp_definitions",
	gr = "lsp_references",
	a = "lsp_code_actions",
}, { prefix = "<leader>" })

return M
