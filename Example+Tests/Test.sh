#!/bin/sh
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

xctool -workspace SRMonthPickerExample.xcworkspace -scheme SRMonthPickerTests build
xctool -workspace SRMonthPickerExample.xcworkspace -scheme SRMonthPickerTests build-tests
xctool -workspace SRMonthPickerExample.xcworkspace -scheme SRMonthPickerTests test
