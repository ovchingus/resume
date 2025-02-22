#!/usr/bin/env bash

# Build the flake
nix build

# Copy files from the result symlink to the current working directory
cp -v result/* .
