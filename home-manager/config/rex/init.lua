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
