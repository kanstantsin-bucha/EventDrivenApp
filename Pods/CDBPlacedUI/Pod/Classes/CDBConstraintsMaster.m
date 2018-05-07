

#import "CDBConstraintsMaster.h"


@implementation CDBConstraintsMaster

#pragma mark - Class -

+ (void)addContraintsThatCenterView:(UIView *)viewToCenter
                    inContainerView:(UIView *)containerView {
    [viewToCenter setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:viewToCenter
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:containerView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:viewToCenter
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:containerView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0];
    
    [containerView addConstraint:centerX];
    [containerView addConstraint:centerY];
}

+ (void)addContraintsThatKeepSizeOfView:(UIView *)viewToKeepSize
                   equalToContainerView:(UIView *)containerView {
    [viewToKeepSize setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *equalWidth = [NSLayoutConstraint constraintWithItem:viewToKeepSize
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:containerView
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1
                                                                   constant:0];
    NSLayoutConstraint *equalHeight = [NSLayoutConstraint constraintWithItem:viewToKeepSize
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:containerView
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:1
                                                                    constant:0];
    
    [containerView addConstraint:equalWidth];
    [containerView addConstraint:equalHeight];
}

+ (void)addContraintsThatKeepConstantSizeOfView:(UIView *)viewToKeepSize
                                inContainerView:(UIView *)containerView {
    [viewToKeepSize setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    CGSize constantSize = viewToKeepSize.bounds.size;
    
    NSLayoutConstraint *equalWidth = [NSLayoutConstraint constraintWithItem:viewToKeepSize
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:constantSize.width];
    NSLayoutConstraint *equalHeight = [NSLayoutConstraint constraintWithItem:viewToKeepSize
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1
                                                                    constant:constantSize.height];
    
    [containerView addConstraint:equalWidth];
    [containerView addConstraint:equalHeight];
}

@end
