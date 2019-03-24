# Changes in 2.3.3

Feature: Add battery widget type for OpenBSD

Fixes:

- [mpd] Lua 5.3 compatibility
- [bat\_freebsd] Update battery state symbols

# Changes in 2.3.2

Features:

- Support stacked graphs
- [hwmontemp\_linux] Provide name-based access to hwmon sensors via sysfs
- [mpd\_all] Expose more informations and format time in [hh:]mm:ss

Fixes:

- Improve defaults and mechanism for data caching
- Escape XML entities in results by default
- [weather\_all] Update NOAA link and use Awesome asynchronous API
- [mem\_linux] Use MemAvailable to calculate free amount
- [mem\_freebsd] Correct calculation and switch to swapinfo for swap
- [bat\_freebsd] Add critical charging state
- [fs\_all] Fix shell quoting of option arguments

Moreover, `.luacheckrc` was added and `README.md` was refomatted for the ease
of development.

# Changes in 2.3.1

Fixes:

- widgets can be a function again (regression introduced in 2.3.0)

# Changes in 2.3.0

Features:
- add btc widget
- add cmus widget
- alsa mixer also accept multiple arguments

Fixes:

- pkg now uses non-blocking asynchronous api

# Changes in 2.2.0

Notable changes:

- moved development from git.sysphere.org/vicious to github.com/Mic92/vicious
- official freebsd support
- escape variables before passing to shell
- support for gear timers
- fix weather widget url
- add vicious.call() method to obtain data outside of widgets

For older versions see git log
