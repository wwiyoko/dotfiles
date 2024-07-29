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

local servers = {
    gopls = {
        cmd = { "gopls" },
        file_types = { "go", "gomod", "gowork", "gotmpl" },
        root_patterns = { "go.mod", "go.work" }
    },
    tsserver = {
        cmd = { "typescript-language-server", "--stdio" },
        file_types = { "javascript", "typescript" },
        root_patterns = { "package.json", ".git" }
    }
}

local function lsp_init(server_name, server_config)
    if vim.fn.executable(server_config.cmd[1]) ~= 1 then
        return
    end

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup(server_name, { clear = true }),
        pattern = server_config.file_types,
        callback = function(ev)
            vim.lsp.start(vim.tbl_deep_extend("force", {
                name = server_name,
                root_dir = vim.fs.root(ev.buf, server_config.root_patterns)
            }, server_config))
        end
    })
end

for server_name, server_config in pairs(servers) do
    lsp_init(server_name, server_config)
end

local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if ok then
    treesitter.setup({ highlight = { enable = true } })
end
