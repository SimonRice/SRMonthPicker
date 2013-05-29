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
        NSDateComponents *monthPickerComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit) fromDate:monthPicker.date];
        NSDateComponents *todayComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
        
        if (todayComponents.day != 1) {
            [[theValue(monthPickerComponents.day) shouldNot] equal:theValue(todayComponents.day)];
        }
        [[theValue(monthPickerComponents.day) should] equal:theValue(1)];
        [[theValue(monthPickerComponents.hour) should] equal:theValue(0)];
        [[theValue(monthPickerComponents.minute) should] equal:theValue(0)];
        [[theValue(monthPickerComponents.second) should] equal:theValue(0)];
        [[monthPickerComponents.timeZone should] equal:[NSTimeZone defaultTimeZone]];
        
        [[theValue(monthPickerComponents.month) should] equal:theValue(todayComponents.month)];
        [[theValue(monthPickerComponents.year) should] equal:theValue(todayComponents.year)];
    });
    
    it(@"should initialise to the specified month via the initialiser", ^{
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:1368426075];
        SRMonthPicker *monthPicker = [[SRMonthPicker alloc] initWithDate:date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *monthPickerComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit) fromDate:monthPicker.date];
        NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
        
        [[theValue(monthPickerComponents.day) should] equal:theValue(1)];
        [[theValue(monthPickerComponents.hour) should] equal:theValue(0)];
        [[theValue(monthPickerComponents.minute) should] equal:theValue(0)];
        [[theValue(monthPickerComponents.second) should] equal:theValue(0)];
        [[monthPickerComponents.timeZone should] equal:[NSTimeZone defaultTimeZone]];
        
        [[theValue(monthPickerComponents.month) should] equal:theValue(dateComponents.month)];
        [[theValue(monthPickerComponents.year) should] equal:theValue(dateComponents.year)];
    });
    
    it(@"should ignore the day component when its date is set", ^{
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:1368426075];
        SRMonthPicker *monthPicker = [[SRMonthPicker alloc] init];
        monthPicker.date = date;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *monthPickerComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit) fromDate:monthPicker.date];
        NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
        
        [[theValue(monthPickerComponents.day) shouldNot] equal:theValue(dateComponents.day)];
        [[theValue(monthPickerComponents.day) should] equal:theValue(1)];
        [[theValue(monthPickerComponents.hour) should] equal:theValue(0)];
        [[theValue(monthPickerComponents.minute) should] equal:theValue(0)];
        [[theValue(monthPickerComponents.second) should] equal:theValue(0)];
        [[monthPickerComponents.timeZone should] equal:[NSTimeZone defaultTimeZone]];
        
        [[theValue(monthPickerComponents.month) should] equal:theValue(dateComponents.month)];
        [[theValue(monthPickerComponents.year) should] equal:theValue(dateComponents.year)];
    });
    
    it(@"should not have a year greater than the maximum year", ^{
        // May 2013
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:1368426075];
        SRMonthPicker *monthPicker = [[SRMonthPicker alloc] init];
        [monthPicker.maximumYear shouldBeNil];
        
        monthPicker.maximumYear = @2012;
        [[theValue(monthPicker.maximumYear.intValue) should] equal:theValue(2012)];
        monthPicker.date = date;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *monthPickerComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSTimeZoneCalendarUnit) fromDate:monthPicker.date];
        NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date];
        
        [[theValue(monthPickerComponents.day) should] equal:theValue(1)];
        [[theValue(monthPickerComponents.year) shouldNot] equal:theValue(dateComponents.year)];
        [[theValue(monthPickerComponents.month) should] equal:theValue(dateComponents.month)];
        [[theValue(monthPickerComponents.year) should] equal:theValue(monthPicker.maximumYear.intValue)];
        [[monthPickerComponents.timeZone should] equal:[NSTimeZone defaultTimeZone]];
        
        // Set new maximum year, refresh the date components
        monthPicker.maximumYear = @2011;
        [[theValue(monthPickerComponents.month) should] equal:theValue(dateComponents.month)];
        monthPickerComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:monthPicker.date];
        [[theValue(monthPickerComponents.year) should] equal:theValue(monthPicker.maximumYear.intValue)];
    });
    
    it(@"should not have a year less than the minimum year", ^{
        // May 2013
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:1368426075];
        SRMonthPicker *monthPicker = [[SRMonthPicker alloc] init];
        [monthPicker.minimumYear shouldBeNil];
        
        monthPicker.minimumYear = @2014;
        [[theValue(monthPicker.minimumYear.intValue) should] equal:theValue(2014)];
        monthPicker.date = date;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *monthPickerComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSTimeZoneCalendarUnit) fromDate:monthPicker.date];
        NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date];
        
        [[theValue(monthPickerComponents.day) should] equal:theValue(1)];
        [[theValue(monthPickerComponents.year) shouldNot] equal:theValue(dateComponents.year)];
        [[theValue(monthPickerComponents.month) should] equal:theValue(dateComponents.month)];
        [[theValue(monthPickerComponents.year) should] equal:theValue(monthPicker.minimumYear.intValue)];
        [[monthPickerComponents.timeZone should] equal:[NSTimeZone defaultTimeZone]];
        
        // Set new minimum year, refresh the date components
        monthPicker.minimumYear = @2015;
        monthPickerComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:monthPicker.date];
        [[theValue(monthPickerComponents.month) should] equal:theValue(dateComponents.month)];
        [[theValue(monthPickerComponents.year) should] equal:theValue(monthPicker.minimumYear.intValue)];
    });
    
    it(@"should not have an external UIPickerViewDelegate", ^{
        // NSObject<T> used instead of id<T> due to Kiwi, & casts applied for the same reason
        
        NSObject<UIPickerViewDelegate> *mockDelegate = [KWMock mockForProtocol:@protocol(UIPickerViewDelegate)];
        SRMonthPicker *monthPicker = [[SRMonthPicker alloc] init];
        monthPicker.delegate = mockDelegate;
        [[(NSObject<UIPickerViewDelegate> *)monthPicker.delegate shouldNot] equal:mockDelegate];
        [[(NSObject<UIPickerViewDelegate> *)monthPicker.delegate should] equal:monthPicker];
    });
    
    it(@"should not have an external UIPickerViewDataSource", ^{
        // NSObject<T> used instead of id<T> due to Kiwi, & casts applied for the same reason
        
        NSObject<UIPickerViewDataSource> *mockDataSource = [KWMock mockForProtocol:@protocol(UIPickerViewDataSource)];
        SRMonthPicker *monthPicker = [[SRMonthPicker alloc] init];
        monthPicker.dataSource = mockDataSource;
        [[(NSObject<UIPickerViewDataSource> *)monthPicker.dataSource shouldNot] equal:mockDataSource];
        [[(NSObject<UIPickerViewDataSource> *)monthPicker.dataSource should] equal:monthPicker];
    });
});

SPEC_END