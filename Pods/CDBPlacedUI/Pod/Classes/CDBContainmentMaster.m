

#import "CDBContainmentMaster.h"
#import "CDBPlaceholderMaster.h"


@implementation CDBContainmentMaster

+ (void)displayChildViewController:(UIViewController *)childController
                       withOptions:(CDBPlacedUIOptions)presentationOptions
                            inView:(UIView *)placeholderView
                  ofViewController:(UIViewController *)containerViewController {
    [childController willMoveToParentViewController:containerViewController];
    
    [containerViewController addChildViewController:childController];
    [CDBPlaceholderMaster placeUI:childController.view
                      inPlaceholder:placeholderView
                       usingOptions:presentationOptions];
    [childController didMoveToParentViewController:containerViewController];
}

+ (void)hideChildViewController:(UIViewController *)childController {
    [childController willMoveToParentViewController:nil];
    
    [childController removeFromParentViewController];
    [childController.view removeFromSuperview];
    
    [childController didMoveToParentViewController:nil];
}

@end
