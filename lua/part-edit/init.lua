local lib = require("part-edit.lib")
local config = require("part-edit.static").config

local curbufnr, s_start, s_end

local part_edit = function()
	if lib.is_float_win_open() and curbufnr ~= nil then
		local lines = lib.close_buf()
		vim.api.nvim_buf_set_lines(curbufnr, s_start.row - 1, s_end.row, false, lines)
		lib.remove_file()
		curbufnr = nil
		return
	end

	local function open_win(file_suffix)
		curbufnr = vim.api.nvim_win_get_buf(0)
		local pos = lib.get_selected_area_pos()
		s_start = pos.s_start
		s_end = pos.s_end

		local swap_file_path = config.swap_path() .. "." .. file_suffix
		local text = lib.get_visual_selection()
		lib.create_file(swap_file_path, text)
		local bufnr = lib.create_buf()
		vim.api.nvim_buf_set_lines(bufnr, 0, #text - 1, false, text)
		vim.api.nvim_buf_set_name(bufnr, swap_file_path)
		lib.open_float_win(bufnr, config.win.width_ratio, config.win.height_ratio)
		vim.cmd("filetype detect")
	end

	if config.default_file_suffix ~= nil then
		open_win(config.default_file_suffix)
	else
		vim.ui.input({ prompt = "File suffix: " }, function(input)
			if input == nil then
				return
			end
			open_win(input)
		end)
	end
end

local setup = function(new_config)
	config = vim.tbl_deep_extend("force", config, new_config or {})
end

return {
	part_edit = part_edit,
	setup = setup,
}
