return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            -- Define terminal keymaps function first
            function _G.set_terminal_keymaps()
                local opts = {buffer = 0}
                vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
                vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
                vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
                vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
                vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
            end

            -- Set up terminal autocmd
            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

            -- Create terminal instance
            local terminal = require("toggleterm.terminal").Terminal
            local term = terminal:new({
                direction = "float",
                float_opts = {
                    border = "curved",
                },
                on_open = function(term)
                    vim.cmd("startinsert!")
                    vim.api.nvim_buf_set_option(term.bufnr, 'swapfile', false)
                    vim.api.nvim_buf_set_option(term.bufnr, 'bufhidden', 'hide')
                end,
            })

            -- Define toggle function
            function _G.toggle_terminal()
                term:toggle()
            end

            -- Set keymap for toggle
            vim.keymap.set({"n", "t"}, "<A-i>", toggle_terminal, {noremap = true, silent = true})

            -- Main toggleterm setup
            require("toggleterm").setup({
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4
                    end
                end,
                direction = 'float',
                float_opts = {
                    border = 'curved',
                    width = function()
                        return math.floor(vim.o.columns * 0.8)
                    end,
                    height = function()
                        return math.floor(vim.o.lines * 0.8)
                    end,
                },
                shade_terminals = false,
                shading_factor = 0,
                start_in_insert = true,
                persist_size = false,
                close_on_exit = true,
                shell = vim.o.shell,
                env = {
                    TERM = "xterm-256color"
                },
                on_create = function(term)
                    vim.api.nvim_buf_set_option(term.bufnr, 'swapfile', false)
                    vim.api.nvim_buf_set_option(term.bufnr, 'bufhidden', 'hide')
                    vim.cmd('setlocal nocursorline')
                    vim.cmd('setlocal nocursorcolumn')
                    vim.cmd('setlocal nonumber')
                    vim.cmd('setlocal norelativenumber')
                    vim.cmd('setlocal signcolumn=no')
                    vim.cmd('setlocal foldcolumn=0')
                end,
            })
        end,
    },
}