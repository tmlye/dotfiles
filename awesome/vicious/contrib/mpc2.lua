---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2010, Adrian C. <anrxc@sysphere.org>
--  * (c) 2009, Lucas de Vries <lucas@glacicle.com>
---------------------------------------------------

-- {{{ Grab environment
local type = type
local io = { popen = io.popen }
local setmetatable = setmetatable
local string = { find = string.find }
local helpers = require("vicious.helpers")
-- }}}


-- Mpc: provides the currently playing song in MPD
-- vicious.contrib.mpc
local mpc2 = {}


-- {{{ MPC widget type
local function worker(format, warg)
    local mpd_state  = {
        ["{volume}"] = 0,
        ["{state}"]  = "N/A",
        ["{Artist}"] = "N/A",
        ["{Title}"]  = "N/A",
        ["{Album}"]  = "N/A",
        ["{Genre}"]  = "N/A",
        --["{Name}"] = "N/A",
        --["{file}"] = "N/A",
    }

    -- Fallback to MPD defaults
    local pass = warg and (warg.password or warg[1]) or "\"\""
    local host = warg and (warg.host or warg[2]) or "127.0.0.1"
    local port = warg and (warg.port or warg[3]) or "6600"

    -- Get data from mpd
    local f = io.popen("mpc -f '%artist% - %title% -'")
    local track = f:read("*line")

    if (string.find(track, "error:") ~= nil) then
        return mpd_state
    elseif (string.find(track, "volume:") ~= nil) then
        mpd_state["{state}"] = "Stop"
        return mpd_state
    end

    local status = f:read("*line")
    f:close()

    local artist = string.match(track, "(.+)[%s]%-[%s].*[%s]%-")
    local title = string.match(track, ".*[%s]%-[%s](.*)[%s]%-")
    local state = string.match(status, "%[([%w]+)%]")

    if artist ~= nil then
        mpd_state["{Artist}"] = helpers.escape(artist)
    end

    if title ~= nil then
        mpd_state["{Title}"] = helpers.escape(title)
    end

    if state == "playing" then
        mpd_state["{state}"] = "Play"
    elseif state == "paused" then
        mpd_state["{state}"] = "Pause"
    end

    return mpd_state
end
-- }}}

return setmetatable(mpc2, { __call = function(_, ...) return worker(...) end })
