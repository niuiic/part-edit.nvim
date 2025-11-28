local M = {}

---@type fun(bufnr: number, start_lnum: number, end_lnum: number, content: string[], before_start: string, after_end: string): (start_lnum: number, end_lnum: number)
function M.sync(bufnr, start_lnum, end_lnum, content, before_start, after_end)
	content[1] = before_start .. content[1]
	content[#content] = content[#content] .. after_end
	vim.api.nvim_buf_set_lines(bufnr, start_lnum - 1, end_lnum, false, content)
	end_lnum = start_lnum + #content - 1

	return start_lnum, end_lnum
end

return M
