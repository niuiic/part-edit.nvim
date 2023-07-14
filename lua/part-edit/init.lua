local lib = require("part-edit.lib")
local config = require("part-edit.static").config
local core = require("core")

local original_bufnr, s_start, s_end, target_bufnr, autocmd_ids, swap_file_path, before_start, after_end

local is_buf_open = function()
	return original_bufnr ~= nil
end

local delete_autocmd = function()
	for _, value in ipairs(autocmd_ids) do
		vim.api.nvim_del_autocmd(value)
	end
	autocmd_ids = {}
end

local clean_up = function()
	lib.remove_file(swap_file_path)
	delete_autocmd()
	original_bufnr = nil
	s_start = nil
	s_end = nil
	target_bufnr = nil
	autocmd_ids = nil
	swap_file_path = nil
end

local create_autocmd = function()
	local id1 = vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = "*",
		callback = function(args)
			if target_bufnr == args.buf then
				local lines = lib.get_buf_content()
				if #lines == 1 then
					lines[1] = string.format("%s%s%s", before_start, lines[1], after_end)
				else
					lines[1] = string.format("%s%s", before_start, lines[1])
					lines[#lines] = string.format("%s%s", lines[#lines], after_end)
				end
				vim.api.nvim_buf_set_lines(original_bufnr, s_start.row - 1, s_end.row, false, lines)
				s_end.row = s_start.row + #lines - 1
				if config.save_original_file then
					vim.api.nvim_set_current_buf(original_bufnr)
					vim.cmd("w")
					vim.api.nvim_set_current_buf(target_bufnr)
				end
			end
		end,
	})

	local id2 = vim.api.nvim_create_autocmd("BufLeave", {
		pattern = "*",
		callback = function(args)
			if config.delete_buf_on_leave and target_bufnr == args.buf then
				pcall(vim.api.nvim_buf_delete, target_bufnr, { force = true })
				clean_up()
			end
		end,
	})

	local id3 = vim.api.nvim_create_autocmd("BufDelete", {
		pattern = "*",
		callback = function(args)
			if target_bufnr == args.buf then
				clean_up()
			end
		end,
	})

	autocmd_ids = {
		id1,
		id2,
		id3,
	}
end

local part_edit = function()
	if is_buf_open() then
		vim.notify("previous editing is not finished", vim.log.levels.ERROR)
		return
	end

	local function open_win(file_suffix)
		original_bufnr = vim.api.nvim_win_get_buf(0)

		swap_file_path = string.format("%s%s%s", config.swap_path(), ".", file_suffix)
		local lines = lib.get_visual_selection()
		lib.create_file(swap_file_path, table.concat(lines, "\n"))

		local pos = core.text.selected_area(original_bufnr)
		s_start = pos.s_start
		s_end = pos.s_end

		local first_line = vim.api.nvim_buf_get_lines(original_bufnr, s_start.row - 1, s_start.row, false)[1]
		local last_line = vim.api.nvim_buf_get_lines(original_bufnr, s_end.row - 1, s_end.row, false)[1]
		before_start = string.sub(first_line, 0, s_start.col - 1)
		after_end = string.sub(last_line, s_end.col + 1)

		if config.open_in == "float" then
			lib.open_float_win(0, config.float.win.width_ratio, config.float.win.height_ratio)
			vim.cmd("e " .. swap_file_path)
		else
			vim.cmd("tabf " .. swap_file_path)
		end
		target_bufnr = vim.api.nvim_win_get_buf(0)
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
	create_autocmd()
end

local setup = function(new_config)
	config = vim.tbl_deep_extend("force", config, new_config or {})
end

return {
	part_edit = part_edit,
	setup = setup,
}
