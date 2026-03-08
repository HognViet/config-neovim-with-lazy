local dap = require("dap")

--  ADAPTER NETCOREDBG 
dap.adapters.netcoredbg = {
  type = "executable",
  command = vim.fn.stdpath("data")
    .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe",
  args = { "--interpreter=vscode" },
}

--  HELPER: find highest netX.Y folder 
local function find_latest_net_debug_dll()
  local debug_dir = vim.fn.getcwd() .. "\\bin\\Debug\\"

  if vim.fn.isdirectory(debug_dir) == 0 then
    return nil
  end

  local nets = vim.fn.glob(debug_dir .. "net*", 0, 1)
  if #nets == 0 then
    return nil
  end

  -- sort: net10.0 > net9.0 > net8.0
  table.sort(nets, function(a, b)
    local na = tonumber(a:match("net(%d+)")) or 0
    local nb = tonumber(b:match("net(%d+)")) or 0
    return na > nb
  end)

  local dlls = vim.fn.glob(nets[1] .. "\\*.dll", 0, 1)
  return dlls[1]
end

-- CONFIG C# (AUTO NET) 
dap.configurations.cs = {
  -- OPTION 1: Terminal tích hợp trong nvim
  {
    name = "Launch C# (Integrated Terminal)",
    type = "netcoredbg",
    request = "launch",

    cwd = "${workspaceFolder}",
    stopAtEntry = false,
    justMyCode = true,
    console = "integratedTerminal",

    program = function()
      local dll = find_latest_net_debug_dll()
      if dll then
        return dll
      end

      return vim.fn.input(
        "Path to dll: ",
        vim.fn.getcwd() .. "\\bin\\Debug\\",
        "file"
      )
    end,
  },

  -- OPTION 2: Output trong DAP REPL
  {
    name = "Launch C# (Internal Console/REPL)",
    type = "netcoredbg",
    request = "launch",

    cwd = "${workspaceFolder}",
    stopAtEntry = false,
    justMyCode = true,
    console = "internalConsole",

    program = function()
      local dll = find_latest_net_debug_dll()
      if dll then
        return dll
      end

      return vim.fn.input(
        "Path to dll: ",
        vim.fn.getcwd() .. "\\bin\\Debug\\",
        "file"
      )
    end,
  },
}