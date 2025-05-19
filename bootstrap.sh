#!/bin/sh

set -e

nix develop \
  --extra-experimental-features 'flakes nix-command' \
  --command "reload"
