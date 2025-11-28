# part-edit.nvim

Edit a part of a file individually.

[More neovim plugins](https://github.com/niuiic/awesome-neovim-plugins)

## Usage

This plugin is designed mostly for editing code in markdown file.

For example, if you enable `dotls` in markdown file, you will get these errors.

<img src="https://github.com/niuiic/assets/blob/main/part-edit.nvim/error.png" />

To avoid the errors above, the plugin creates a new buffer for editing selected
code.

<img src="https://github.com/niuiic/assets/blob/main/part-edit.nvim/usage.gif" />

1. select code in virtual mode (only support "v" mode)
2. use `PartEdit` to create new buffer
3. save new buffer and the original file will also be updated.

## Dependencies

- [niuiic/omega.nvim](https://github.com/niuiic/omega.nvim)

## Config

```lua
-- default config
{
    -- whether to save original file when update
    save_original_file = true,
}
```

```lua
-- keymap example
vim.keymap.set("v", "<space>p", function()
	require("part-edit").start()
end, { silent = true, mode = "v" })
```
