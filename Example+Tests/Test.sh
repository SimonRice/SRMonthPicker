#!/bin/sh
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

xctool -workspace SRMonthPickerExample.xcworkspace -scheme SRMonthPickerTests test
