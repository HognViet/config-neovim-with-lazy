local dap = require("dap")

-- ===== JAVA ADAPTER (JDTLS) =====
dap.adapters.java = function(callback, _)
  vim.schedule(function()
    vim.lsp.buf_request(0, "workspace/executeCommand", {
      command = "vscode.java.startDebugSession",
    }, function(err, port)
      if err then
        vim.notify("JDTLS debug error: " .. vim.inspect(err), vim.log.levels.ERROR)
        return
      end

      callback({
        type = "server",
        host = "127.0.0.1",
        port = port,
      })
    end)
  end)
end

-- ===== MAVEN / GRADLE CONFIG =====
dap.configurations.java = {
  {
    name = "Debug Java (Maven / Gradle)",
    type = "java",
    request = "launch",

    -- ✨ QUAN TRỌNG: để trống
    mainClass = nil,
    projectName = nil,
  },

  {
    name = "Attach JVM (remote)",
    type = "java",
    request = "attach",
    hostName = "localhost",
    port = 5005,
  },
}

vim.g.dap_log_level = "INFO"
