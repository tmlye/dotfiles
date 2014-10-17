## dotfiles

I'm using Arch Linux and this repo represents a huge part of my system configuration.
Scroll down to see what it looks like.
Forking is highly encouraged.

## Installation

Run
```sh
git clone https://github.com/tmlye/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```
and then execute the script. This should symlink all the files in the `~/.dotfiles` directory to the correct
locations in your home folder. Backups will be saved as filename.backup.

### Awesome

- *Wireless*: You will probably have to change the name of the wireless card, you can do this in the at the top of the rc.lua file.
  The widget displays 'off', if the card is currently powered down, e.g. by rfkill.
- *Browser*: I use firefox as my default browser, change the value in rc.lua if you use anything different
- *Keybindings*: You might want to change the keybindings as well, here's what I use
  - mod4 + q : launches browser
  - mod4 + e : launches filemanager (ranger)
  - mod4 + F12 : lock screen (requires xautolock and slock)
  - All other keys are default awesome bindings
- *Battery*: In case you have two batteries in your laptop, the battery widget will show both, if not, it won't
- *Volumne*: You can specify which soundcard to control with this widget at the top of rc.lua. Use ``aplay -l`` to get the number of your card. 
  Right clicking on the volume text will mute the internal speaker (not master volumne) and change the icon accordingly.
  This means you can still use headphones. If your soundcard does not have speperate controls for speaker and headphones, you will need to fix this.
  Left clicking the text will open alsamixer. Scrolling while hovering over the text will change master volumne.
- *MPD*: The MPD icon changes according to the state MPD is in. If the state is 'stop' nothing will be shown. You can specify the IP, port and password at the top of rc.lua.
- *Weather*: You will need to change the ICAO (airport code) to your city at the top of rc.lua


### Wallpaper

Simply place your wallpaper in `~/.wallpaper/current.jpg` and everything should work fine.
You can modify the location for the wallpaper in `~/.dotfiles/awesome/theme.lua`.

## Screenshots

![clean](https://saschaeglau.com/files/clean.png "Clean")
![dirty](https://saschaeglau.com/files/dirty.png "Dirty")

## Credit

Credit for the colors and parts of the zsh theme goes to [crshd] (https://github.com/crshd).
Some of the remaining dotfiles are based on other people's work as well, but modified beyond recognition.
This repo is heavily inspired by [holman's dotfiles] (https://github.com/holman/dotfiles).
