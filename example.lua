return {
  -- Theme onedark
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'darker'
      }
      require('onedark').load()
    end
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
  

  -- Trouble
  {
    "folke/trouble.nvim",
    opts = { 
      use_diagnostic_signs = true 
    },
  },

  -- CMP emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
  
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
       -- Web
      "html",
      "css",
      "javascript",

      -- C / C++
      "c",
      "cpp",

      -- Java
      "java",

      -- C#
      "c_sharp",

      -- Lua (rất nên có vì config nvim)
      "lua",
      },
        highlight = {
        enable = true,
        },
        indent = {
          enable = true,
        },
    },
  },

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = require("lazyvim.config").icons

      return {
        options = {
          theme = "auto", -- Tự động theo colorscheme
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          -- BÊN TRÁI
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                return str:sub(1, 1) -- Chỉ hiện chữ cái đầu (N, I, V...)
              end,
            },
          },
          lualine_b = {
            {
              "branch",
              icon = "", -- Git branch icon
            },
          },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = { left = 1, right = 0 },
            },
            {
              "filename",
              path = 1, -- 0 = tên file, 1 = relative path, 2 = absolute path
              symbols = {
                modified = "  ",
                readonly = "",
                unnamed = "",
              },
            },
          },

          -- BÊN PHẢI
          lualine_x = {
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
            {
              -- LSP Server đang chạy
              function()
                local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
                if #buf_clients == 0 then
                  return "LSP Inactive"
                end

                local buf_client_names = {}
                for _, client in pairs(buf_clients) do
                  if client.name ~= "null-ls" and client.name ~= "copilot" then
                    table.insert(buf_client_names, client.name)
                  end
                end

                return " " .. table.concat(buf_client_names, ", ")
              end,
              icon = "",
              color = { fg = "#7aa2f7" },
            },
            {
              -- Encoding
              "encoding",
              fmt = string.upper,
            },
            {
              -- File format (unix/dos/mac)
              "fileformat",
              symbols = {
                unix = "LF",
                dos = "CRLF",
                mac = "CR",
              },
            },
            {
              -- File size
              function()
                local size = vim.fn.getfsize(vim.fn.expand("%"))
                if size < 0 then
                  return ""
                end
                if size < 1024 then
                  return size .. "B"
                elseif size < 1048576 then
                  return string.format("%.1fK", size / 1024)
                else
                  return string.format("%.1fM", size / 1048576)
                end
              end,
              icon = "",
            },
          },
          lualine_y = {
            {
              "progress", -- % vị trí trong file
              separator = " ",
              padding = { left = 1, right = 0 },
            },
            {
              "location", -- Dòng:Cột
              padding = { left = 0, right = 1 },
            },
          },
          lualine_z = {
            {
              -- Số dòng trong file
              function()
                return " " .. vim.fn.line("$") .. "L"
              end,
              padding = { left = 1, right = 1 },
            },
          },
        },
        extensions = { "neo-tree", "lazy", "mason", "trouble" },
      }
    end,
  },

  -- Snacks dashboard với tên bạn (DÙNG CÁI NÀY THAY ALPHA)
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
      enabled = false,
    },
      dashboard = {
        enabled = true,
        preset = {
          header = [[
        .*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*       
 .*.* ██╗  ██╗ ██████╗ ███╗   ██╗ ██████╗ .*.*
 .*.* ██║  ██║██╔═══██╗████╗  ██║██╔════╝ .*.*
  .*.*███████║██║   ██║██╔██╗ ██║██║  ███╗.*.*
 .*.* ██╔══██║██║   ██║██║╚██╗██║██║   ██║.*.*
 .*.* ██║  ██║╚██████╔╝██║ ╚████║╚██████╔╝.*.*
 .*.* ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ .*.*
            .                   .*.*.*.*.*.*.*.*.*.*.*.*.**.*.*.* *.*.*.* *.HV                                 
.*.*.* ██╗   ██╗██╗███████╗████████╗*.*.*.*.
 .*.*.*██║   ██║██║██╔════╝╚══██╔══╝*.*.*.*.*
.*.*.* ██║   ██║██║█████╗     ██║   *.*.*.*.*
 .*.*.*╚██╗ ██╔╝██║██╔══╝     ██║   *.*.*.*.*.
  .*.*.*╚████╔╝ ██║███████╗   ██║  *.*.*.*.*.
   .*.*.*╚═══╝  ╚═╝╚══════╝   ╚═╝  *.*.*.*.*.
     *.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*..* *.*
        ]],
        },
    },

    explorer = {
      width = 25,  -- độ rộng sidebar explorer BUG: Khong hoạt động
    },

    },
  },
  -- Neo-tree file explorer (vi da con config trong lazyvim roi)
  -- {
  --  "nvim-tree/nvim-tree.lua",
  --  dependencies = { "nvim-tree/nvim-web-devicons" },
  --  config = function()
    --  require("nvim-tree").setup({
  --      renderer = {
        --  indent_markers = {
      --      enable = true,        -- ⬅ THANH KẺ ĐÂY
    --        icons = {
  --            corner = "└ ",
            --  edge = "│ ",
          --    item = "│ ",
        --      bottom = "─ ",
      --        none = "  ",
    --        },
  --        },
  --      },
  --    })
  --  end,
  --},
  

  -- JSON support
  { import = "lazyvim.plugins.extras.lang.json" },

  -- Mason
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
      },
    },
  },

  -- Toggleterm với float KHÔNG tự ẩn
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      open_mapping = [[<F4>]],
      direction = 'float',
      persist_mode = true,
      shell = 'pwsh.exe',
      hide_numbers = true,
      autochdir = false,
      float_opts = {
        border = 'curved',
        winblend = 0,
        width = 85,
        height = 30,
        row = 2.5,
        col = vim.o.columns - 90,
      },
      shade_terminals = true,
      start_in_insert = true,
    },
  },

  --LSP Config for java 
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  -- Which-key với nhóm buffer và windows mở rộng
  {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    preset = "helix",
    defaults = {},
    spec = {
      {
        mode = { "n", "x" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>dp", group = "profiler" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },

        {
          "<leader>b",
          group = "buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },

        { "gx", desc = "Open with system app" },
      },

      -- ===== NORMAL MODE KEYMAPS =====
      { "<F2>", desc = "Toggle File Tree", mode = "n" },

      { "<leader>fg", desc = "Live Grep (rg)", mode = "n" },
      { "<leader>fb", desc = "Buffers", mode = "n" },

      { "<F4>", desc = "Toggle Floating Terminal", mode = "n" },

      { "<C-h>", desc = "Window: Move Left", mode = "n" },
      { "<C-j>", desc = "Window: Move Down", mode = "n" },
      { "<C-k>", desc = "Window: Move Up", mode = "n" },
      { "<C-l>", desc = "Window: Move Right", mode = "n" },

      -- ===== TERMINAL MODE KEYMAPS =====
      { "<Esc>", desc = "Terminal: Exit Terminal Mode", mode = "t" },
      { "jk", desc = "Terminal: Exit Terminal Mode", mode = "t" },

      { "<C-Left>", desc = "Terminal: Move Left", mode = "t" },
      { "<C-Down>", desc = "Terminal: Move Down", mode = "t" },
      { "<C-Up>", desc = "Terminal: Move Up", mode = "t" },
      { "<C-Right>", desc = "Terminal: Move Right", mode = "t" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Keymaps (which-key)",
    },
    {
      "<c-w><space>",
      function()
        require("which-key").show({ keys = "<c-w>", loop = true })
      end,
      desc = "Window Hydra Mode (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    if not vim.tbl_isempty(opts.defaults) then
      LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
      wk.register(opts.defaults)
    end
  end,
},

  -- Gitsigns với keymap tùy chỉnh
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
      add          = { text = "+" },
      change       = { text = "~" },
      delete       = { text = "-" },
      topdelete    = { text = "-" },
      changedelete = { text = "~" },
      untracked    = { text = "?" },
    },

    signs_staged = {
      add          = { text = "+" },
      change       = { text = "~" },
      delete       = { text = "-" },
      topdelete    = { text = "-" },
      changedelete = { text = "~" },
    },

      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
        end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  -- Trouble với keymap tùy chỉnh
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Trouble/Quickfix Item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix Item",
      },
    },
  },
  -- Todo-comments với keymap tùy chỉnh và màu sắc riêng
  {
    "folke/todo-comments.nvim",
    event = "LazyFile",
    cmd = { "TodoTrouble", "TodoTelescope" },

    opts = {
      keywords = {
        TODO  = { icon = "", color = "info" },      -- xanh (việc cần làm)
        FIXME = { icon = "", color = "fixme" },     -- 💜 tím (cần sửa nhưng chưa khẩn)
        NOTE  = { icon = "󰍩", color = "note" },      -- xanh lá / nhạt
        HACK  = { icon = "", color = "warning" },   -- cam
        BUG   = { icon = "", color = "error" },     -- 🔴 đỏ (lỗi thật)
      },

      -- định nghĩa màu custom
      colors = {
        error   = { "DiagnosticError", "#DC2626" }, -- đỏ
        warning = { "DiagnosticWarn",  "#F59E0B" }, -- cam
        info    = { "DiagnosticInfo",  "#2563EB" }, -- xanh
        note    = { "#22C55E" },                    -- xanh lá
        fixme   = { "#A855F7" },                    -- 💜 tím 
      },
    },

    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo Comment" },

      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "All Todos (Trouble)" },
      {
        "<leader>xT",
        "<cmd>Trouble todo toggle filter = { tag = { TODO, FIXME, NOTE, HACK, BUG } }<cr>",
        desc = "Todos (Filtered)",
      },

      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "All Todos (Telescope)" },
      {
        "<leader>sT",
        "<cmd>TodoTelescope keywords=TODO,FIXME,NOTE,HACK,BUG<cr>",
        desc = "Todos (Filtered)",
      },
    },
  },
  -- DAP với cấu hình DAP UI và mason-nvim-dap tự động cài adapter
  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    config = function()
      -- load mason-nvim-dap here, after all adapters have been setup
      if LazyVim.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ff0000" })

      for name, sign in pairs(LazyVim.config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DapBreakpoint", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      -- ===== LOAD LANGUAGE CONFIGS =====
      require("config.cpp-dap")
      require("config.csharp-dap")      
      require("config.java-jdtls-dap")  
    end,
  },

  -- ===== NVIM-DAP-UI =====
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "x"} },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  -- ===== NVIM-DAP-VIRTUAL-TEXT =====
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },

  -- ===== NVIM-NIO =====
  {
    "nvim-neotest/nvim-nio",
  },

  -- ===== MASON-NVIM-DAP =====
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        "codelldb",    -- C/C++/Rust
        "netcoredbg",           -- C# 
        "java-debug-adapter",   -- Java 
      },
    },
    config = function() end,
  },

}