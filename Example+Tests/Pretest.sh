#!/bin/sh
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd /usr/local
git fetch origin
git reset --hard origin/master

brew update
brew install xctool

cd $DIR
pod install
