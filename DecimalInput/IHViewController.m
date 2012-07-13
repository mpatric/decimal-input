#import "IHViewController.h"

#define MAX_LENGTH 8


@interface IHViewController()

@property (assign, nonatomic) int maximumFractionDigits;

@end


@implementation IHViewController

@synthesize textField = _textField, maximumFractionDigits = _maximumFractionDigits;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setCurrencyCode:@"GBP"];
        self.maximumFractionDigits = numberFormatter.maximumFractionDigits;
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
    self.textField.text = @"0.00";
    // Pop up keyboard
    [self.textField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    // Update the string in the text input
    NSMutableString* currentString = [NSMutableString stringWithString:textField.text];
    [currentString replaceCharactersInRange:range withString:string];
    // Strip out the period
    [currentString replaceOccurrencesOfString:@"." withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [currentString length])];
    // Generate a new string for the text input
    double currentValue = [currentString intValue];
    NSString* formatString = [NSString stringWithFormat:@"%%.%df", self.maximumFractionDigits];
    double minorUnitsPerMajor = pow(10, self.maximumFractionDigits);
    NSString* newString = [NSString stringWithFormat:formatString, currentValue / minorUnitsPerMajor];
    if (newString.length <= MAX_LENGTH) {
        textField.text = newString;
    }
    return NO;
}

@end
