#import <UIKit/UIKit.h>


@interface IHViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField* textField;

- (IBAction)pushOk:(id)sender;

@end
