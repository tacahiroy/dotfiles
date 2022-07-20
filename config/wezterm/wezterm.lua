local wezterm = require 'wezterm';

return {
    font = wezterm.font_with_fallback({
        "PlemolJP Console NF",
        "Fira Code",
        "HackGenNerd Console",
    }),

    font_size = 13.2,
    freetype_load_target = "Normal",
    freetype_render_target = "HorizontalLcd",
    
    -- color_scheme = "nord-light",
    color_scheme = "Isotake",

    default_prog = {"bash"},

    use_fancy_tab_bar = true,

    window_padding = {
        left = 2,
        right = 2,
        top = 0,
        bottom = 0,
    },

    keys = {
        {key="P", mods="SHIFT|CTRL", action=wezterm.action.SpawnCommandInNewTab{}},
        {key="L", mods="SHIFT|CTRL", action=wezterm.action.ShowLauncher},
    },

    -- Launcher settings
    launch_menu = {
      {
        label = "PowerShell 7",
        args = {"pwsh"},
      },
    },
}
