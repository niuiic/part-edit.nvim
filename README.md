# part-edit.nvim

Edit a part of a file individually.

## Usage

This plugin is designed mostly for editing code in markdown file.

For example, if you enable `dotls` in markdown file, you will get these errors.

<img src="https://github.com/niuiic/assets/blob/main/part-edit.nvim/error.png" />

To avoid the errors above, the plugin creates a new buffer for editing selected code.

<img src="https://github.com/niuiic/assets/blob/main/part-edit.nvim/usage.gif" />

1. select code in virtual mode
2. use `PartEdit` to create new buffer
3. use `PartEdit` to exit

> Notice: you have to use `PartEdit` to exit.

## Config

```lua
-- default config
	win = {
		-- The percentage of the floating window width to the editor width
		width_ratio = 1,
		-- The percentage of the floating window height to the editor height
		height_ratio = 1,
	},
	-- path to the swap file of the new buffer
	swap_path = function()
		return ".swap"
	end,
	-- default file suffix of selected code (for example, markdown code -> input `md`)
	-- this plugin will ask you to input file suffix if no default file suffix specified
	default_file_suffix = nil,
```

```lua
-- keymap example
vim.keymap.set("n", "<space>p", "<cmd>PartEdit<CR>", {})
-- <c-u> is required
vim.keymap.set("v", "<space>p", ":<c-u>PartEdit<CR>", { silent = true, mode = "v"})
```
