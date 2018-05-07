//
//  QMLocationInfo.h
//  QromaScan
//
//  Created by Bucha Kanstantsin on 5/30/16.
//  Copyright © 2016 Qroma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMLocation.h"


@interface QMLocationInfo : NSObject

// implemented in accordance with ITCP geographic fields description
// https://www.iptc.org/std/photometadata/documentation/GenericGuidelines/index.htm#!Documents/iptccoreimagesection.htm

@property (copy, nonatomic, readonly, nullable) NSString * sublocation;
@property (copy, nonatomic, readonly, nullable) NSString * city;
@property (copy, nonatomic, readonly, nullable) NSString * state;
@property (copy, nonatomic, readonly, nullable) NSString * country;
@property (copy, nonatomic, readonly, nullable) NSString * postalCode;
@property (copy, nonatomic, readonly, nullable) NSString * countryCode;
@property (strong, nonatomic, readonly, nullable) QMLocation * location;

@property (copy, nonatomic, readonly, nullable) NSString * address;

+ (instancetype _Nullable) locationInfoUsingLocation: (QMLocation * _Nullable) location;
+ (instancetype _Nullable) locationInfoUsingSublocation: (NSString * _Nullable) sublocation
                                                   city:  (NSString * _Nullable) city
                                                  state: (NSString * _Nullable) state
                                                country: (NSString * _Nullable) country
                                            countryCode: (NSString * _Nullable) countryCode
                                               location: (QMLocation * _Nullable) location;
+ (instancetype _Nullable) locationInfoUsingSublocation: (NSString * _Nullable) sublocation
                                                   city:  (NSString * _Nullable) city
                                                  state: (NSString * _Nullable) state
                                             postalCode: (NSString * _Nullable) postalCode
                                                country: (NSString * _Nullable) country
                                            countryCode: (NSString * _Nullable) countryCode
                                               location: (QMLocation * _Nullable) location;
                                    
- (BOOL) isSpecificPlaceOfLocation: (QMLocationInfo * _Nonnull ) location;

@end


