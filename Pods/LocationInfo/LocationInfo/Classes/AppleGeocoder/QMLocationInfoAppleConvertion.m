//
//  QMLocationInfoAppleConvertion.m
//  QromaScan
//
//  Created by bucha on 9/6/17.
//  Copyright © 2017 Qroma. All rights reserved.
//

#import "QMLocationInfoAppleConvertion.h"


@interface QMLocationInfoAppleConvertion ()

@property (strong, nonatomic, class, readonly) NSDictionary * statesByShortcut;

@end


@implementation QMLocationInfoAppleConvertion

//MARK: - property -

+ (NSDictionary *)statesByShortcut {
    NSDictionary * result = @{
          @"AL": @"Alabama",
          @"AK": @"Alaska",
          @"AS": @"American Samoa",
          @"AZ": @"Arizona",
          @"AR": @"Arkansas",
          @"CA": @"California",
          @"CO": @"Colorado",
          @"CT": @"Connecticut",
          @"DE": @"Delaware",
          @"DC": @"District Of Columbia",
          @"FM": @"Federated States Of Micronesia",
          @"FL": @"Florida",
          @"GA": @"Georgia",
          @"GU": @"Guam",
          @"HI": @"Hawaii",
          @"ID": @"Idaho",
          @"IL": @"Illinois",
          @"IN": @"Indiana",
          @"IA": @"Iowa",
          @"KS": @"Kansas",
          @"KY": @"Kentucky",
          @"LA": @"Louisiana",
          @"ME": @"Maine",
          @"MH": @"Marshall Islands",
          @"MD": @"Maryland",
          @"MA": @"Massachusetts",
          @"MI": @"Michigan",
          @"MN": @"Minnesota",
          @"MS": @"Mississippi",
          @"MO": @"Missouri",
          @"MT": @"Montana",
          @"NE": @"Nebraska",
          @"NV": @"Nevada",
          @"NH": @"New Hampshire",
          @"NJ": @"New Jersey",
          @"NM": @"New Mexico",
          @"NY": @"New York",
          @"NC": @"North Carolina",
          @"ND": @"North Dakota",
          @"MP": @"Northern Mariana Islands",
          @"OH": @"Ohio",
          @"OK": @"Oklahoma",
          @"OR": @"Oregon",
          @"PW": @"Palau",
          @"PA": @"Pennsylvania",
          @"PR": @"Puerto Rico",
          @"RI": @"Rhode Island",
          @"SC": @"South Carolina",
          @"SD": @"South Dakota",
          @"TN": @"Tennessee",
          @"TX": @"Texas",
          @"UT": @"Utah",
          @"VT": @"Vermont",
          @"VI": @"Virgin Islands",
          @"VA": @"Virginia",
          @"WA": @"Washington",
          @"WV": @"West Virginia",
          @"WI": @"Wisconsin",
          @"WY": @"Wyoming",
    };
    return result;
}

//MARK: - interface -

+ (CLLocation *) clLocationUsing: (QMLocation *) location {
    if (location == nil) {
        return nil;
    }
    CLLocation * result = [[CLLocation alloc] initWithLatitude: location.latitude
                                                     longitude: location.longitude];
    
    return result;
}

+ (QMLocationInfo *) locationInfoUsingPlacemark: (CLPlacemark *) placemark {
    
    if (placemark == nil
        || !placemark.location) {
        
        return nil;
    }
    
    CLLocationCoordinate2D coordinate = placemark.location.coordinate;
    QMLocation * location = [QMLocation locationUsingLatitude: coordinate.latitude
                                                    longitude: coordinate.longitude
                                                    timestamp: placemark.location.timestamp];
    
    NSString * sublocation = [self sublocationUsingPlacemark: placemark];
    NSString * city = placemark.locality;
    NSString * state = [self stateUsingStateString: placemark.administrativeArea];
   
    QMLocationInfo * result = [QMLocationInfo locationInfoUsingSublocation: sublocation
                                                                      city: city
                                                                     state: state
                                                                postalCode: placemark.postalCode
                                                                   country: placemark.country
                                                               countryCode: placemark.ISOcountryCode
                                                                  location: location];
    return result;
}

//MARK: - logic -

+ (NSString *)stateUsingStateString: (NSString *) state {
    
    if (state == nil) {
        
        return nil;
    }
    
    NSString * result = state;
    
    NSString * USState = [[self class] statesByShortcut][state];
    
    if (USState.length > 0) {
        
        result = USState;
    }
    
    return result;
}

+ (NSString *)sublocationUsingPlacemark: (CLPlacemark *) placemark {

    NSString * result = placemark.name;
    
    // for coutry location [aka name] is equal to country name
    // so we ommit it to not frustrate users and geocoder
    NSString * country = placemark.country;
    
    if (country.length > 0
        && [result isEqualToString:country]) {
        
        result = nil;
    }
    
    // for city location sublocation [aka name] is equal to city and state name
    // so we ommit it to not frustrate users and geocoder
    NSString * city = placemark.locality;
    
    if (city.length > 0
        && [result containsString:city]) {
        
        result = nil;
    }
    
    // for state location sublocation [aka name] is equal to state name
    // so we ommit it to not frustrate users and geocoder
    NSString * state = [self stateUsingStateString: placemark.administrativeArea];
    if (state.length > 0
        && [result isEqualToString:state]) {
        
        result = nil;
    }
    
    if (result.length == 0) {
        
        result = placemark.subLocality;
    }
    
    if (result.length == 0) {
        
        result = placemark.thoroughfare;
    }
    
    if (result.length == 0) {
        
        result = placemark.inlandWater;
    }
    
    if (result.length == 0) {
        
        result = placemark.ocean;
    }
    
    if (result.length == 0) {
        
        result = placemark.areasOfInterest.firstObject;
    }
    
    return result;
}

@end
