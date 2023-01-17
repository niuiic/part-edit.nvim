local lib = require("peek.lib")
local config = require("peek.static").config

local curbufnr, s_start, s_end

local peek = function()
	if lib.is_float_win_open() and curbufnr ~= nil then
		local lines = lib.close_peek_buf()
		vim.api.nvim_buf_set_lines(curbufnr, s_start.row - 1, s_end.row, false, lines)
		curbufnr = nil
		return
	end

	local function open_win(filetype)
		curbufnr = vim.api.nvim_win_get_buf(0)
		local pos = lib.get_selected_area_pos()
		s_start = pos.s_start
		s_end = pos.s_end

		local text = lib.get_visual_selection()
		local bufnr = lib.create_buf()
		vim.api.nvim_buf_set_lines(bufnr, 0, #text - 1, false, text)
		lib.open_float_win(bufnr, config.win.width_ratio, config.win.height_ratio)
		vim.bo.filetype = filetype
	end

	if config.default_filetype ~= nil then
		open_win(config.default_filetype)
	else
		vim.ui.input({ prompt = "Filetype: " }, function(input)
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
	peek = peek,
	setup = setup,
}
