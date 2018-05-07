#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CDBKit.h"
#import "CDBKitArray.h"
#import "CDBKitCore.h"
#import "CDBKitLocalize.h"
#import "CDBKitUI.h"

FOUNDATION_EXPORT double CDBKitVersionNumber;
FOUNDATION_EXPORT const unsigned char CDBKitVersionString[];

