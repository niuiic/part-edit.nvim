local peek = require("peek")

vim.api.nvim_create_user_command("Peek", function()
	peek.peek()
end, {
	range = 0,
})
