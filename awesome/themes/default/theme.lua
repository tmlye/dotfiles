theme = {}
home = os.getenv("HOME")

-- You can use your own command to set your wallpaper
theme.wallpaper_cmd = { "feh --bg-fill " .. home .. "/.wallpaper/current.jpg" }

theme.font          = "DejaVu Mono 8"

theme.bg_normal     = "#050608"
theme.bg_focus      = "#050608"
theme.bg_urgent     = "#050608"
theme.bg_minimize   = "#050608"

theme.fg_normal     = "#B1917A"
theme.fg_focus      = "#A9D7F2"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#B1917A"

theme.tasklist_fg_focus = "#B1917A" -- do not color focus in tasklist

theme.border_width  = "1"
theme.border_normal = "#050608"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

theme.bg_widget        = "#333333"
theme.fg_widget        = "#908884"
theme.fg_center_widget = "#636363"
theme.fg_end_widget    = "#ffffff"
theme.fg_off_widget    = "#22211f"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- theme.tasklist_floating_icon = "~/.config/awesome/icons/max2.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- You can use your own layout icons like this:
theme.layout_fairh = "/usr/share/awesome/themes/default/layouts/fairhw.png"
theme.layout_fairv = "/usr/share/awesome/themes/default/layouts/fairvw.png"
theme.layout_floating  = "~/.config/awesome/themes/default/layouts/floatingw.png"
theme.layout_magnifier = "/usr/share/awesome/themes/default/layouts/magnifierw.png"
theme.layout_max = "~/.config/awesome/themes/default/layouts/maxw.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/default/layouts/fullscreenw.png"
theme.layout_tilebottom = "~/.config/awesome/themes/default/layouts/tilebottomw.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/default/layouts/tileleftw.png"
theme.layout_tile = "~/.config/awesome/themes/default/layouts/tilew.png"
theme.layout_tiletop = "/usr/share/awesome/themes/default/layouts/tiletopw.png"
theme.layout_spiral  = "/usr/share/awesome/themes/default/layouts/spiralw.png"
theme.layout_dwindle = "/usr/share/awesome/themes/default/layouts/dwindlew.png"

theme.awesome_icon = "~/.config/awesome/icons/awesome.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
