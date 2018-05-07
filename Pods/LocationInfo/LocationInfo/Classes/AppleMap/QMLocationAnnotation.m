//
//  QMLocationAnnotation.m
//  QromaScan
//
//  Created by bucha on 9/21/17.
//  Copyright © 2017 Qroma. All rights reserved.
//

#import "QMLocationAnnotation.h"
#import "QMLocationInfoAppleConvertion.h"

@implementation QMLocationAnnotation

+ (instancetype) annotationUsing: (QMLocationInfo *) info {
   
    if (info.location == nil) {
        return nil;
    }
    
    CLLocation * location = [QMLocationInfoAppleConvertion clLocationUsing: info.location];
    QMLocationAnnotation * result = [QMLocationAnnotation new];
    
    result.coordinate = location.coordinate;
    result.title = @" "; // I don't undestand why I can use only this mad option to disable default label for annotation .
    
    return result;
}

@end
