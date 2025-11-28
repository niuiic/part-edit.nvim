local M = {}

---@type fun(content: string[], suffix: string): (bufnr: number, file_name: string)
function M.create(content, suffix)
	local file_name = M._get_file_name(suffix)
	vim.fn.writefile(content, file_name)

	vim.cmd("e " .. file_name)
	local bufnr = vim.api.nvim_get_current_buf()

	return bufnr, file_name
end

---@type fun(bufnr: number, file_name: string)
function M.drop(bufnr, file_name)
	vim.schedule(function()
		if vim.api.nvim_buf_is_valid(bufnr) then
			vim.api.nvim_buf_delete(bufnr, { force = true })
		end
		if vim.uv.fs_stat(file_name) then
			vim.uv.fs_unlink(file_name)
		end
	end)
end

---@type fun(suffix: string): string
function M._get_file_name(suffix)
	local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
	return vim.fs.joinpath(dir, string.format("__%s.%s", os.time(), suffix))
end

return M
