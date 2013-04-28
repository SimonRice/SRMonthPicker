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

#import <UIKit/UIKit.h>

@class SRMonthPicker;

/**
  Defines a set of optional methods you can use to receive change-related 
  messages for SRMonthPicker objects.  All of the methods in this protocol are 
  optional.  Typically, the delegate implements other optional methods to 
  respond to new selections. 
 */
@protocol SRMonthPickerDelegate <NSObject>

@optional

/**
  Tells the delegate that a specified date is about to be selected.
  @param monthPicker A month picker object informing the delegate about the 
  impending selection.
*/
- (void)monthPickerWillChangeDate:(SRMonthPicker *)monthPicker;
/**
  Tells the delegate that a specified date has been selected.
  @param monthPicker A month picker object informing the delegate about the 
  committed selection.
*/
- (void)monthPickerDidChangeDate:(SRMonthPicker *)monthPicker;

@end

/**
  The SRMonthPicker class implements an object that uses multiple rotating 
  wheels to allow users to select a month and year.  This is similar to both 
  iOS's UIDatePicker set to Date-only mode without the day element and Mobile
  Safari's picker view that appears for an `<input type="month" />` tag.

  Unlike UIDatePicker, SRMonthPicker does inherit from UIPickerView.  It does 
  use both UIPickerViewDataSource and UIPickerViewDelegate, but presents a 
  monthPickerDelegate property.
*/
@interface SRMonthPicker : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>

/**
  The designated delegate for the month picker.
  @warning The delegate property is already used internally for 
  UIPickerView's delegate - **please don't read from or assign to it**!
  */
@property (nonatomic, weak) id<SRMonthPickerDelegate> monthPickerDelegate;

/**
  The date represented by the month picker.
  
  The day component is ignored when written, and set to 1 when read.
  */
@property (nonatomic, strong) NSDate* date;
  
/// The minimum year that a month picker can show.
@property (nonatomic, strong) NSNumber* minimumYear;

/// The maximum year that a month picker can show.
@property (nonatomic, strong) NSNumber* maximumYear;

/// A Boolean value that determines whether the year is shown first.
@property (nonatomic) BOOL yearFirst;

/**
  A Boolean value that determines whether the current month & year are coloured.
  */
@property (nonatomic) BOOL enableColourRow;

/**
  Designated initialiser.

  Initializes and returns a newly allocated month picker with the current month 
  & year.
*/
-(id)init;
/**
  Initializes and returns a newly allocated month picker with the specified 
  date.
  @param date The date to be represented by the month picker -  the day 
  component will be ignored.
*/
-(id)initWithDate:(NSDate *)date;

@end
