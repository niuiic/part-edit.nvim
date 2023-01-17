local config = {
	win = {
		width_ratio = 1,
		height_ratio = 1,
	},
	default_filetype = nil,
    -- path to the swap file of the new buffer
	swap_path = function()
		return ".swap"
	end,
}

return {
	config = config,
}
