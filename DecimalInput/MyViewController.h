#import <UIKit/UIKit.h>


@interface MyViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField* textField;

- (IBAction)pushOk:(id)sender;

@end
