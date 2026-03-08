
local jdtls = require("jdtls")
local util = require("jdtls.setup")

-- ===============================
-- 1️⃣ ROOT DETECTION
-- ===============================
local root_markers = {
  ".git",
  "pom.xml",
  "mvnw",
  "build.gradle",
  "gradlew",
  "build.xml",
  "nbproject",
  ".classpath",
}

local root_dir = util.find_root(root_markers)

-- Fallback: tìm thư mục có src/
if not root_dir then
  local current = vim.fn.expand("%:p:h")
  while current and current ~= vim.fn.fnamemodify(current, ":h") do
    if vim.fn.isdirectory(current .. "/src") == 1 then
      root_dir = current
      break
    end
    current = vim.fn.fnamemodify(current, ":h")
  end
end

if not root_dir then
  return
end

-- ===============================
-- 2️⃣ AUTO-GENERATE PROJECT FILES
-- ===============================
local function detect_project_type(root)
  if vim.fn.filereadable(root .. "/pom.xml") == 1 then
    return "maven"
  end
  if vim.fn.filereadable(root .. "/build.gradle") == 1
     or vim.fn.filereadable(root .. "/build.gradle.kts") == 1 then
    return "gradle"
  end
  if vim.fn.filereadable(root .. "/build.xml") == 1
     or vim.fn.isdirectory(root .. "/nbproject") == 1 then
    return "ant"
  end
  return "plain"
end

local function ensure_project_files(root)
  local project_type = detect_project_type(root)
  local classpath

  if project_type == "maven" then
    classpath = [[<?xml version="1.0" encoding="UTF-8"?>
<classpath>
  <classpathentry kind="src" path="src/main/java"/>
  <classpathentry kind="src" path="src/test/java"/>
  <classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER"/>
  <classpathentry kind="output" path="target/classes"/>
</classpath>
]]

  elseif project_type == "gradle" then
    classpath = [[<?xml version="1.0" encoding="UTF-8"?>
<classpath>
  <classpathentry kind="src" path="src/main/java"/>
  <classpathentry kind="src" path="src/test/java"/>
  <classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER"/>
  <classpathentry kind="output" path="build/classes/java/main"/>
</classpath>
]]

  else -- ant / plain
    classpath = [[<?xml version="1.0" encoding="UTF-8"?>
<classpath>
  <classpathentry kind="src" path="src"/>
  <classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER"/>
  <classpathentry kind="output" path="build"/>
</classpath>
]]
  end

  if vim.fn.filereadable(root .. "/.classpath") == 0 then
    local f = io.open(root .. "/.classpath", "w")
    if f then
      f:write(classpath)
      f:close()
      vim.notify("✅ Generated .classpath (" .. project_type .. ")", vim.log.levels.INFO)
    end
  end

  if vim.fn.filereadable(root .. "/.project") == 0 then
    local name = vim.fn.fnamemodify(root, ":t")
    local project = string.format([[<?xml version="1.0" encoding="UTF-8"?>
<projectDescription>
  <name>%s</name>
  <buildSpec>
    <buildCommand>
      <name>org.eclipse.jdt.core.javabuilder</name>
    </buildCommand>
  </buildSpec>
  <natures>
    <nature>org.eclipse.jdt.core.javanature</nature>
  </natures>
</projectDescription>
]], name)

    local f = io.open(root .. "/.project", "w")
    if f then
      f:write(project)
      f:close()
      vim.notify("✅ Generated .project", vim.log.levels.INFO)
    end
  end
end

ensure_project_files(root_dir)

-- ===============================
-- 3️⃣ WORKSPACE
-- ===============================
local project_name = vim.fn.fnamemodify(root_dir, ":t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- ===============================
-- 4️⃣ MASON JDTLS
-- ===============================
local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local launcher_jar = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

if launcher_jar == "" then
  vim.notify("❌ JDTLS launcher not found! Install via :Mason", vim.log.levels.ERROR)
  return
end

-- ===============================
-- 5️⃣ FINAL CONFIG
-- ===============================
local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "-Xmx2g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher_jar,
    "-configuration", mason_path .. "/config_win",
    "-data", workspace_dir,
  },

  root_dir = root_dir,

  settings = {
    java = {
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },

      errors = {
        incompleteClasspath = { severity = "ignore" },
      },

      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      signatureHelp = { enabled = true },
      format = { enabled = true },
    },
  },

  init_options = {
    bundles = (function()
      local bundles = {}
      local data_path = vim.fn.stdpath("data")
      
      -- Java Debug Adapter
      local debug_path = data_path .. "/mason/packages/java-debug-adapter/extension/server"
      if vim.fn.isdirectory(debug_path) == 1 then
        local debug_jars = vim.split(vim.fn.glob(debug_path .. "/*.jar"), "\n")
        for _, jar in ipairs(debug_jars) do
          if jar ~= "" then
            table.insert(bundles, jar)
          end
        end
      end
      
      -- Java Test
      local test_path = data_path .. "/mason/packages/java-test/extension/server"
      if vim.fn.isdirectory(test_path) == 1 then
        local test_jars = vim.split(vim.fn.glob(test_path .. "/*.jar"), "\n")
        for _, jar in ipairs(test_jars) do
          if jar ~= "" then
            table.insert(bundles, jar)
          end
        end
      end
      
      -- Debug notification
      if #bundles > 0 then
        vim.notify("✅ Loaded " .. #bundles .. " debug bundles", vim.log.levels.INFO)
      else
        vim.notify("⚠️  No debug bundles! Check :Mason", vim.log.levels.WARN)
      end
      
      return bundles
    end)(),
  },

  on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set("n", "<leader>co", jdtls.organize_imports, opts)
    vim.keymap.set("n", "<leader>cv", jdtls.extract_variable, opts)
    vim.keymap.set("n", "<leader>cc", jdtls.extract_constant, opts)
    vim.keymap.set("v", "<leader>cm", function()
      jdtls.extract_method(true)
    end, opts)

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    
    vim.notify(
    "💖 JDTLS đã sẵn sàng!!!" .. vim.fn.fnamemodify(root_dir, ":t") .. "\n" ..
    "✨ Config by HongViet\n" ..
    "☕☕︎🍵 Java LSP Ready!",
    vim.log.levels.INFO,
    { title = "Java LSP" })
  end,
}

jdtls.start_or_attach(config)