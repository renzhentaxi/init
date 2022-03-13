local M = {}

M.str = require("my_plugins.utils.str")

function M.callIfExist(tbl, function_name)
	if type(tbl) ~= "table" then
		return
	end

	if tbl[function_name] ~= nil then
		tbl[function_name]()
	end
end

function M.reload()
	for key, value in pairs(package.loaded) do
		if vim.startswith(key, "my_plugins") then
			M.callIfExist(require(key), "teardown")
			package.loaded[key] = nil
			M.callIfExist(require(key), "setup")
			print("reloaded " .. key)
		end
	end
end

-- the rgb value given by nvim_get_hl_by_name is in the form of R + G * 256 + B * 256 * 256.
function M.to_hex(rgb_number)
	if type(rgb_number) == "number" then
		return "#" .. bit.tohex(rgb_number, 6)
	end
	return rgb_number
end

function M.get_highlight(name)
	local highlight = vim.api.nvim_get_hl_by_name(name, true)

	return {
		foreground = M.to_hex(highlight.foreground),
		background = M.to_hex(highlight.background),
	}
end

function M.set_highlight(name, highlight)
	local settings = {}

	if highlight.background then
		settings[#settings + 1] = "guibg=" .. highlight.background
	end
	if highlight.foreground then
		settings[#settings + 1] = "guifg=" .. highlight.foreground
	end
	if #settings > 0 then
		vim.cmd("highlight " .. name .. " " .. table.concat(settings, " "))
	end
end

function M.string_to_char_table(str)
	local char_table = {}
	for i = 1, string.len(str) do
		char_table[i] = string.sub(str, i, i)
	end
	return char_table
end

function M.split_once(str, delim)
	local delim_index = string.find(str, delim)
	local before = string.sub(str, 0, delim_index - 1)
	local after = string.sub(str, delim_index + 1)
	return before, after
end

function M.get_char()
	local c = vim.fn.getchar()

	if type(c) == "number" then
		c = vim.fn.nr2char(c)
	end

	return c
end

function log_warn(error_message, context, stack_level)
	stack_level = stack_level or 0
	local stack = debug.getinfo(stack_level + 1)
	vim.api.nvim_echo({
		{ "[" .. context .. "] ", "Label" },
		{ error_message .. "\n", "WarningMsg" },
		{ "\tAt " .. stack.source .. " " .. stack.currentline .. "\n" },
	}, true, {})
end

-- throws error if object contains a field not in the allowed list
function M.check_for_unknown_fields(object, allowed_list, context)
	for k in pairs(object) do
		if not vim.tbl_contains(allowed_list, k) then
			log_warn("warn: unexpected key " .. k, context, 3)
		end
	end
end

return M
