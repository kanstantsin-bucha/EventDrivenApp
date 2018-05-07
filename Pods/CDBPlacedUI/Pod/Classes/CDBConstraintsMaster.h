

#import <UIKit/UIKit.h>


@interface CDBConstraintsMaster : NSObject

+ (void)addContraintsThatCenterView:(UIView *)viewToCenter
                    inContainerView:(UIView *)containerView;
+ (void)addContraintsThatKeepSizeOfView:(UIView *)viewToKeepSize
                   equalToContainerView:(UIView *)containerView;
+ (void)addContraintsThatKeepConstantSizeOfView:(UIView *)viewToKeepSize
                                inContainerView:(UIView *)containerView;

@end
