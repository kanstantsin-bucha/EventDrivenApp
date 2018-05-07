//
//  QMLocation.m
//  QromaScan
//
//  Created by Bucha Kanstantsin on 5/30/16.
//  Copyright © 2016 Qroma. All rights reserved.
//

#import "QMLocation.h"

@implementation QMLocation

#pragma mark - property -

- (NSDate *)timestamp {
    if (_timestamp != nil) {
        return _timestamp;
    }
    
    _timestamp = [NSDate date];
    return _timestamp;
}

#pragma mark - life cycle -

+ (instancetype _Nonnull) locationUsingLatitude: (double) latitude
                                      longitude: (double) longitude
                                      timestamp: (NSDate * _Nullable) timestamp {
    if (latitude == 0
        && longitude == 0) {
        return nil;
    }
    
    QMLocation * result = [[self class] new];
    result.latitude = latitude;
    result.longitude = longitude;
    result.timestamp = timestamp;
    
    return result;
}

#pragma mark - description -

- (NSString *)description {
    NSString * result = [NSString stringWithFormat:@"%f %f , timestamp: %@",
                         self.latitude, self.longitude, self.timestamp];
    return result;
}

@end
