
#import "CDBKitArray.h"


@implementation NSArray (CDBArray)

- (NSArray * _Nonnull)map: (id _Nonnull (^_Nonnull)(id _Nonnull obj))block {
    
    NSMutableArray * result = [NSMutableArray array];
    
    for (id obj in self) {
        id mappedObj = block(obj);
        id validObj = mappedObj != nil ? mappedObj
        : [NSNull null];
        [result addObject: validObj];
    }
    
    return [result copy];
}

@end
