#!/bin/sh
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

gem update

brew update
brew install xctool

cd $DIR
pod install
