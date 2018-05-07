//
//  QMLocationInfoLuongConvertion.m
//  QromaScan
//
//  Created by bucha on 9/6/17.
//  Copyright © 2017 Qroma. All rights reserved.
//

#import "QMLocationInfoStringConversion.h"

#define QMLocationInfoStringDelimiter @","

@implementation QMLocationInfoStringConversion

//MARK: - interface -

+ (QMLocationInfo * _Nullable) locationInfoUsingString: (NSString * _Nullable) string {
    
    if ( string == nil ) {
        
        return nil;
    }
    
    NSArray * strings = [string componentsSeparatedByString: QMLocationInfoStringDelimiter];
    
    if (strings.count < 2) {
        
        return nil;
    }
    
    NSString * latitude = [(NSString *)strings[0] length] != 0 ? strings[0] : nil;
    NSString * longitude = [(NSString *)strings[1] length] != 0 ? strings[1] : nil;
    
    double latitudeValue = latitude.doubleValue;
    double longitudeValue = longitude.doubleValue;
    
    QMLocation * location = [QMLocation locationUsingLatitude: latitudeValue
                                                    longitude: longitudeValue
                                                    timestamp: nil];
    NSString * sublocation = nil;
    NSString * city = nil;
    NSString * state = nil;
    NSString * country = nil;
    NSString * postalCode = nil;
    NSString * countryCode = nil;
    
    if (strings.count == 5) {
        city = [(NSString *)strings[2] length] != 0 ? strings[2] : nil;
        state = [(NSString *)strings[3] length] != 0 ? strings[3] : nil;
        country = [(NSString *)strings[4] length] != 0 ? strings[4] : nil;
    }
    
    if (strings.count == 8) {
        sublocation = [(NSString *)strings[2] length] != 0 ? strings[2] : nil;
        city = [(NSString *)strings[3] length] != 0 ? strings[3] : nil;
        state = [(NSString *)strings[4] length] != 0 ? strings[4] : nil;
        postalCode = [(NSString *)strings[5] length] != 0 ? strings[5] : nil;
        country = [(NSString *)strings[6] length] != 0 ? strings[6] : nil;
        countryCode = [(NSString *)strings[7] length] != 0 ? strings[7] : nil;
    }
    
    QMLocationInfo * result = [QMLocationInfo locationInfoUsingSublocation: sublocation
                                                                      city: city
                                                                     state: state
                                                                postalCode: postalCode
                                                                   country: country
                                                               countryCode: countryCode
                                                                  location: location];
    
    return result;
}

+ (NSString * _Nonnull) srtingRepresentationUsingLocationInfo: (QMLocationInfo * _Nonnull) info {
    
    NSArray * strings = @[
                           info.location.latitude != 0 ? [NSString stringWithFormat: @"%f", info.location.latitude] : @"",
                           info.location.longitude != 0 ? [NSString stringWithFormat: @"%f", info.location.longitude] : @"",
                           info.sublocation != nil ? info.sublocation : @"",
                           info.city != nil ? info.city : @"",
                           info.state != nil ? info.state : @"",
                           info.postalCode != nil ? info.postalCode : @"",
                           info.country != nil ? info.country : @"",
                           info.countryCode != nil ? info.countryCode : @"",
                        ];
    
    NSString * result = [strings componentsJoinedByString: QMLocationInfoStringDelimiter];
    return result;
}

@end
