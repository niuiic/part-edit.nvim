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
3. save new buffer and the original file will also be updated.

## Config

```lua
-- default config
{
    -- float | tab
    open_in = "tab",
    float = {
        win = {
            -- the ratio of the floating window width to the editor width
            width_ratio = 1,
            -- the ratio of the floating window height to the editor height
            height_ratio = 1,
        },
    },
    -- whether to delete the buffer when leave
    -- notice: you have to delete previous buffer before you run 'PartEdit' again
    delete_buf_on_leave = false,
    -- path to the swap file of the new buffer
    swap_path = function()
        return ".swap"
    end,
    -- default file suffix of selected code (for example, markdown code -> md)
    -- this plugin will ask you to input file suffix if no default file suffix specified
    default_file_suffix = nil,
    -- whether to save original file when update
    save_original_file = true,
}
```

```lua
-- keymap example
-- <c-u> is required
vim.keymap.set("v", "<space>p", ":<c-u>PartEdit<CR>", { silent = true, mode = "v"})
```
