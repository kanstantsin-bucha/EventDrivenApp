//
//  QMGeocoder.m
//  QromaScan
//
//  Created by truebucha on 8/5/16.
//  Copyright © 2016 Qroma. All rights reserved.
//

#import "QMGeocoder.h"
#import <CoreLocation/CoreLocation.h>
#import <LMGeocoderUniversal/LMGeocoderUniversal.h>
#import <LocationInfo/QMLocationInfoAppleConvertion.h>
#import <LocationInfo/QMLocationInfoLuongConvertion.h>


@interface QMGeocoder ()

@property (strong, nonatomic, readonly) LMGeocoder * geocoder;
@property (assign, nonatomic) BOOL infoDictionaryChecked;

@end


@implementation QMGeocoder

@synthesize service;

#pragma mark  - property -

- (LMGeocoder *) geocoder {
    LMGeocoder * result = [LMGeocoder sharedInstance];
    
    // read api key from info dictionary
    if (self.infoDictionaryChecked == false
        && result.googleAPIKey == nil) {
        NSString * key = [NSBundle mainBundle].infoDictionary[@"Google"][@"GeocoderApiKey"];
        result.googleAPIKey = key;
    }
    
    return result;
}

//MARK: - life cycle -

+ (instancetype)shared {
    static QMGeocoder * _shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[super allocWithZone: NULL] initLocal];
    });
    
    return _shared;
}

+ (instancetype) allocWithZone: (struct _NSZone *) zone {
    
    return [self shared];
}

- (instancetype) copyWithZone: (struct _NSZone *) zone {
    
    return self;
}

- (instancetype) initLocal {
    self = [super init];
    return self;
}

//MARK: - interface -

- (void) acceptGoogleGeocoderApiKey: (NSString *) key {
    
    [LMGeocoder sharedInstance].googleAPIKey = key;
}

- (void) cancelGeocoding {
    
    [self.geocoder cancelGeocode];
}

- (void) geocodeAddress: (NSString * _Nonnull) address
             completion: (void (^ _Nonnull)(NSArray<QMLocationInfo *> * _Nullable results, NSError * _Nullable error))completion {
    
    [self geocodeAddress: address
                   using: self.service
              completion: completion];
}

- (void) geocodeAddress: (NSString * _Nonnull) address
                  using: (QMGeocoderServiceProvider) provider
             completion: (void (^ _Nonnull)(NSArray<QMLocationInfo *> * _Nullable results, NSError * _Nullable error)) completion {
    
    if (completion == nil) {
        return;
    }
    
    LMGeocoderService service = kLMGeocoderAppleService;
    
    switch (provider) {
        case QMGeocoderServiceGoogle: {
            service = kLMGeocoderGoogleService;
        }    break;
        case QMGeocoderServiceApple:
        default: {
            service = kLMGeocoderAppleService;
        }    break;
    }
    
    [self processAddress: address
                 service: service
              completion: completion];
}

//MARK: - logic -

- (void) processAddress: (NSString *) address
                service: (LMGeocoderService) service
             completion: (void (^ _Nonnull)(NSArray<QMLocationInfo *> * _Nullable results, NSError * _Nullable error)) completion {
    
    if (completion == nil) {
        return;
    }
    
    [self.geocoder geocodeAddressString: address
                                service: service
                      completionHandler: ^(NSArray<LMAddress *> * _Nullable places, NSError * _Nullable error) {
        
        if (error != nil
            || places.count == 0) {
            NSLog(@"Geocoder could not find location with address : %@ \
                  \r\n %@",
                  address, error != nil ? error : @"");
        }

        NSMutableArray * results = [NSMutableArray array];
                          
        for (LMAddress * place in places) {
            QMLocationInfo * info = [QMLocationInfoLuongConvertion locationInfoUsingAddress: place];
            if (info == nil) {
                NSLog(@"Geocoder could not create location info for place %@", place);
            }
            [results addObject: info];
         }
        
         completion(results, error);
    }];
}

@end
