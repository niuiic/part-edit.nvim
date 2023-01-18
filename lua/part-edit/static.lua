local config = {
	-- float | tab
	open_in = "tab",
	float = {
		win = {

			width_ratio = 1,
			height_ratio = 1,
		},
	},
	delete_buf_on_leave = false,
	swap_path = function()
		return ".swap"
	end,
	default_file_suffix = nil,
	save_original_file = true,
}

return {
	config = config,
}
