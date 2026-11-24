-- Rex config: https://superlogical.com

local terminal = "com.superlogical.terminal"

-- The working directory of a block's foreground process, or nil if Rex can't tell
local function block_cwd(block_id)
  if block_id == nil then return nil end
  local process = rex.block.call(terminal, "process", { block_id = block_id })
  return process and process.foreground and process.foreground.cwd
end

-- Open a tab in the focused terminal's directory, then offer to name it.
-- Submitting an empty name or pressing Escape leaves the tab unnamed.
rex.action{
  name = "new_tab",
  title = "New Named Tab…",
  description = "Open a new tab and ask for its name",
  run = function(ctx)
    local window, err = rex.session.new_window{
      layout = rex.layout.block{
        flavor = terminal .. ".shell",
        options = { cwd = block_cwd(ctx.block_id) },
      },
    }
    if err ~= nil then error(err, 0) end

    -- Prompts need Rex 0.1.0-preview.21 or later; on older servers this is a plain new tab
    if rex.ui == nil then return end

    local name = rex.ui.input{
      title = "Name this tab",
      placeholder = "Return or Escape to leave it unnamed",
      confirm = "Name tab",
    }
    name = name and name:match("^%s*(.-)%s*$")
    if name == nil or name == "" then return end

    local _, label_err = rex.session.set_window_label{
      window_id = window.window_id,
      label = name,
    }
    if label_err ~= nil then error(label_err, 0) end
  end,
}

rex.bind("cmd+t", "new_tab")

-- Ask for a new label, trimmed. Returns nil on Escape; an empty string resets
-- the label to Rex's default.
local function prompt_label(title)
  if rex.ui == nil then return nil end
  local name = rex.ui.input{
    title = title,
    placeholder = "Leave empty to reset",
    confirm = "Rename",
  }
  return name and name:match("^%s*(.-)%s*$")
end

-- The window (tab) that holds a block, or else the session's active window.
-- Actions only get ctx.block_id, so look it up in the session view.
local function window_of(block_id)
  local view = rex.session.view{}
  for _, window in ipairs(view.windows) do
    for _, layer in ipairs(window.layers) do
      for _, block in ipairs(layer.blocks) do
        if block.block_id == block_id then return window.window_id end
      end
    end
  end
  return view.active_window_id
end

rex.action{
  name = "rename_tab",
  title = "Rename Tab…",
  description = "Rename the focused tab",
  run = function(ctx)
    local name = prompt_label("Rename this tab")
    if name == nil then return end
    local _, err = rex.session.set_window_label{
      window_id = window_of(ctx.block_id),
      label = name,
    }
    if err ~= nil then error(err, 0) end
  end,
}

rex.action{
  name = "rename_pane",
  title = "Rename Pane…",
  description = "Rename the focused pane",
  run = function(ctx)
    local name = prompt_label("Rename this pane")
    if name == nil then return end
    local _, err = rex.session.set_block_label{
      block_id = ctx.block_id,
      label = name,
    }
    if err ~= nil then error(err, 0) end
  end,
}

rex.bind("cmd+shift+r", "rename_tab")
rex.bind("cmd+r", "rename_pane")
