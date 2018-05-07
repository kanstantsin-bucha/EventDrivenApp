//
//  QMLocationInfoLuongConvertion.h
//  QromaScan
//
//  Created by bucha on 9/6/17.
//  Copyright © 2017 Qroma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LMGeocoderUniversal/LMGeocoderUniversal.h>
#import "QMLocationInfo.h"


@interface QMLocationInfoLuongConvertion : NSObject

+ (QMLocationInfo * _Nullable) locationInfoUsingAddress: (LMAddress * _Nonnull) address;

@end
