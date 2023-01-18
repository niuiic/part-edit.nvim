local config = {
	win = {
		width_ratio = 1,
		height_ratio = 1,
	},
	swap_path = function()
		return ".swap"
	end,
	default_file_suffix = nil,
	save_original_file = true,
}

return {
	config = config,
}
