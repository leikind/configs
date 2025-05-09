-- ~/.wezterm.lua

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- https://wezterm.org/config/lua/config/window_decorations.html
config.window_decorations = 'RESIZE'
-- config.window_decorations = 'TITLE | RESIZE'

-- https://wezterm.org/config/lua/config/use_fancy_tab_bar.html
config.use_fancy_tab_bar = true

-- https://wezterm.org/config/lua/wezterm/font.html
config.font = wezterm.font('JetBrains Mono')
-- config.font = wezterm.font 'Fira Code'
-- config.font = wezterm.font("Hack", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_size = 14.0
wezterm.log_info("Using font config:", config.font)

-- https://wezterm.org/colorschemes/index.html
-- https://wezterm.org/config/appearance.html
config.color_scheme = 's3r0 modified (terminal.sexy)'
-- config.color_scheme = 'DanQing'
-- config.color_scheme = 'Lunaria Dark (Gogh)'

-- https://wezterm.org/config/appearance.html#defining-your-own-colors
config.colors = {
  split = "#000000",
  cursor_bg = "#ffffff",
  cursor_border = "#ffffff",
  tab_bar = {
    active_tab = {
      bg_color = '1f1f1f',
      fg_color = '#ffffff',
    }
  }
}

-- https://wezterm.org/config/default-keys.html
config.keys = {
  {
    key = 'LeftArrow',
    mods = 'CMD|OPT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'RightArrow',
    mods = 'CMD|OPT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'DownArrow',
    mods = 'CMD|OPT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    key = 'UpArrow',
    mods = 'CMD|OPT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'D',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitPane {
      direction = 'Down',
      size = { Percent = 50 }
    }
  },
  {
    key = 'F',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitPane {
      direction = 'Right',
      size = { Percent = 50 }
    }
  }
}

-- hyperlinks

-- Based on https://gist.github.com/letieu/ac0034c2452ef41f967eca3cca44bc08

local function get_pwd(pane)
  local pwd = pane:get_current_working_dir()
  return pwd.file_path
end

local function extract_filename(uri)
  -- `file://path/to/file`
  local start, match_end = uri:find("file:");

  if start == 1 then
    -- remove "file://", -> `hostname/path/to/file`
    local host_and_path = uri:sub(match_end + 3)
    return host_and_path
  else
    return nil
  end
end

local function extract_line_and_name(uri)
  local name = extract_filename(uri)

  if name then
    local line = 1
    -- check if name has a line number (e.g. `file:.../file.txt:123 or file:.../file.txt:123:456`)
    local start, match_end = name:find(":[0-9]+")
    if start then
      -- line number is 123
      line = name:sub(start + 1, match_end)
      -- remove the line number from the filename
      name = name:sub(1, start - 1)
    end

    return line, name
  else
    return nil, nil
  end
end

local function open_in_zed(full_path, line)
  if full_path and line then
    wezterm.background_child_process({ "/usr/local/bin/zed", full_path .. ":" .. line })
  else
    wezterm.background_child_process({ "/usr/local/bin/zed", full_path })
  end
end

wezterm.on("open-uri", function(window, pane, uri)
  -- wezterm.log_info("uri ==>", uri)

  local line, name = extract_line_and_name(uri)

  -- wezterm.log_info("name ==>", name)
  -- wezterm.log_info("line ==>", line)

  if name then
    local pwd = get_pwd(pane)
    -- wezterm.log_info("pwd ==>", pwd)
    local full_path = pwd .. "/" .. name
    wezterm.log_info("full_path ==>", full_path)
    open_in_zed(full_path, line)
  end

  -- prevent the default action from opening in a browser
  return false
end)

local custom_hyperlinks = {
  -- lib/atomic/models/error.ex:129
  {
    regex = [[\b([^ \t\n:]+\.[a-z]+):(\d+)]],
    -- regex = [[\b([^ \t\n:]+):(\d+)]],
    format = "file://$1:$2",
    -- highlight = 1,
  },
  -- lib/atomic/models/error.ex
  -- {
  --   regex = [[\b([^ \t\n:]+)]],
  --   format = "file://$1",
  --   -- highlight = 1,
  -- }
}

for _, rule in ipairs(wezterm.default_hyperlink_rules()) do
  table.insert(custom_hyperlinks, rule)
end

config.hyperlink_rules = custom_hyperlinks

return config
