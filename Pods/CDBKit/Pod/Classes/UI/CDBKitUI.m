
#import "CDBKitUI.h"

TBColor * colorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    if (red > 255
        || green > 255
        || blue > 255
        || alpha > 1) {
        return nil;
    }
    
    TBColor * result = [TBColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
    return result;
}

TBColor * colorWithHexAndAlpha(NSString * hex, CGFloat alpha) {
    if (hex.length != 6) {
        return nil;
    }
    
    NSString * R = [hex substringToIndex:2];
    NSString * G = [hex substringWithRange: NSMakeRange (2, 2)];
    NSString * B = [hex substringFromIndex:4];
    
    unsigned r, g, b;
    
    NSScanner * scanner = [[NSScanner alloc] initWithString:R];
    [scanner scanHexInt:&r];
    
    scanner = [[NSScanner alloc] initWithString:G];
    [scanner scanHexInt:&g];
    
    scanner = [[NSScanner alloc] initWithString:B];
    [scanner scanHexInt:&b];
    
    TBColor * result = colorWithRGBA(r, g, b, alpha);
    return result;
}
