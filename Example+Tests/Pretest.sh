#!/bin/sh
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR
brew install xctool --HEAD
gem install cocoapods
pod install
