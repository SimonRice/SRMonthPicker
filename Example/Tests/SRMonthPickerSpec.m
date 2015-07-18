//
//  SRMonthPickerTests.m
//  SRMonthPickerTests
//
//  Created by Simon Rice on 06/14/2015.
//  Copyright (c) 2015 Simon Rice. All rights reserved.
//

// https://github.com/kiwi-bdd/Kiwi

#import "SRMonthPicker.h"

SPEC_BEGIN(SRMonthPickerSpec)

describe(@"SRMonthPicker", ^{
    it(@"should initialise to the current month via the designated initialiser", ^{
        SRMonthPicker *monthPicker = [[SRMonthPicker alloc] init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *monthPickerComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone) fromDate:monthPicker.date];
        NSDateComponents *todayComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
        
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
        NSDateComponents *monthPickerComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone) fromDate:monthPicker.date];
        NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
        
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
        NSDateComponents *monthPickerComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone) fromDate:monthPicker.date];
        NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
        
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
        [[theValue(monthPicker.maximumYear) should] equal:theValue(99999)];
        
        monthPicker.maximumYear = 2012;
        [[theValue(monthPicker.maximumYear) should] equal:theValue(2012)];
        monthPicker.date = date;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *monthPickerComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone) fromDate:monthPicker.date];
        NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:date];
        
        [[theValue(monthPickerComponents.day) should] equal:theValue(1)];
        [[theValue(monthPickerComponents.year) shouldNot] equal:theValue(dateComponents.year)];
        [[theValue(monthPickerComponents.month) should] equal:theValue(dateComponents.month)];
        [[theValue(monthPickerComponents.year) should] equal:theValue(monthPicker.maximumYear)];
        [[monthPickerComponents.timeZone should] equal:[NSTimeZone defaultTimeZone]];
        
        // Set new maximum year, refresh the date components
        monthPicker.maximumYear = 2011;
        [[theValue(monthPickerComponents.month) should] equal:theValue(dateComponents.month)];
        monthPickerComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:monthPicker.date];
        [[theValue(monthPickerComponents.year) should] equal:theValue(monthPicker.maximumYear)];
    });
    
    it(@"should not have a year less than the minimum year", ^{
        // May 2013
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:1368426075];
        SRMonthPicker *monthPicker = [[SRMonthPicker alloc] init];
        [[theValue(monthPicker.minimumYear) should] equal:theValue(1)];
        
        monthPicker.minimumYear = 2014;
        [[theValue(monthPicker.minimumYear) should] equal:theValue(2014)];
        monthPicker.date = date;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *monthPickerComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone) fromDate:monthPicker.date];
        NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:date];
        
        [[theValue(monthPickerComponents.day) should] equal:theValue(1)];
        [[theValue(monthPickerComponents.year) shouldNot] equal:theValue(dateComponents.year)];
        [[theValue(monthPickerComponents.month) should] equal:theValue(dateComponents.month)];
        [[theValue(monthPickerComponents.year) should] equal:theValue(monthPicker.minimumYear)];
        [[monthPickerComponents.timeZone should] equal:[NSTimeZone defaultTimeZone]];
        
        // Set new minimum year, refresh the date components
        monthPicker.minimumYear = 2015;
        monthPickerComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:monthPicker.date];
        [[theValue(monthPickerComponents.month) should] equal:theValue(dateComponents.month)];
        [[theValue(monthPickerComponents.year) should] equal:theValue(monthPicker.minimumYear)];
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
