local omega = require("omega")

local M = {}

function M.get_selection()
	local selected_area = omega.get_selected_area()

	local selected = omega.get_selection()
	assert(selected, "no selection")

	local before_start = M._get_before_start(selected_area.start_lnum, selected)
	local after_end = M._get_after_end(selected_area.end_lnum, selected)

	return selected_area, selected, before_start, after_end
end

function M._get_before_start(start_lnum, selected)
	local line = vim.api.nvim_buf_get_lines(0, start_lnum - 1, start_lnum, false)[1]
	return string.sub(line, 1, string.len(line) - string.len(selected[1]))
end

function M._get_after_end(end_lnum, selected)
	local line = vim.api.nvim_buf_get_lines(0, end_lnum - 1, end_lnum, false)[1]
	return string.sub(line, string.len(selected[#selected]) + 1)
end

return M
