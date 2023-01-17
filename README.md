# part-edit.nvim

Select parts of a file for individual editing.

## Usage

This plugin is designed mostly for editing code in markdown file.

For example, if you enable `dotls` in markdown file, you will get these errors.

<img src="https://github.com/niuiic/assets/blob/main/part-edit.nvim/error.png" />

To avoid the errors above, the plugin creates a new buffer for editing selected code.

<img src="https://github.com/niuiic/assets/blob/main/part-edit.nvim/usage.gif" />

## Config

```lua
-- default config
{
	win = {
        -- The percentage of the floating window width to the editor width
		width_ratio = 1,
        -- The percentage of the floating window height to the editor height
		height_ratio = 1,
	},
    -- default filetype of selected code
    -- this plugin will ask you to input filetype if no default filetype specified
	default_filetype = nil,
}
```

```lua
-- keymap example
vim.keymap.set("n", "<space>p", "<cmd>PartEdit<CR>", {})
-- <c-u> is required
vim.keymap.set("v", "<space>p", ":<c-u>PartEdit<CR>", { silent = true, mode = "v"})
```
