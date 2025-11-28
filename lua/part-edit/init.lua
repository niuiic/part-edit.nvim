local config = require("part-edit.config")
local omega = require("omega")

local M = {}

-- % setup %
function M.setup(new_config)
	config:set(new_config)
end

-- % strategy %
---@class PartEditStrategy
---@field name string
---@field from (fun(lines: string[]): string[]) | nil
---@field to (fun(lines: string[]): string[]) | nil
---@field file_suffix string

local strategies = {}

---@type fun(strategy: PartEditStrategy)
function M.add_strategy(strategy)
	strategy.from = strategy.from or function(lines)
		return lines
	end

	strategy.to = strategy.to or function(lines)
		return lines
	end

	strategies[strategy.name] = strategy
end

---@type fun(cb: fun(strategy: PartEditStrategy | nil))
function M._select_strategy(cb)
	local items = vim.tbl_keys(strategies)

	if #items == 1 then
		cb(strategies[items[1]])
		return
	end

	vim.ui.select(items, {
		prompt = "Select strategy",
	}, function(selected)
		if not selected then
			cb()
		else
			cb(strategies[selected])
		end
	end)
end

-- % start %
M.start = omega.async(function()
	local bufnr = vim.api.nvim_get_current_buf()
	local mode = vim.fn.mode()
	if mode ~= "v" and mode ~= "V" then
		vim.notify('only support "v" or "V" mode', vim.log.levels.WARN, { title = "Part Edit" })
		return
	end

	local selected_area = omega.get_selected_area()
	local selected = omega.get_selection()
	if not selected then
		vim.notify("no selection", vim.log.levels.WARN, { title = "Part Edit" })
		return
	end
	local before_start = M._get_before_start(bufnr, selected_area.start_lnum, selected[1])
	local after_end = M._get_after_end(bufnr, selected_area.end_lnum, selected[#selected])

	local strategy = omega.await(M._select_strategy)
	if not strategy then
		return
	end

	local file_name = M._get_file_name(strategy.file_suffix)
	vim.fn.writefile(strategy.from(selected), file_name)
	vim.cmd("e " .. file_name)
	local new_bufnr = vim.api.nvim_get_current_buf()

	vim.api.nvim_create_autocmd("VimLeave", {
		callback = function()
			M._clean_up(new_bufnr, file_name)
		end,
	})

	vim.api.nvim_create_autocmd("BufDelete", {
		buffer = new_bufnr,
		callback = function()
			M._clean_up(new_bufnr, file_name)
		end,
	})

	vim.api.nvim_create_autocmd("BufWritePost", {
		buffer = new_bufnr,
		callback = function()
			local lines = vim.api.nvim_buf_get_lines(new_bufnr, 0, -1, false)
			local parsed_lines = strategy.to(lines)
			parsed_lines[1] = before_start .. parsed_lines[1]
			parsed_lines[#parsed_lines] = parsed_lines[#parsed_lines] .. after_end
			vim.api.nvim_buf_set_lines(bufnr, selected_area.start_lnum - 1, selected_area.end_lnum, false, parsed_lines)
			if config:get().save_original_file then
				vim.api.nvim_set_current_buf(bufnr)
				vim.cmd("w")
				vim.api.nvim_set_current_buf(new_bufnr)
			end
		end,
	})
end)

---@type fun(bufnr: number, start_lnum: number, first_selected: string): string
function M._get_before_start(bufnr, start_lnum, first_selected)
	local line = vim.api.nvim_buf_get_lines(bufnr, start_lnum - 1, start_lnum, false)[1]
	return string.sub(line, 1, string.len(line) - string.len(first_selected))
end

---@type fun(bufnr: number, end_lnum: number, last_selected: string): string
function M._get_after_end(bufnr, end_lnum, last_selected)
	local line = vim.api.nvim_buf_get_lines(bufnr, end_lnum - 1, end_lnum, false)[1]
	return string.sub(line, string.len(last_selected) + 1)
end

function M._get_file_name(suffix)
	local cur_file = vim.api.nvim_buf_get_name(0)
	return vim.fs.joinpath(vim.fs.dirname(cur_file), string.format("__%s.%s", os.time(), suffix))
end

function M._clean_up(bufnr, file_name)
	if vim.api.nvim_buf_is_valid(bufnr) then
		vim.api.nvim_buf_delete(bufnr, { force = true })
	end
	if vim.uv.fs_stat(file_name) then
		vim.uv.fs_unlink(file_name)
	end
end

return M
