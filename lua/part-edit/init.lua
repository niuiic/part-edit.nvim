local config = require("part-edit.config")

local M = {}

-- % setup %
function M.setup(new_config)
	config:set(new_config)
end

-- % strategy %
M.add_strategy = require("part-edit.strategy").add_strategy

-- % start %
M.start = function()
	xpcall(require("part-edit.edit").part_edit, function(err)
		vim.notify(tostring(err):match("^.*:%d+: (.+)$"), vim.log.levels.ERROR)
	end)
end

return M
