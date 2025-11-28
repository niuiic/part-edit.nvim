local omega = require("omega")
local config = require("part-edit.config")

local M = {}

M.part_edit = omega.async(function()
	M._validate_mode()

	local bufnr = vim.api.nvim_get_current_buf()

	local selected_area, selected, before_start, after_end = require("part-edit.selection").get_selection()

	local strategy = omega.await(require("part-edit.strategy").select_strategy)
	assert(strategy, "no strategy selected ")

	local new_bufnr, file_name = require("part-edit.file").create(strategy.from(selected), strategy.file_suffix)

	vim.api.nvim_create_autocmd("VimLeave", {
		callback = function()
			require("part-edit.file").drop(new_bufnr, file_name)
		end,
	})

	vim.api.nvim_create_autocmd("BufDelete", {
		buffer = new_bufnr,
		callback = function()
			require("part-edit.file").drop(new_bufnr, file_name)
		end,
	})

	vim.api.nvim_create_autocmd("BufWritePost", {
		buffer = new_bufnr,
		callback = function()
			local start_lnum, end_lnum = require("part-edit.sync").sync(
				bufnr,
				selected_area.start_lnum,
				selected_area.end_lnum,
				strategy.to(vim.api.nvim_buf_get_lines(new_bufnr, 0, -1, false)),
				before_start,
				after_end
			)
			selected_area.start_lnum = start_lnum
			selected_area.end_lnum = end_lnum

			if config:get().save_original_file then
				vim.api.nvim_set_current_buf(bufnr)
				vim.cmd("w")
				vim.api.nvim_set_current_buf(new_bufnr)
			end
		end,
	})
end)

function M._validate_mode()
	local mode = vim.fn.mode()
	assert(mode == "v" or mode == "V", "only support 'v' or 'V' mode")

	local selection = omega.get_selection()
	if selection and #selection == 1 then
		assert(mode == "V", "only support 'V' mode when single line is selected")
	end
end

return M
