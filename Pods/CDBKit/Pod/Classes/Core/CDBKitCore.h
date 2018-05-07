

#ifndef CDBKitCore
#define CDBKitCore

/* weakify and strongify */

#define varUsingObjCDB(modifier, ref, obj) modifier typeof(obj) ref = obj

#define weakCDB(weakRef) varUsingObjCDB(__weak, weakRef, self)
#define weakObjCDB(weakRef, obj) varUsingObjCDB(__weak, weakRef, obj);
#define strongObjCDB(strongRef, obj) varUsingObjCDB(__strong, strongRef, obj);

/* strings */

#define NSStringFromBool(b) (b ? @"YES" : @"NO")

/* completions */

typedef void (^CDBCompletion)(void);
typedef void (^CDBBoolCompletion) (BOOL succeed);
typedef void (^CDBErrorCompletion) (NSError * _Nullable error);
typedef void (^CDBArrayErrorCompletion) (NSArray * _Nullable array, NSError * _Nullable error);
typedef void (^CDBDictionaryErrorCompletion) (NSDictionary * _Nullable dictionary, NSError * _Nullable error);
typedef void (^CDBObjectErrorCompletion) (id _Nullable object, NSError * _Nullable error);
typedef void (^CDBStringErrorCompletion) (NSString * _Nullable string, NSError * _Nullable error);
typedef void (^CDBNumberErrorCompletion) (NSNumber * _Nullable number, NSError * _Nullable error);
typedef void (^CDBDataErrorCompletion) (NSData * _Nullable number, NSError * _Nullable error);

/* derived classes interface */

#define derivedCDB(); \
    do{\
        printf("[%s:%d]", __FUNCTION__, __LINE__);\
        NSString * _S_ =  @"WARNING \
        should be implemented in a derived class";\
        printf(" %s\r",[_S_ cStringUsingEncoding: NSUTF8StringEncoding]);\
    } while(0)

#endif /* CDBKit */
