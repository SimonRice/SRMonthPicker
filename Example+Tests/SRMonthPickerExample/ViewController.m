/*
 * ----------------------------------------------------------------------------
 * "THE BOOZE-WARE LICENSE"
 * Simon Rice wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me an alcoholic beverage in return.
 *
 * Simon Rice
 * ----------------------------------------------------------------------------
 */

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet SRMonthPicker *monthPicker;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (NSString*)formatDate:(NSDate *)date
{
    // A convenience method that formats the date in Month-Year format
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM y";
    return [formatter stringFromDate:date];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // I will be using the delegate here
    self.monthPicker.monthPickerDelegate = self;
    
    // Set the label to show the date
    self.label.text = [NSString stringWithFormat:@"Selected: %@", [self formatDate:self.monthPicker.date]];
    
    // Some options to play around with
    self.monthPicker.maximumYear = @2020;
    self.monthPicker.minimumYear = @1900;
    self.monthPicker.yearFirst = YES;
}

- (void)monthPickerWillChangeDate:(SRMonthPicker *)monthPicker
{
    // Show the date is changing (with a 1 second wait mimicked)
    self.label.text = [NSString stringWithFormat:@"Was: %@", [self formatDate:monthPicker.date]];
}

- (void)monthPickerDidChangeDate:(SRMonthPicker *)monthPicker
{
    // All this GCD stuff is here so that the label change on -[self monthPickerWillChangeDate] will be visible
    dispatch_queue_t delayQueue = dispatch_queue_create("com.simonrice.SRMonthPickerExample.DelayQueue", 0);

    dispatch_async(delayQueue, ^{
        // Wait 1 second
        sleep(1);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = [NSString stringWithFormat:@"Selected: %@", [self formatDate:self.monthPicker.date]];
        });
    });
    
}

- (IBAction)setToOct2009:(UIButton *)sender {
    NSDateComponents* dateParts = [[NSDateComponents alloc] init];
    
    dateParts.month = 10;
    dateParts.year = 2009;
    
    self.monthPicker.date = [[NSCalendar currentCalendar] dateFromComponents:dateParts];
    self.label.text = [NSString stringWithFormat:@"Selected: %@", [self formatDate:self.monthPicker.date]];
}

- (IBAction)setToThisMonth:(UIButton *)sender {
    self.monthPicker.date = [NSDate date];
    self.label.text = [NSString stringWithFormat:@"Selected: %@", [self formatDate:self.monthPicker.date]];
}

@end
