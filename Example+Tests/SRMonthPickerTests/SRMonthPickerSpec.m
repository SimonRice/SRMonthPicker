/*
 Copyright (C) 2012-2013 Simon Rice
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <SRMonthPicker/SRMonthPicker.h>

#import "SRMonthPickerSpec.h"

SPEC_BEGIN(SRMonthPickerSpec)

describe(@"SRMonthPicker", ^{
    it(@"should initialise to the current month via the designated initialiser", ^{
        SRMonthPicker *monthPicker = [[SRMonthPicker alloc] init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *monthPickerComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:monthPicker.date];
        NSDateComponents *todayComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
        
        [[theValue(monthPickerComponents.day) shouldNot] equal:theValue(todayComponents.day)];
        [[theValue(monthPickerComponents.day) should] equal:theValue(1)];
        
        [[theValue(monthPickerComponents.month) should] equal:theValue(todayComponents.month)];
        [[theValue(monthPickerComponents.year) should] equal:theValue(todayComponents.year)];
    });
    
    it(@"should initialise to the specified month via the initialiser", ^{
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:1368426075];
        SRMonthPicker *monthPicker = [[SRMonthPicker alloc] initWithDate:date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *monthPickerComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:monthPicker.date];
        NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
        
        [[theValue(monthPickerComponents.day) shouldNot] equal:theValue(dateComponents.day)];
        [[theValue(monthPickerComponents.day) should] equal:theValue(1)];
        
        [[theValue(monthPickerComponents.month) should] equal:theValue(dateComponents.month)];
        [[theValue(monthPickerComponents.year) should] equal:theValue(dateComponents.year)];
    });
});

SPEC_END