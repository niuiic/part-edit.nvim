local winnr

local is_float_win_open = function()
	if winnr then
		return vim.api.nvim_win_is_valid(winnr)
	end
	return false
end

local get_win_config = function(width_ratio, height_ratio)
	local cur_win_zindex = vim.api.nvim_win_get_config(0).zindex or 1
	local screen_w = vim.opt.columns:get()
	local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
	local window_w = screen_w * width_ratio
	local window_h = screen_h * height_ratio
	local window_w_int = math.floor(window_w)
	local window_h_int = math.floor(window_h)
	local center_x = (screen_w - window_w) / 2
	local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
	return {
		relative = "editor",
		row = center_y,
		col = center_x,
		width = window_w_int,
		height = window_h_int,
		border = "single",
		zindex = cur_win_zindex,
	}
end

local open_float_win = function(bufnr, width_ratio, height_ratio)
	if is_float_win_open() then
		return
	end
	local win_config = get_win_config(width_ratio or 1, height_ratio or 1)
	winnr = vim.api.nvim_open_win(bufnr, true, win_config)
end

local create_buf = function()
	local bufnr = vim.api.nvim_create_buf(false, false)
	return bufnr
end

local get_visual_selection = function()
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local n_lines = math.abs(s_end[2] - s_start[2]) + 1
	local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
	lines[1] = string.sub(lines[1], s_start[3], -1)
	if n_lines == 1 then
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
	else
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
	end
	return lines
end

local get_selected_area_pos = function()
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	return {
		s_start = { row = s_start[2], col = s_start[3] },
		s_end = { row = s_end[2], col = s_end[3] },
	}
end

local close_buf = function(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr or 0, 0, -1, false)
	vim.api.nvim_buf_delete(bufnr or 0, { force = true })
	return lines
end

return {
	open_float_win = open_float_win,
	is_float_win_open = is_float_win_open,
	create_buf = create_buf,
	close_buf = close_buf,
	get_visual_selection = get_visual_selection,
	get_selected_area_pos = get_selected_area_pos,
}
