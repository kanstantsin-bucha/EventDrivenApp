

#ifndef CDBPlacedUI
#define CDBPlacedUI

typedef NS_OPTIONS(NSUInteger, CDBPlacedUIOptions) {
    CDBPlacedUIOptionsCentered = 1 << 0,
    CDBPlacedUIOptionsEqualSize = 1 << 1,
    CDBPlacedUIOptionsConstantSize = 1 << 2,
};

#endif /* CDBPlacedUI */

#import "CDBConstraintsMaster.h"
#import "CDBContainmentMaster.h"
#import "CDBPlaceholderMaster.h"