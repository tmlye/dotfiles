## dotfiles

I'm using Arch Linux and this repo represents a huge part of my system configuration.
Scroll down to see what it looks like.
Forking is highly encouraged.

## Installation

Check the folder names to see which programs are configured with these dotfiles.

Run
```sh
git clone https://github.com/tmlye/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```
and then execute the script. This should symlink all the files in the `~/.dotfiles` directory to the correct
locations in your home folder. Backups will be saved as filename.backup.

### Wallpaper

Simply place your wallpaper in `~/.wallpaper/current.jpg` and everything should work fine.
You can modify the location for the wallpaper in `~/.dotfiles/sway/config`.

## Screenshots

![clean](https://saschaeglau.com/files/clean.png "Clean")
![dirty](https://saschaeglau.com/files/dirty.png "Dirty")

## Credit

Credit for the colors and parts of the zsh theme goes to [crshd](https://github.com/crshd).
Some of the remaining dotfiles are based on other people's work as well, but modified beyond recognition.
This repo is heavily inspired by [holman's dotfiles](https://github.com/holman/dotfiles).
