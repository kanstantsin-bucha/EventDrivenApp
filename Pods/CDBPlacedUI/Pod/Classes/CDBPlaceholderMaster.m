

#import "CDBPlaceholderMaster.h"
#import "CDBConstraintsMaster.h"


@implementation CDBPlaceholderMaster

+ (void)placeUI:(UIView *)view
  inPlaceholder:(UIView *)placeholderView
   usingOptions:(CDBPlacedUIOptions)options {
    [placeholderView addSubview:view];
    if (options & CDBPlacedUIOptionsCentered) {
        [CDBConstraintsMaster addContraintsThatCenterView:view
                                            inContainerView:placeholderView];
    }
    if (options & CDBPlacedUIOptionsEqualSize) {
        [CDBConstraintsMaster addContraintsThatKeepSizeOfView:view
                                           equalToContainerView:placeholderView];
    }
    if (options & CDBPlacedUIOptionsConstantSize) {
        [CDBConstraintsMaster addContraintsThatKeepConstantSizeOfView:view
                                                        inContainerView:placeholderView];
    }
}

@end
