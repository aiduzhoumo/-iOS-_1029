//
//  WYUtils.h
//

#import <Foundation/Foundation.h>

#pragma mark - array helper

NSArray * co_emptyArray();
NSMutableArray * co_emptyMutableArray();

#pragma mark - version related

BOOL co_isVerAtLeast(NSInteger version);
NSString *co_bundleVersion();
BOOL co_isIPhone6PlusScreen();
BOOL co_isIPhone6Screen();

#pragma mark - string utils
BOOL isEmptyString(NSString *str);
NSString *stripString(NSString *str);

#pragma mark - global window
UIWindow *globalWindow();

#pragma mark - type conversion
NSString *INT_TO_STR(NSInteger x);

#pragma mark - UDID
NSString *generateUDID();
/** 产生从from到to的随机数 */
NSInteger generateRandomNumber(NSInteger from, NSInteger to);

#pragma mark - handy color methods
UIColor *colorWithHexString(NSString *color);
UIColor *colorFromRGB(CGFloat red, CGFloat green, CGFloat blue);
UIColor *colorWithRGBSame(CGFloat value);

#pragma mark - time and execution/dispatch
dispatch_time_t getDispatchTimeByDate(NSDate *date);
/** execute the block after the specified time, in seconds */
void executeInMainThreadAfter(int64_t seconds, dispatch_block_t blockToExecute);
void executeInBackgroundThreadAfter(int64_t seconds, dispatch_block_t blockToExecute);

#pragma mark - log
void COLogObject(NSObject *obj);
void COLogString(NSString *str);
void COLogInteger(NSInteger aInt);
void COLogFloat(CGFloat aFloat);
void COLogRect(CGRect rect);
void COLogDouble(double aDouble);
void COLogBool(BOOL aBool);

#pragma mark - NSRange

NSRange CORangeMake(NSUInteger loc, NSUInteger len);

#pragma mark - date
NSString *dateToString(NSString *formatter, NSDate *date);
NSString *co_getTimeDiffString(NSTimeInterval timestamp);

#pragma mark - file

//BOOL fileExists(NSString *filePath);
NSString * co_readFileFromBundle(NSString *fileName, NSString *extention);

#pragma mark - retry based on block

void co_retryBlock(NSArray *retryInterval, CO_BLOCK_VOID retryBlock, CO_BLOCK_RET_BOOL conditionBlock);

#pragma mark - GCD related

void co_dispatchAsyncToMainThread(CO_BLOCK_VOID block);