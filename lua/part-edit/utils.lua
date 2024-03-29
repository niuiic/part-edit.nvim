local core = require("core")

local open_float_win = function(bufnr, width_ratio, height_ratio)
	local proportional_size = core.win.proportional_size(width_ratio, height_ratio)
	core.win.open_float(bufnr, {
		enter = true,
		relative = "editor",
		width = proportional_size.width,
		height = proportional_size.height,
		row = proportional_size.row,
		col = proportional_size.col,
		border = "single",
	})
end

local get_buf_content = function(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr or 0, 0, -1, false)
	return lines
end

local create_file = function(path, text)
	local file = io.open(path, "w+")
	if file ~= nil then
		file:write(text)
		file:close()
	end
end

local remove_file = function(path)
	vim.loop.fs_unlink(path)
end

return {
	open_float_win = open_float_win,
	get_buf_content = get_buf_content,
	create_file = create_file,
	remove_file = remove_file,
}
