//
//  TBParse.h
//  QromaScan
//
//  Created by Kanstantsin Bucha on 8/1/18.
//  Copyright © 2018 Qroma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFObject;

@interface TBParseConversions : NSObject
    
+ (NSArray<NSNumber *> *) numbersUsingStringsList: (NSString *) list;
+ (NSArray<NSString *> *) wordsUsingStringsList: (NSString *) list;
+ (NSDictionary<NSString *, NSNumber *> *) pairsUsingStrings: (NSString *) strings;
    
+ (id) objectOfClass: (Class) class
      fromDictionary: (NSDictionary *)  dict
            usingKey: (NSString *) key;

@end
