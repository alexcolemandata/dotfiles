#!/bin/bash

# ## Finder
# Show pathbar
defaults write com.apple.finder "ShowPathbar" -bool "true"


killall Finder


# ## Dock

# ### Dock - Autohide
# make dock auto-hide
defaults write com.apple.dock "autohide" -bool "true"

# make dock appear with mouse quicker
defaults write com.apple.dock "autohide-delay" -float "0.1"

# make dock hide/show animation quicker
defaults write com.apple.dock "autohide-time-modifier" -float "0.1"

# ### Dock - Behaviour

# prevent dock from showing recent apps
defaults write com.apple.dock "show-recents" -bool "false"

# only show active apps
defaults write com.apple.dock "static-only" -bool "true"

# ### Spaces

# prevent automatic reordering of spaces
defaults write com.apple.dock "mru-spaces" -bool "false"

killall Dock
