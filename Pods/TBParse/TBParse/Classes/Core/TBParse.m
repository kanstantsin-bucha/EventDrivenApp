//
//  TBParse.m
//  QromaScan
//
//  Created by Kanstantsin Bucha on 8/1/18.
//  Copyright © 2018 Qroma. All rights reserved.
//

#import "TBParse.h"
#import <Parse/Parse.h>
#import <TBConversions/TBParseConversions.h>

#define TB_Parse_Strings_ComponentsSeparators_Characters @";"
#define TB_Parse_Strings_PairDivider_Characters @":"


@implementation TBParse
 
    
/// MARK: base conversion
    
    
+ (NSDictionary<NSString *,NSObject *> *)dictionaryUsingParseObject:(PFObject *)object {
    
    NSDictionary<NSString *,NSObject *> * result =
        [object dictionaryWithValuesForKeys: [object allKeys]];
    
    return result;
}

/// MARK: object conversion logic


+ (id)objectOfClass:(Class)class
    fromParseObject:(PFObject *)object
           usingKey:(NSString *)key {
    NSObject * result = [TBParseConversions objectOfClass: class
                                           fromDictionary: (NSDictionary<NSString *, NSObject *> *)object
                                                 usingKey: key];
    return result;
}
    
+ (BOOL)object:(PFObject *)object
 isKindOfClass:(NSString *)class {
    BOOL result = [object.parseClassName isEqualToString: class];
    return result;
}

@end
