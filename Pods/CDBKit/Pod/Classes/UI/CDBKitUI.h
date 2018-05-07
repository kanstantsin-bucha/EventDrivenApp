

#ifndef CDBKitUI
#define CDBKitUI

/* osx vs ios */

#ifdef __APPLE__
    #include "TargetConditionals.h"
    #if TARGET_OS_OSX
        // Mac
        #import <AppKit/AppKit.h>
        typedef NSColor TBColor;
        typedef NSImage TBImage;
    #elif TARGET_OS_IOS
        // iOS
        #import <UIKit/UIKit.h>
        typedef UIColor TBColor;
        typedef UIImage TBImage;
    #else
        typedef NSObject TBColor;
        typedef NSObject TBImage;
    #endif
#endif

/* colors */

TBColor * _Nullable colorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);
TBColor * _Nullable colorWithHexAndAlpha(NSString * _Nonnull hex, CGFloat alpha);
#define colorWithRGB(r,g,b) colorWithRGBA(r, g, b, 1.0f)
#define colorWithHex(hex) colorWithHexAndAlpha(hex, 1.0f)

/* completions */

typedef void (^CDBImageErrorCompletion) (TBImage * _Nullable number, NSError * _Nullable error);

#endif /* CDBKitUI */
