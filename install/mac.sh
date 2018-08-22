#! /usr/bin/env bash

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

APPS=(
    istat-menus
    github # sourcetree
    SizeUp
    docker
    alfred
    vscode
    google-chrome
)

for app in ${APPS[@]}; do
    brew cask install $app
done

SPECIAL=(
    wget
    tmux
    git
)

for app in ${SPECIAL[@]}; do
    brew install $app
done


# anaconda
# parallels
