#! /bin/bash

echo "- Symlinking nu config"
ln -s ~/repos/dotfiles/nu.env $nu.env-path
ln -s ~/repos/dotfiles/nu.config $nu.config-path

echo "- Symlinking gitconfig"
ln -s ~/repos/gitconfig ~/.gitconfig

