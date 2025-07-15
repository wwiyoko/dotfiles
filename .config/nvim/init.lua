local options = {
    clipboard = "unnamedplus",
    relativenumber = true,
    expandtab = true,
    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    undofile = true,
    writebackup = false,
    swapfile = false
}

for option, value in pairs(options) do
    vim.o[option] = value
end

for _, provider in ipairs({ "python3", "ruby", "perl", "node" }) do
    vim.g["loaded_" .. provider .. "_provider"] = 0
end

local group = vim.api.nvim_create_augroup("user", { clear = true })
local function auto(event, pattern, callback)
    vim.api.nvim_create_autocmd(event, {
        group = group,
        pattern = pattern,
        callback = callback
    })
end

auto("BufWrite", "*", function()
    local cursor_position = vim.fn.getcurpos()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", cursor_position)
end)

auto("FileType", {
    "javascript", "typescript",
    "html", "css", "yaml", "xml"
}, function(ev)
    vim.bo[ev.buf].tabstop = 2
    vim.bo[ev.buf].softtabstop = 2
    vim.bo[ev.buf].shiftwidth = 2
end)

auto("FileType", "*", function(ev)
    local formatters = {
        go = "gofmt",
        json = "jq"
    }

    local formatter = formatters[ev.match]
    if formatter then
        vim.bo[ev.buf].formatprg = formatter
    end
end)

vim.lsp.enable({ "gopls", "tsls" })

local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if ok then
    treesitter.setup({ highlight = { enable = true } })
end
