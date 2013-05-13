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