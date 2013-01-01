theme = {}
local home = os.getenv("HOME")

-- Set the path to your wallpaper here
theme.wallpaper = home .. "/.wallpaper/current.jpg"

theme.font          = "DejaVu Mono 8"

theme.bg_normal     = "#050608"
theme.bg_focus      = "#050608"
theme.bg_urgent     = "#050608"
theme.bg_minimize   = "#050608"

theme.fg_normal     = "#B1917A"
theme.fg_focus      = "#A9D7F2"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#B1917A"

-- Change if you want to color focus in tasklist
theme.tasklist_fg_focus = "#B1917A"

theme.border_width  = "1"
theme.border_normal = "#050608"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

theme.bg_widget        = "#333333"
theme.fg_widget        = "#908884"
theme.fg_center_widget = "#636363"
theme.fg_end_widget    = "#ffffff"
theme.fg_off_widget    = "#22211f"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua

-- You can use your own layout icons like this:
theme.layout_floating  = "~/.config/awesome/icons/layouts/floatingw.png"
theme.layout_max = "~/.config/awesome/icons/layouts/maxw.png"
theme.layout_tilebottom = "~/.config/awesome/icons/layouts/tilebottomw.png"
theme.layout_tile = "~/.config/awesome/icons/layouts/tilew.png"
-- Icons for unused layouts
--theme.layout_fairh = "/usr/share/awesome/themes/default/layouts/fairhw.png"
--theme.layout_fairv = "/usr/share/awesome/themes/default/layouts/fairvw.png"
--theme.layout_fullscreen = "/usr/share/awesome/themes/default/layouts/fullscreenw.png"
--theme.layout_magnifier = "/usr/share/awesome/themes/default/layouts/magnifierw.png"
--theme.layout_tileleft   = "/usr/share/awesome/themes/default/layouts/tileleftw.png"
--theme.layout_tiletop = "/usr/share/awesome/themes/default/layouts/tiletopw.png"
--theme.layout_spiral  = "/usr/share/awesome/themes/default/layouts/spiralw.png"
--theme.layout_dwindle = "/usr/share/awesome/themes/default/layouts/dwindlew.png"

theme.awesome_icon = "~/.config/awesome/icons/awesome.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
