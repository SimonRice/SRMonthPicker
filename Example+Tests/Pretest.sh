#!/bin/sh
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR
brew remove --force xctool
brew install xctool --HEAD

gem install cocoapods
pod install
