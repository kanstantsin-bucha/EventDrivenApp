//
//  QMLocationInfo.m
//  QromaScan
//
//  Created by Bucha Kanstantsin on 5/30/16.
//  Copyright © 2016 Qroma. All rights reserved.
//

#import "QMLocationInfo.h"


@interface QMLocationInfo ()

@property (copy, nonatomic, readwrite) NSString * sublocation;
@property (copy, nonatomic, readwrite) NSString * city;
@property (copy, nonatomic, readwrite) NSString * state;
@property (copy, nonatomic, readwrite) NSString * country;
@property (copy, nonatomic, readwrite) NSString * postalCode;
@property (copy, nonatomic, readwrite) NSString * countryCode;
@property (strong, nonatomic, readwrite) QMLocation * location;

@end


@implementation QMLocationInfo

#pragma mark - property -

- (NSString *)address {
    
    NSString * result = [self addressUsingSublocation: self.sublocation
                                                 city: self.city
                                                state: self.state
                                           postalCode: self.postalCode
                                              country: self.country];
    if (result.length == 0
        && self.location != nil) {
        result = [NSString stringWithFormat:@"%f, %f",
                  self.location.latitude, self.location.longitude];
    }
    
    if (result.length == 0) {
        return nil;
    }
    
    return result;
}



#pragma mark - life cycle -

+ (instancetype _Nullable) locationInfoUsingLocation: (QMLocation * _Nullable) location {
    if (location == nil) {
        return nil;
    }
    
    QMLocationInfo * result = [[self class] new];
    result.location = location;
    return result;
}

+ (instancetype _Nullable) locationInfoUsingSublocation: (NSString * _Nullable) sublocation
                                                   city:  (NSString * _Nullable) city
                                                  state: (NSString * _Nullable) state
                                                country: (NSString * _Nullable) country
                                            countryCode: (NSString * _Nullable) countryCode
                                               location: (QMLocation * _Nullable) location {
    
    QMLocationInfo * result = [self locationInfoUsingSublocation: sublocation
                                                            city: city
                                                           state: state
                                                      postalCode: nil
                                                         country: country
                                                     countryCode: countryCode
                                                        location: location];
    return result;
}

+ (instancetype _Nullable) locationInfoUsingSublocation: (NSString * _Nullable) sublocation
                                                   city:  (NSString * _Nullable) city
                                                  state: (NSString * _Nullable) state
                                             postalCode: (NSString * _Nullable) postalCode
                                                country: (NSString * _Nullable) country
                                            countryCode: (NSString * _Nullable) countryCode
                                               location: (QMLocation * _Nullable) location {
    
    QMLocationInfo * result = [self locationInfoUsingLocation: location];
    
    if (result == nil) {
        BOOL emptyAddress = sublocation.length == 0
                            && city.length == 0
                            && state.length == 0
                            && country.length == 0;
        if (emptyAddress) {
            return nil;
        } else {
            result = [[self class] new];
        }
    }
    
    if (sublocation.length > 0) {
        result.sublocation = sublocation;
    }
    
    if (city.length > 0) {
        result.city = city;
    }
    
    if (state.length > 0) {
        result.state = state;
    }
    
    if (postalCode.length > 0) {
        
        result.postalCode = postalCode;
    }
    
    if (country.length > 0) {
        result.country = country;
    }
    
    if (countryCode.length > 0) {
        result.countryCode = countryCode;
    }
    
    return result;
}

- (BOOL) isSpecificPlaceOfLocation: (QMLocationInfo * _Nonnull ) location {
    BOOL result = YES;
    if (location.country.length > 0) {
        result = [location.country isEqualToString: self.country];
    }
    
    if (location.state.length > 0) {
        result = [location.country isEqualToString: self.country];
    }

    if (location.city.length > 0) {
        result = [location.state isEqualToString: self.state];
    }
    
    if (location.sublocation.length > 0) {
        result = [location.sublocation isEqualToString: self.sublocation];
    }
    
    return result;
}

#pragma mark - private -



- (NSString *)addressUsingSublocation: (NSString *) sublocation
                                 city: (NSString *) city
                                state: (NSString *) state
                           postalCode: (NSString *) postalCode
                              country: (NSString *) country {
    
    NSMutableArray * components = [NSMutableArray array];
    
    if (sublocation != nil) {
        [components addObject:sublocation];
    }
    
    if (city != nil) {
        [components addObject:city];
    }
    
    if (state != nil) {
        [components addObject:state];
    }
    
    if (postalCode != nil) {
        [components addObject: postalCode];
    }
    
    if (country != nil) {
        [components addObject:country];
    }
    
    NSMutableString * result = [NSMutableString string];
    
    [components enumerateObjectsUsingBlock:^(NSString * _Nonnull component, NSUInteger idx, BOOL * _Nonnull stop) {
        if (component.length == 0) {
            return;
        }
        
        [result appendString:component];
        if (idx < components.count - 1) {
            [result appendString:@", "];
        }
    }];
    
    if (result.length == 0) {
        return nil;
    }
    
    return [result copy];
}

#pragma mark - description -

- (NSString *)description {
    NSString * result = [NSString stringWithFormat:@"address: %@ \r location: %@",
                         self.address, self.location];
    return result;
}

@end
