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

#import "SRMonthPicker.h"

@interface SRMonthPicker()

@property (nonatomic) int monthComponent;
@property (nonatomic) int yearComponent;
@property (nonatomic, readonly) NSArray* monthStrings;

-(int)yearFromRow:(NSUInteger)row;
-(NSUInteger)rowFromYear:(int)year;

@end

@implementation SRMonthPicker

static const int SRMonthRowMultiplier = 340;
static const int SRDefaultMinimumYear = 1;
static const int SRDefaultMaximumYear = 99999;
static const NSCalendarUnit SRDateComponentFlags = NSMonthCalendarUnit | NSYearCalendarUnit;

-(id)initWithDate:(NSDate *)date
{
    self = [super init];
    
    if (self)
    {
        [self prepare];
        [self setDate:date];
        self.showsSelectionIndicator = YES;
    }
    
    return self;
}

-(id)init
{
    self = [self initWithDate:[NSDate date]];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self prepare];
        if (!_date)
            [self setDate:[NSDate date]];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self prepare];
        if (!_date)
            [self setDate:[NSDate date]];
    }
    
    return self;
}

-(void)prepare
{
    self.dataSource = self;
    self.delegate = self;
    
    _enableColourRow = YES;
    _wrapMonths = YES;
}

-(id<UIPickerViewDelegate>)delegate
{
    return self;
}

-(void)setDelegate:(id<UIPickerViewDelegate>)delegate
{
    if ([delegate isEqual:self])
        [super setDelegate:delegate];
}

-(id<UIPickerViewDataSource>)dataSource
{
    return self;
}

-(void)setDataSource:(id<UIPickerViewDataSource>)dataSource
{
    if ([dataSource isEqual:self])
        [super setDataSource:dataSource];
}

-(int)monthComponent
{
    return self.yearComponent ^ 1;
}

-(int)yearComponent
{
    return !self.yearFirst;
}

-(NSArray *)monthStrings
{
    return [[NSDateFormatter alloc] init].monthSymbols;
}

-(void)setYearFirst:(BOOL)yearFirst
{
    _yearFirst = yearFirst;
    NSDate* date = self.date;
    [self reloadAllComponents];
    [self setNeedsLayout];
    [self setDate:date];
}

-(void)setMinimumYear:(NSNumber *)minimumYear
{
    NSDate* currentDate = self.date;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:SRDateComponentFlags fromDate:currentDate];
    components.timeZone = [NSTimeZone defaultTimeZone];
    
    if (minimumYear && components.year < minimumYear.integerValue)
        components.year = minimumYear.integerValue;
    
    _minimumYear = minimumYear;
    [self reloadAllComponents];
    [self setDate:[[NSCalendar currentCalendar] dateFromComponents:components]];
}

-(void)setMaximumYear:(NSNumber *)maximumYear
{
    NSDate* currentDate = self.date;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:SRDateComponentFlags fromDate:currentDate];
    components.timeZone = [NSTimeZone defaultTimeZone];
    
    if (maximumYear && components.year > maximumYear.integerValue)
        components.year = maximumYear.integerValue;
    
    _maximumYear = maximumYear;
    [self reloadAllComponents];
    [self setDate:[[NSCalendar currentCalendar] dateFromComponents:components]];
}

-(void)setWrapMonths:(BOOL)wrapMonths
{
    _wrapMonths = wrapMonths;
    [self reloadAllComponents];
}

-(int)yearFromRow:(NSUInteger)row
{
    int minYear = SRDefaultMinimumYear;
    
    if (self.minimumYear)
        minYear = self.minimumYear.integerValue;
    
    return row + minYear;
}

-(NSUInteger)rowFromYear:(int)year
{
    int minYear = SRDefaultMinimumYear;
    
    if (self.minimumYear)
        minYear = self.minimumYear.integerValue;
    
    return year - minYear;
}

-(void)setDate:(NSDate *)date
{
    NSDateComponents* components = [[NSCalendar currentCalendar] components:SRDateComponentFlags fromDate:date];
    components.timeZone = [NSTimeZone defaultTimeZone];
    
    if (self.minimumYear && components.year < self.minimumYear.integerValue)
        components.year = self.minimumYear.integerValue;
    else if (self.maximumYear && components.year > self.maximumYear.integerValue)
        components.year = self.maximumYear.integerValue;
    
    if(self.wrapMonths){
        int monthMidpoint = self.monthStrings.count * (SRMonthRowMultiplier / 2);
        
        [self selectRow:(components.month - 1 + monthMidpoint) inComponent:self.monthComponent animated:NO];
    }
    else {
        [self selectRow:(components.month - 1) inComponent:self.monthComponent animated:NO];
    }
    [self selectRow:[self rowFromYear:components.year] inComponent:self.yearComponent animated:NO];
    
    _date = [[NSCalendar currentCalendar] dateFromComponents:components];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.month = 1 + ([self selectedRowInComponent:self.monthComponent] % self.monthStrings.count);
    components.year = [self yearFromRow:[self selectedRowInComponent:self.yearComponent]];
    
    [self willChangeValueForKey:@"date"];
    if ([self.monthPickerDelegate respondsToSelector:@selector(monthPickerWillChangeDate:)])
        [self.monthPickerDelegate monthPickerWillChangeDate:self];
    
    _date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    if ([self.monthPickerDelegate respondsToSelector:@selector(monthPickerDidChangeDate:)])
        [self.monthPickerDelegate monthPickerDidChangeDate:self];
    [self didChangeValueForKey:@"date"];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == self.monthComponent && !self.wrapMonths)
        return self.monthStrings.count;
    else if(component == self.monthComponent)
        return SRMonthRowMultiplier * self.monthStrings.count;
    
    int maxYear = SRDefaultMaximumYear;
    if (self.maximumYear)
        maxYear = self.maximumYear.integerValue;
    
    return [self rowFromYear:maxYear] + 1;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == self.monthComponent)
        return 150.0f;
    else
        return 76.0f;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGFloat width = [self pickerView:self widthForComponent:component];
    CGRect frame = CGRectMake(0.0f, 0.0f, width, 45.0f);
    
    if (component == self.monthComponent)
    {
        const CGFloat padding = 9.0f;
        if (component) {
            frame.origin.x += padding;
            frame.size.width -= padding;
        }
        
        frame.size.width -= padding;
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    if (component == self.monthComponent) {
        label.text = [self.monthStrings objectAtIndex:(row % self.monthStrings.count)];
        formatter.dateFormat = @"MMMM";
        label.textAlignment = component ? NSTextAlignmentLeft : NSTextAlignmentRight;
    } else {
        label.text = [NSString stringWithFormat:@"%d", [self yearFromRow:row]];
        label.textAlignment = NSTextAlignmentCenter;
        formatter.dateFormat = @"y";
    }
    
    if (_enableColourRow && [[formatter stringFromDate:[NSDate date]] isEqualToString:label.text])
        label.textColor = [UIColor colorWithRed:0.0f green:0.35f blue:0.91f alpha:1.0f];
    
    label.font = [UIFont boldSystemFontOfSize:24.0f];
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0.0f, 0.1f);
    label.shadowColor = [UIColor whiteColor];
    
    return label;
}

@end
