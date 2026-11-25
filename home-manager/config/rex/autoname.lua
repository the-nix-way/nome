-- Automatic tab and pane names for Rex. Each pane is named after the last part of its
-- directory, so /foo/bar/baz is baz, and each tab after its focused pane. A name you type
-- sticks. Rename it to empty to go back to the automatic name.
--
-- This runs as its own watcher, `rex do autoname.lua --all`, because this version of Rex
-- doesn't run rex.on handlers from init.lua yet.

local terminal = "com.superlogical.terminal"

-- Call a server method, returning nil instead of raising if it fails
local function call(method, args)
  local ok, result = pcall(rex.call, method, args)
  if ok then return result end
  return nil
end

-- The working directory of a shell's foreground process, or nil if Rex can't tell
local function block_cwd(session_id, block_id)
  local process = call(terminal .. ".process", { session_id = session_id, block_id = block_id, args = {} })
  return process and process.foreground and process.foreground.cwd or nil
end

-- The last part of a path: /foo/bar/baz is baz, and / is /
local function basename(path)
  if path == nil or path == "" then return nil end
  local trimmed = path:gsub("/+$", "")
  if trimmed == "" then return "/" end
  return trimmed:match("([^/]+)$")
end

-- Each pane's directory as last seen, and the name this script last gave each pane and tab.
-- IDs are unique across sessions, so one table covers them all.
local last_cwd = {}
local auto_label = {}

-- Rex's own labels: "shell" for a new pane, and "Block 89abcdef" or "Window 89abcdef" after a reset
local function is_default(label)
  return label == "" or label == "shell" or label:match("^Block %x+$") ~= nil
    or label:match("^Window %x+$") ~= nil
end

-- A label is automatic unless someone typed it: Rex's default, the name this script gave it, or
-- the name of a directory it was in. The last case covers names given before a restart.
local function is_automatic(id, label, cwds)
  if is_default(label) or auto_label[id] == label then return true end
  for _, cwd in ipairs(cwds) do
    if basename(cwd) == label then return true end
  end
  return false
end

-- Bring every automatic name in a session up to date. A label is written only when it changes,
-- so the session_view_changed this causes finds nothing left to do.
local function sync_names(session_id, changed_block_id, old_cwd)
  if session_id == nil then return end
  local view = call("session.view", { session_id = session_id })
  if view == nil or view.windows == nil then return end

  for _, window in ipairs(view.windows) do
    local window_cwds = {}

    for _, layer in ipairs(window.layers or {}) do
      for _, block in ipairs(layer.blocks or {}) do
        local id = block.block_id
        if last_cwd[id] == nil and block.flavor == terminal .. ".shell" then
          last_cwd[id] = block_cwd(session_id, id)
        end

        local cwd = last_cwd[id]
        if cwd ~= nil then
          local cwds = { cwd }
          if id == changed_block_id and old_cwd ~= nil then table.insert(cwds, old_cwd) end
          for _, c in ipairs(cwds) do table.insert(window_cwds, c) end

          local name = basename(cwd)
          local label = block.label or ""
          if label == name then
            auto_label[id] = name
          elseif is_automatic(id, label, cwds) then
            call("session.set_block_label", { session_id = session_id, block_id = id, label = name })
            auto_label[id] = name
          end
        end
      end
    end

    local name = basename(window.focused_block_id and last_cwd[window.focused_block_id])
    local label = window.label or ""
    if name ~= nil and label == name then
      auto_label[window.window_id] = name
    elseif name ~= nil and is_automatic(window.window_id, label, window_cwds) then
      call("session.set_window_label", { session_id = session_id, window_id = window.window_id, label = name })
      auto_label[window.window_id] = name
    end
  end
end

-- A shell's directory changed, or its foreground process did
rex.on(terminal .. ".process_changed", function(ev)
  local old_cwd = last_cwd[ev.block_id]
  last_cwd[ev.block_id] = block_cwd(ev.session_id, ev.block_id)
  sync_names(ev.session_id, ev.block_id, old_cwd)
end)

-- Focus moved, or a pane or tab opened, closed, or was renamed
rex.on("session_view_changed", function(ev) sync_names(ev.session_id) end)

-- Name what's already open, and note each pane's directory so that names given before this
-- watcher started still count as automatic
local sessions = call("session.list", {})
for _, session in ipairs(sessions and sessions.sessions or {}) do
  sync_names(session.session_id)
end
