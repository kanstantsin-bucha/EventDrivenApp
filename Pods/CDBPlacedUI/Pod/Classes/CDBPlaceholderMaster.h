

#import <UIKit/UIKit.h>
#import "CDBPlacedUI.h"


@interface CDBPlaceholderMaster : NSObject

+ (void)placeUI:(UIView *)view
  inPlaceholder:(UIView *)placeholderView
   usingOptions:(CDBPlacedUIOptions)options;

@end
