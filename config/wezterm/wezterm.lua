local wezterm = require 'wezterm';


local base_dir = wezterm.home_dir .. "/.local/share/wezterm/"
local wsl_sock = base_dir .. "wezterm.sock"

local config = wezterm.config_builder()

-- Appearance

  config.font = wezterm.font_with_fallback({
    "Explex35 Console NF Regular",
    "HackGen35 Console NF",
    "Moralerspace Neon NF",
    "UDEV Gothic NF Regular",
    "HackGen Console NF",
  })

  config.font_size = 14.0
  config.freetype_load_target = "Normal"
  config.freetype_render_target = "Light"

  -- config.color_scheme = "Blazer"
  -- config.color_scheme = "Hardcore"
  -- config.color_scheme = "rose-pine-dawn"
  config.color_scheme = "tinacious_design_light"

  config.default_prog = {"bash"}

  config.use_fancy_tab_bar = true

  config.window_decorations = "RESIZE"
  config.window_padding = {
      left = 2,
      right = 2,
      top = 0,
      bottom = 0,
  }

  config.audible_bell = "Disabled"

  config.canonicalize_pasted_newlines = "None"

  -- https://alexplescan.com/posts/2024/08/10/wezterm/
  wezterm.on('update-status', function(window)
    -- Grab the utf8 character for the "powerline" left facing
    -- solid arrow.
    local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  
    -- Grab the current window's configuration, and from it the
    -- palette (this is the combination of your chosen colour scheme
    -- including any overrides).
    local color_scheme = window:effective_config().resolved_palette
    local bg = color_scheme.foreground
    local fg = color_scheme.background
  
    window:set_right_status(wezterm.format({
      -- First, we draw the arrow...
      { Background = { Color = 'none' } },
      { Foreground = { Color = bg } },
      { Text = SOLID_LEFT_ARROW },
      -- Then we draw our text
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Text = ' ' .. wezterm.hostname() .. ' ' },
    }))
  end)

-- Key bindings

  -- config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 500 }

  config.keys = {
    {key="P", mods="SHIFT|CTRL", action=wezterm.action.SpawnCommandInNewTab{}},
    {key="L", mods="SHIFT|CTRL", action=wezterm.action.ShowLauncher},
  }


-- Launcher settings

  config.launch_menu = {
    {
      label = "PowerShell 7",
      args = {"pwsh"},
    },
  }

return config
