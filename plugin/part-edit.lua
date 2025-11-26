local part_edit = require("part-edit")

vim.api.nvim_create_user_command("PartEdit", function()
	part_edit.part_edit()
end, { range = 0 })
