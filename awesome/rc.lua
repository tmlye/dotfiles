-- ~/.config/awesome/rc.lua
-- Standard awesome library
local awful = require("awful")
local gears = require("gears")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
-- Notifications
local naughty = require("naughty")
-- Widgets and Layout
local wibox = require("wibox")
local vicious = require("vicious")

-- {{{ Variable definitions
-- You might want to change these values

terminal = "urxvt"
editor = os.getenv("EDITOR") or "gvim"
editor_cmd = terminal .. " -e " .. editor

-- Launched with MOD4+e
filemngr = terminal .. " -e ranger"
-- Launched with MOD4+q
browser = "firefox"
-- Launched with MOD4+i
ircclient = terminal .. " -e irssi"
-- Launched with MOD4+w
mailclient = terminal .. " -e mutt"
-- Launched with MOD4+z
mpdclient = terminal .. " -e ncmpcpp"
-- Lock screen with MOD4+F12
lockcmd = "xautolock -locknow"

-- Name of wificard for wifi widget
wificard = "wlp3s0"

-- MPD Data
mpdHost = "0.0.0.0"
mpdPassword = "\"\""
mpdPort = "6600"

-- Airportcode (ICAO) for the weather widget
airportcode = "EDDF"


home = os.getenv("HOME")
exec = awful.spawn

-- Themes define colours, icons, and wallpapers
beautiful.init(home .. "/.config/awesome/theme.lua")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Set number of batteries
local f = assert(io.popen("ls /sys/class/power_supply | grep BAT -c"))
local batCount = assert(f:read())
f:close()

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.max,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,

}

-- Tags
local tags = { "1", "2", "3", "4" }
-- Defaultlayout for each tag (in order)
local default_layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.tile
}

-- Disable titlebars
local titlebars_enabled = false
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Wallpaper
-- This gets called for each screen below
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
-- }}}

-- {{{ Wibox

-- Seperators
spacer = wibox.widget.textbox()
spacer:set_markup(" ")
seperator = wibox.widget.textbox()
seperator:set_markup("|")
dash = wibox.widget.textbox()
dash:set_markup("-")

-- MPD icon
-- Icon is updated according to the current MPD status
-- see MPD textwidget below
mpdicon = wibox.widget.imagebox()
mpdicon:set_image(home .. "/.config/awesome/icons/note.png")

-- MPD textwidget
-- Initialize widget
mpdwidget = wibox.widget.textbox()
-- Register widget
wargs = { mpdPassword, mpdHost, mpdPort }
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then
            --mpdicon:set_image(home .. "/.config/awesome/icons/stop.png")
            mpdicon:set_image(nil)
            return " "
        elseif args["{state}"] == "Pause" then
            mpdicon:set_image(home .. "/.config/awesome/icons/pause.png")
            return args["{Artist}"]..' - '.. args["{Title}"]
        elseif args["{state}"] == "Play" then
            mpdicon:set_image(home .. "/.config/awesome/icons/play.png")
            return args["{Artist}"]..' - '.. args["{Title}"]
        else
            mpdicon:set_image(home .. "/.config/awesome/icons/note.png")
            return "MPD status unknown"
        end
    end, 5, wargs)

-- Weather Widget
-- Initialize Widget
weatherwidget = wibox.widget.textbox()
-- Register Widget
vicious.register(weatherwidget, vicious.widgets.weather, "${tempc}°", 307, airportcode)
weatherwidget:buttons(awful.button({}, 1, function() vicious.force({weatherwidget}) end))

-- Helper for setting the volume icon
function setVolIconBasedOnStatus ()
    local f = assert(io.popen("amixer | grep 'Front Left: Playback' | cut -f8 -d ' '"))
    local returnValue = assert(f:read("*all"))
    f:close()
    returnValue = string.sub(returnValue, 2 , -3)
    if(returnValue == 'off') then
        -- Speaker is muted
        volicon:set_image(home .. "/.config/awesome/icons/mute.png")
    else
        volicon:set_image(home .. "/.config/awesome/icons/vol.png")
    end
end

-- Volumewidget
volicon = wibox.widget.imagebox()
setVolIconBasedOnStatus()
volwidget = wibox.widget.textbox()
vicious.register(volwidget, vicious.widgets.volume, " $1% ", 3, "Master")
-- Keybindings for widget
volwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () exec(terminal .. " -e alsamixer") end),
    awful.button({ }, 3,
        function ()
            exec("amixer -q sset Master toggle")
            setVolIconBasedOnStatus()
        end),
    awful.button({ }, 4, function () exec("amixer -q sset Master 2%+", false) end),
    awful.button({ }, 5, function () exec("amixer -q sset Master 2%-", false) end)
 ))

-- Wifiwidget
wifiwidget = wibox.widget.textbox()
vicious.register(wifiwidget, vicious.widgets.wifi,
--vicious.register(batt, get_batterystatus, '$1', 10)
    function (widget, args)
        local f = assert(io.popen("iwconfig"))
        local wifi = assert(f:read("*all"))
        f:close()
        if(string.match(wifi, "Tx%-Power=(%a+)") == "off") then
            return "<span color='#D4D7F2'>~</span> off"
        else
            return "<span color='#D4D7F2'>~</span> " .. args["{link}"] .. "%"
        end
    end, 29, wificard)

-- Create a battery widget
baticon = wibox.widget.imagebox()
baticon:set_image(home .. "/.config/awesome/icons/bat.png")
--Initialize widget
batwidget = wibox.widget.textbox()
--Register widget
vicious.register(batwidget, vicious.widgets.bat,
    function (widget, args)
        if args[2] < 4 then
            -- Notify when battery is low
            naughty.notify({
                title = "Battery low!",
                text = "\nThis is obviously not good.",
                icon = home .. "/.config/awesome/icons/crit.png",
                icon_size = 32,
                timeout = 8
            })
            baticon:set_image(home .. "/.config/awesome/icons/crit.png")
        else
            baticon:set_image(home .. "/.config/awesome/icons/bat.png")
        end
        return args[1] .. args[2]
    end, 59, "BAT0")
-- Second battery
--Initialize widget
batwidget2 = wibox.widget.textbox()
--Register widget
vicious.register(batwidget2, vicious.widgets.bat, "$1$2", 53, "BAT1")

-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
taglist_buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
)
tasklist_buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
                             if c == client.focus then
                                 c.minimized = true
                             else
                                 if not c:isvisible() then
                                     awful.tag.viewonly(c:tags()[1])
                                 end
                                 -- This will also un-minimize
                                 -- the client, if needed
                                 client.focus = c
                                 c:raise()
                             end
                         end),
    awful.button({ }, 3, function ()
                             if instance then
                                 instance:hide()
                                 instance = nil
                             else
                                 instance = awful.menu.clients({ width=250 })
                             end
                         end),
    awful.button({ }, 4, function ()
                             awful.client.focus.byidx(1)
                             if client.focus then client.focus:raise() end
                         end),
    awful.button({ }, 5, function ()
                             awful.client.focus.byidx(-1)
                             if client.focus then client.focus:raise() end
end))

local tag_count = table.maxn(tags)
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    for i = 1, tag_count do
        awful.tag.add(tags[i], {
            icon               = nil,
            layout             = default_layouts[i],
            master_fill_policy = "master_width_factor",
            gap_single_client  = false,
            gap                = 0,
            screen             = s,
        })
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left, order matters
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(s.mytaglist)
    left_layout:add(s.mypromptbox)
    left_layout:add(mpdicon)
    left_layout:add(spacer)
    left_layout:add(mpdwidget)

    -- Widgets that are aligned to the right, order matters
    local right_layout = wibox.layout.fixed.horizontal()
    -- Weather
    right_layout:add(weatherwidget)
    right_layout:add(spacer)
    right_layout:add(seperator)
    -- Volumne
    right_layout:add(volicon)
    right_layout:add(volwidget)
    right_layout:add(spacer)
    right_layout:add(seperator)
    right_layout:add(spacer)
    -- Wifi
    right_layout:add(wifiwidget)
    right_layout:add(spacer)
    right_layout:add(seperator)
    -- Battery
    right_layout:add(baticon)
    right_layout:add(batwidget)
    -- Add second battery if present
    if(batCount == "2") then
        right_layout:add(spacer)
        right_layout:add(batwidget2)
    end
    right_layout:add(spacer)
    right_layout:add(seperator)
    right_layout:add(spacer)
    -- Layout box
    right_layout:add(s.mylayoutbox)
    right_layout:add(spacer)
    right_layout:add(seperator)
    right_layout:add(spacer)
    -- Clock
    right_layout:add(mytextclock)
    -- Systray
    --if s == 1 then right_layout:add(wibox.widget.systray()) end

    -- Now bring it all together
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    --layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    s.mywibox:set_widget(layout)
end)
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Hotkeys
    awful.key({  }, "XF86MonBrightnessDown", function () io.popen("xbacklight -dec 10") end),
    awful.key({  }, "XF86MonBrightnessUp", function () io.popen("xbacklight -inc 10") end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Standard programs
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end),
    awful.key({ modkey,		      }, "e",     function () awful.spawn(filemngr) end),
    awful.key({ modkey,           }, "q",     function() awful.spawn(browser) end),
    awful.key({ modkey,           }, "i",     function() awful.spawn(ircclient) end),
    awful.key({ modkey,           }, "w",     function() awful.spawn(mailclient) end),
    awful.key({ modkey,           }, "z",     function() awful.spawn(mpdclient) end),

    awful.key({ modkey, "Shift"   }, "q",     awesome.quit),

    -- Lock Screen
    awful.key({ modkey,		      }, "F12",   function () awful.spawn(lockcmd) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"})
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, tag_count do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false} },
    -- Some programs should always float
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Ts3client_linux_amd64" },
      properties = { floating = true } },
    -- map firefox on tag number 1 of screen 1.
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][1] } },
    -- map zathura on tag number 3 of screen 1.
    { rule = { class = "Zathura" },
      properties = { tag = tags[1][3], switchtotag = true } },
    -- map libreoffice writer on tag number 3 of screen 1.
    { rule = { class = "libreoffice-writer" },
      properties = { tag = tags[1][3], switchtotag = true } },
    -- Fix fullscreen for flash video
    { rule = { class = "Plugin-container" },
      properties = { floating = true } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
