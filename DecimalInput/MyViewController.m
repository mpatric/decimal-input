#import "MyViewController.h"

#define MAX_LENGTH 8


@interface MyViewController()

@property (assign, nonatomic) int maximumFractionDigits;
@property (strong, nonatomic) NSString* decimalSeparator;

@end


@implementation MyViewController

@synthesize textField = _textField, maximumFractionDigits = _maximumFractionDigits, decimalSeparator = _decimalSeparator;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setCurrencyCode:@"GBP"];
        self.maximumFractionDigits = numberFormatter.maximumFractionDigits;
        self.decimalSeparator = numberFormatter.decimalSeparator;
        [numberFormatter release];
    }
    return self;
}

- (IBAction)pushOk:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"The value is: %@", self.textField.text]
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - view lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated {
    // Default value
    self.textField.text = [NSString stringWithFormat:@"0%@00", self.decimalSeparator];
    // Pop up keyboard
    [self.textField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    // get current cursor position
    UITextRange* selectedRange = [textField selectedTextRange];
    UITextPosition* start = textField.beginningOfDocument;
    NSInteger cursorOffset = [textField offsetFromPosition:start toPosition:selectedRange.start];
    // Update the string in the text input
    NSMutableString* currentString = [NSMutableString stringWithString:textField.text];
    NSUInteger currentLength = currentString.length;
    [currentString replaceCharactersInRange:range withString:string];
    // Strip out the decimal separator
    [currentString replaceOccurrencesOfString:self.decimalSeparator withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [currentString length])];
    // Generate a new string for the text input
    int currentValue = [currentString intValue];
    NSString* format = [NSString stringWithFormat:@"%%.%df", self.maximumFractionDigits];
    double minorUnitsPerMajor = pow(10, self.maximumFractionDigits);
    NSString* newString = [[NSString stringWithFormat:format, currentValue / minorUnitsPerMajor] stringByReplacingOccurrencesOfString:@"." withString:self.decimalSeparator];
    if (newString.length <= MAX_LENGTH) {
        textField.text = newString;
        // if the cursor was not at the end of the string being entered, restore cursor position
        if (cursorOffset != currentLength) {
            int lengthDelta = newString.length - currentLength;
            int newCursorOffset = MAX(0, MIN(newString.length, cursorOffset + lengthDelta));
            UITextPosition* newPosition = [textField positionFromPosition:textField.beginningOfDocument offset:newCursorOffset];
            UITextRange* newRange = [textField textRangeFromPosition:newPosition toPosition:newPosition];
            [textField setSelectedTextRange:newRange];
        }
    }
    return NO;
}

@end
