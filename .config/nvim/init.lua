vim.o.clipboard = "unnamedplus"
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.list = true
vim.o.undofile = true

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "html", "css", "yaml" },
    callback = function(ev)
        vim.bo[ev.buf].tabstop = 2
        vim.bo[ev.buf].softtabstop = 2
        vim.bo[ev.buf].shiftwidth = 2
    end
})

vim.lsp.enable({ "gopls", "tsls" })

local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if ok then
    treesitter.setup({ highlight = { enable = true } })
end
