//
//  QMLocationInfoLuongConvertion.h
//  QromaScan
//
//  Created by bucha on 9/6/17.
//  Copyright © 2017 Qroma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMLocationInfo.h"


@interface QMLocationInfoStringConversion : NSObject

+ (QMLocationInfo * _Nullable) locationInfoUsingString: (NSString * _Nullable) string;
+ (NSString * _Nonnull) srtingRepresentationUsingLocationInfo: (QMLocationInfo * _Nonnull) info;

@end
