

#import <UIKit/UIKit.h>
#import "CDBPlacedUI.h"


@interface CDBContainmentMaster : NSObject

+ (void)displayChildViewController:(UIViewController *)childController
                       withOptions:(CDBPlacedUIOptions)presentationOptions
                            inView:(UIView *)placeholderView
                  ofViewController:(UIViewController *)containerViewController;

+ (void)hideChildViewController:(UIViewController *)childController;

@end
