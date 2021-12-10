local M = {}
M.options, M.ui, M.mappings, M.plugins = {}, {}, {}, {}

M.options = {
    -- general nvim/vim options , check :h optionname to know more about an option

    clipboard = "unnamedplus",
    cmdheight = 1,
    ruler = false,
    hidden = true,
    ignorecase = true,
    smartcase = true,
    mapleader = " ",
    mouse = "a",
    number = true,
    numberwidth = 2,
    relativenumber = false,
    expandtab = true,
    shiftwidth = 2,
    smartindent = true,
    tabstop = 8,
    timeoutlen = 400,
    updatetime = 250,
    undofile = true,
    fillchars = {
        eob = " "
    },

    -- NvChad options
    nvChad = {
        copy_cut = true, -- copy cut text ( x key ), visual and normal mode
        copy_del = true, -- copy deleted text ( dd key ), visual and normal mode
        insert_nav = true, -- navigation in insertmode
        window_nav = true,

        -- updater
        update_url = "https://github.com/NvChad/NvChad",
        update_branch = "main"
    }
}

M.ui = {
    theme = "gruvbox"
}

M.mappings = {
    -- custom = {}, -- custom user mappings

    misc = {
        cheatsheet = "<leader>ch",
        close_buffer = "<leader>x",
        copy_whole_file = "<C-a>", -- copy all contents of current buffer
        line_number_toggle = "<leader>n", -- toggle line number
        update_nvchad = "<leader>uu",
        new_buffer = "<S-t>",
        new_tab = "<C-t>b",
        save_file = "<C-s>" -- save file using :w
    },

    -- navigation in insert mode, only if enabled in options

    insert_nav = {
        backward = "<C-h>",
        end_of_line = "<C-e>",
        forward = "<C-l>",
        next_line = "<C-k>",
        prev_line = "<C-j>",
        beginning_of_line = "<C-a>"
    },

    -- better window movement
    window_nav = {
        moveLeft = "<C-h>",
        moveRight = "<C-l>",
        moveUp = "<C-k>",
        moveDown = "<C-j>"
    },

    -- terminal related mappings
    terminal = {
        -- multiple mappings can be given for esc_termmode, esc_hide_termmode

        -- get out of terminal mode
        esc_termmode = {"jk"},

        -- get out of terminal mode and hide it
        esc_hide_termmode = {"JK"},
        -- show & recover hidden terminal buffers in a telescope picker
        pick_term = "<leader>W",

        -- spawn terminals
        new_horizontal = "<leader>h",
        new_vertical = "<leader>v",
        new_window = "<leader>w"
    }
}

-- plugins related mappings

M.mappings.plugins = {
    bufferline = {
        next_buffer = "<TAB>",
        prev_buffer = "<S-Tab>"
    },
    comment = {
        toggle = "<leader>/"
    },

    dashboard = {
        bookmarks = "<leader>bm",
        new_file = "<leader>fn", -- basically create a new buffer
        open = "<leader>db", -- open dashboard
        session_load = "<leader>l",
        session_save = "<leader>s"
    },

    -- map to <ESC> with no lag
    better_escape = { -- <ESC> will still work
        esc_insertmode = {"jk"} -- multiple mappings allowed
    },

    nvimtree = {
        toggle = "<C-n>",
        focus = "<leader>e"
    },

    telescope = {
        buffers = "<leader>fb",
        find_files = "<leader>ff",
        find_hiddenfiles = "<leader>fa",
        git_commits = "<leader>cm",
        git_status = "<leader>gt",
        help_tags = "<leader>fh",
        live_grep = "<leader>fw",
        oldfiles = "<leader>fo",
        themes = "<leader>th", -- NvChad theme picker

        telescope_media = {
            media_files = "<leader>fp"
        }
    }
}

-- NvChad included plugin options & overrides
M.plugins = {
    options = {
        lspconfig = {
            setup_lspconf = "custom.plugins.configs.lsp_installer"
        }
    },
    -- To change the Packer `config` of a plugin that comes with NvChad,
    -- add a table entry below matching the plugin github name
    --              '-' -> '_', remove any '.lua', '.nvim' extensions
    -- this string will be called in a `require`
    --              use "(custom.configs).my_func()" to call a function
    --              use "custom.blankline" to call a file
    default_plugin_config_replace = {
        nvim_treesitter = "custom.plugins.configs.treesitter",
        nvim_cmp = "custom.plugins.configs.cmp"
    }
}

return M
