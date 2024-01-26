local wezterm = require 'wezterm';

return {
    font = wezterm.font_with_fallback({
      { family = "PlemolJP Console NF", weight = "Regular", harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }, },
        "PlemolJP Console NFJ",
        "Fira Code",
        "HackGenNerd Console",
        "Consolas",
        "monospace",
    }),

    font_size = 13.2,
    freetype_load_target = "Normal",
    freetype_render_target = "HorizontalLcd",

    default_cursor_style = "SteadyUnderline",
    cursor_thickness = "0.1cell",
    
    color_scheme = "horizon-bright",
    -- color_scheme = "Isotake",

    default_prog = {"/usr/bin/bash", "-l"},

    use_fancy_tab_bar = true,
    hide_tab_bar_if_only_one_tab = true,
    tab_bar_at_bottom = true,

    -- window_background_opacity = 1.0,
    window_padding = {
        left = 2,
        right = 2,
        top = 0,
        bottom = 0,
    },

    audible_bell = "Disabled",

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
