//
//  QMGeocoder.h
//  QromaScan
//
//  Created by truebucha on 8/5/16.
//  Copyright © 2016 Qroma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocationInfo/QMLocationInfo.h>

typedef NS_ENUM(NSUInteger, QMGeocoderServiceProvider) {
    QMGeocoderServiceApple = 0,
    QMGeocoderServiceGoogle
};

/**
 @brief: to provide google api key
 
 you could place it inside info.plist file in ["google"]["GeocoderApiKey"]
 <key>Google</key>
 <dict>
 <key>GeocoderApiKey</key>
 <string>ApiKeyStringHere</string>
 </dict>
 
 or use [QMGeocoderInterface acceptGoogleGeocoderApiKey:] method
 before first request occures
 */

@protocol QMGeocoderInterface

+ (instancetype _Nonnull) shared;

@property (assign, nonatomic) QMGeocoderServiceProvider service;

- (void) acceptGoogleGeocoderApiKey: (NSString * _Nonnull) key;


- (void) geocodeAddress: (NSString * _Nonnull) address
             completion: (void (^ _Nonnull)(NSArray<QMLocationInfo *> * _Nullable results, NSError * _Nullable error)) completion;

- (void) geocodeAddress: (NSString * _Nonnull) address
                  using: (QMGeocoderServiceProvider) provider
             completion: (void (^ _Nonnull)(NSArray<QMLocationInfo *> * _Nullable results, NSError * _Nullable error)) completion;

- (void) cancelGeocoding;

@end


@interface QMGeocoder : NSObject
<QMGeocoderInterface>

@end
