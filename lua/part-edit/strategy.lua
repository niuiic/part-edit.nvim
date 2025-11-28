local M = {}

---@class PartEditStrategy
---@field name string
---@field from (fun(lines: string[]): string[]) | nil
---@field to (fun(lines: string[]): string[]) | nil
---@field file_suffix string

---@type table<string, PartEditStrategy>
M._strategies = {}

---@type fun(strategy: PartEditStrategy)
function M.add_strategy(strategy)
	strategy.from = strategy.from or function(lines)
		return lines
	end

	strategy.to = strategy.to or function(lines)
		return lines
	end

	M._strategies[strategy.name] = strategy
end

---@type fun(cb: fun(strategy: PartEditStrategy | nil))
function M.select_strategy(cb)
	local items = vim.tbl_keys(M._strategies)

	if #items == 1 then
		cb(M._strategies[items[1]])
		return
	end

	vim.ui.select(items, {
		prompt = "Select strategy",
	}, function(selected)
		if not selected then
			cb()
		else
			cb(M._strategies[selected])
		end
	end)
end

return M
