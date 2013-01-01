## dotfiles

I'm using Arch Linux and this repo represents a huge part of my system configuration.
For now there's not much here, but I will add more in the future.
Forking is highly encouraged.

## Installation

Run
```sh
git clone https://github.com/tmlye/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```
and then execute the script. This should symlink all the files in the `~/.dotfiles` directory to the correct
locations in your home folder.

In order for awesomepd to work correctly, you need to have `mpc` installed!

### Wallpaper

Simply place your wallpaper in `~/.wallpaper/current.jpg` and everything should work fine.
You can modify the location for the wallpaper in `~/.dotfiles/awesome/themes/default/theme.lua`.

## Credit

Credit for the colors and the zsh config goes to [crshd] (https://github.com/crshd), from whom I copied most of it.
Some of the remaining dotfiles are based on other people's work as well, but modified beyond recognition.
This repo is heavily inspired by [holman's dotfiles] (https://github.com/holman/dotfiles).
