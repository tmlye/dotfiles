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

-- Name of wificard for wifi widget
wificard = "wlp3s0"

-- Which soundcard to use for volumne widget
soundCard = "1"

-- MPD Data
mpdHost = "0.0.0.0"
mpdPassword = "\"\""
mpdPort = "6600"

-- Airportcode for the weather widget
airportcode = "VHHH"
-- Nuernberg: EDDN, Kuala Lumpur: WMKK, Hong Kong: VHHH

home = os.getenv("HOME")
exec = awful.util.spawn

-- Themes define colours, icons, and wallpapers
beautiful.init(home .. "/.config/awesome/theme.lua")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.max,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
	names = { 1, 2, 3, 4 },
	layout = { layouts[4], layouts[4], layouts[1], layouts[1] }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
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
vicious.register(weatherwidget, vicious.widgets.weather, "${tempc}°", 301, airportcode)

-- Helper for setting the volume icon
function setVolIconBasedOnStatus ()
    local f = assert(io.popen("amixer -c "..soundCard.." cget name='Speaker Playback Switch'"))
    local speaker = assert(f:read("*all"))
    f:close()
    if(string.match(speaker, "values=(%a+)") == "off") then
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
vicious.register(volwidget, vicious.widgets.volume, " $1% ", 3, "-c "..soundCard.." Master")
-- Keybindings for widget
volwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () exec(terminal .. " -e alsamixer -c "..soundCard) end),
    awful.button({ }, 3,
        function ()
            exec("amixer -c "..soundCard.." -q sset Speaker toggle")
            setVolIconBasedOnStatus()
        end),
    awful.button({ }, 4, function () exec("amixer -c "..soundCard.." -q sset Master 2dB+", false) end),
    awful.button({ }, 5, function () exec("amixer -c "..soundCard.." -q sset Master 2dB-", false) end)
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
    end, 7, wificard)

-- Create a battery widget
baticon = wibox.widget.imagebox()
baticon:set_image(home .. "/.config/awesome/icons/bat.png")
--Initialize widget
batwidget = wibox.widget.textbox()
--Register widget
vicious.register(batwidget, vicious.widgets.bat, "$1$2", 37, "BAT0")
-- Second battery
--Initialize widget
batwidget2 = wibox.widget.textbox()
--Register widget
vicious.register(batwidget2, vicious.widgets.bat, "$1$2", 31, "BAT1")

-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
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

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left, order matters
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
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
    local f = assert(io.popen("ls /sys/class/power_supply | grep BAT -c"))
    local batCount = assert(f:read())
    f:close()
    if(batCount == "2") then
        right_layout:add(spacer)
        right_layout:add(batwidget2)
    end
    right_layout:add(spacer)
    right_layout:add(seperator)
    right_layout:add(spacer)
    -- Layout box
    right_layout:add(mylayoutbox[s])
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

    mywibox[s]:set_widget(layout)
end
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

    -- Standard programs
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,		      }, "e", function () awful.util.spawn(filemngr) end),
    awful.key({ modkey,           }, "q", function() awful.util.spawn(browser) end),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),
    
    -- Lock Screen
    awful.key({modkey,		  }, "F12",   function () awful.util.spawn("xautolock -locknow") end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digits we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
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
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false} },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tag number 1 of screen 1.
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][1] } },
    -- Fix fullscreen for flash video
    { rule = { class = "Plugin-container" },
      properties = { floating = true } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
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
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
