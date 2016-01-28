//
//  WYUtils.m
//

#import "COUtils.h"

#pragma mark - array helper

NSArray * co_emptyArray() {
    return [NSArray array];
}

NSMutableArray * co_emptyMutableArray() {
    return [NSMutableArray array];
}

#pragma mark - version related

BOOL co_isVerAtLeast(NSInteger version) {
    NSString *verToCompare = INT_TO_STR(version);
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    return [systemVersion compare:verToCompare options:NSNumericSearch] != NSOrderedAscending;
}

NSString *co_bundleVersion() {
    NSBundle *bundle = [NSBundle mainBundle];
    return [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

NSString *co_bundleBuildNumber() {
    NSBundle *bundle = [NSBundle mainBundle];
    return [bundle objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

/**
 *  As iPhone6 supports the "zoom" mode (which just gets the whole screen zoomed), need to identify this mode from "real" mode
 *
 *  @return YES if is in iPhone6 "real" mode
 */
BOOL co_isIPhone6Screen() {
    if (CO_SCREEN_WIDTH == CO_IPHONE6_SCREEN_WIDTH && [UIScreen mainScreen].scale == 2.0) {
        return YES;
    }
    return NO;
}

/**
 *  As iPhone6 plus supports the "zoom" mode (which just gets the whole screen zoomed), need to identify this mode from "real" mode
 *
 *  @return YES if is in iPhone6 plus "real" mode
 */
BOOL co_isIPhone6PlusScreen() {
    if (CO_SCREEN_WIDTH == CO_IPHONE6_PLUS_SCREEN_WIDTH && [UIScreen mainScreen].scale == 3.0) {
        return YES;
    }
    return NO;
}

#pragma mark - string utils

BOOL isEmptyString(NSString *str) {
    if (!str || str.length == 0) {
        return YES;
    }
    return NO;
}

BOOL isStrippedStringEmpty(NSString *str) {
    NSString *stripped = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return isEmptyString(stripped);
}

NSString *stripString(NSString *str) {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - global window

UIWindow *globalWindow() {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if (! window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}

#pragma mark - type conversion
NSString *INT_TO_STR(NSInteger x) {
//    int temp = (int)x;
    return [NSString stringWithFormat:@"%@", @(x)];
}

#pragma mark - UDID

// arc4random的取值范围(0 - 0x100000000)

// This UDID generator make use of the current datetime plus 4 digit random number
NSString *generateUDID() {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateformat stringFromDate:date];
    
    int randomNumber = (arc4random()%(99999-1))+1;
    return [NSString stringWithFormat:@"%@%d",dateString,randomNumber];
}

/**
 * generate a random number ranging: from - to (including from and to)
 */
NSInteger generateRandomNumber(NSInteger from, NSInteger to) {
    NSInteger value = to - from;
    return (NSInteger)(from + (arc4random() % (value + 1)));
}

#pragma mark - handy color methods

UIColor *colorWithHexString(NSString *color) {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

UIColor *colorFromRGB(CGFloat red, CGFloat green, CGFloat blue) {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

UIColor *colorWithRGBSame(CGFloat value) {
    return colorFromRGB(value, value, value);
}

#pragma mark - time and execution/dispatch

dispatch_time_t getDispatchTimeByDate ( NSDate *date ) {
    NSTimeInterval interval ;
    double second , subsecond ;
    struct timespec time ;
    dispatch_time_t milestone ;
    interval = [date timeIntervalSince1970] ;
    subsecond = modf(interval, & second) ;
    time.tv_sec = second ;
    time.tv_nsec = subsecond * NSEC_PER_SEC ;
    milestone = dispatch_walltime(& time, 0) ;
    return milestone ;
}

void executeInMainThreadAfter(int64_t seconds, dispatch_block_t blockToExecute) {
    dispatch_time_t time = dispatch_time (DISPATCH_TIME_NOW , seconds * NSEC_PER_SEC) ;
    dispatch_after(time, dispatch_get_main_queue(), blockToExecute) ;
}

void executeInBackgroundThreadAfter(int64_t seconds, dispatch_block_t blockToExecute){
    dispatch_time_t time = dispatch_time (DISPATCH_TIME_NOW , seconds * NSEC_PER_SEC) ;
    dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), blockToExecute) ;
}

#pragma mark - log

void COLogObject(NSObject *obj) {
    NSLog(@"%@", obj);
}

void COLogString(NSString *str) {
    NSLog(@"%@", str);
}

void COLogInteger(NSInteger aInt) {
    NSLog(@"%@", @(aInt));
}

void COLogFloat(CGFloat aFloat) {
    NSLog(@"%f", aFloat);
}

void COLogDouble(double aDouble) {
    NSLog(@"%f", aDouble);
}

void COLogBool(BOOL aBool) {
    NSLog(@"%d", aBool);
}

void COLogRect(CGRect rect) {
    NSLog(@"(x,y,w,h) -> %f,%f,%f,%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

#pragma mark - NSRange

NSRange CORangeMake(NSUInteger loc, NSUInteger len) {
    return NSMakeRange(loc, len);
}

#pragma mark - string utils

NSString *dateToString(NSString *formatter, NSDate *date) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return[dateFormatter stringFromDate:date];
}

NSString *co_getTimeDiffString(NSTimeInterval timestamp) {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *todate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDate *today = [NSDate date]; // current date time
    unsigned int unitFlag = NSDayCalendarUnit | NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *gap = [cal components:unitFlag fromDate:today toDate:todate options:0]; // compute time diff
    if (ABS([gap day]) > 0) {
        return [NSString stringWithFormat:@"%ld天前", ABS([gap day])];
    } else if (ABS([gap hour]) > 0) {
        return [NSString stringWithFormat:@"%ld小时前", ABS([gap hour])];
    } else if (ABS([gap minute]) > 0){
        return [NSString stringWithFormat:@"%ld分钟前",  ABS([gap minute])];
    } else {
        return @"刚刚";
    }
}


#pragma mark - file

NSString * co_documentsPath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

NSString * co_fileDocumentsPath(NSString *fileName) {
    return [co_documentsPath() stringByAppendingPathComponent:fileName];
}

NSString * co_bundlePath(NSString *fileName, NSString *extention){
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:extention];
    return path;
}

NSString * co_readFileFromBundle(NSString *fileName, NSString *extention) {
    NSError *e;
    NSString *ext = extention ? extention : @"";
    NSString *filePath = co_bundlePath(fileName, ext);
    NSString *result = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&e];
    return result;
}

BOOL co_fileExistsAtPath(NSString *filePath) {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:filePath];
}

BOOL co_fileExistsAtDocPath(NSString *fileName) {
    return co_fileExistsAtPath(co_fileDocumentsPath(fileName));
}

int co_copyFileFromBundleToDocument(NSString *fileToCopy) {
    NSString *fileDocPath = co_fileDocumentsPath(fileToCopy);
    if (co_fileExistsAtPath(fileDocPath)) {
        return -1;
    } else {
        NSString *fileBundlePath = [[NSBundle mainBundle] pathForResource:fileToCopy ofType:@""];
        BOOL result = [[NSFileManager defaultManager] copyItemAtPath:fileBundlePath toPath:fileDocPath error:nil];
        return result ? 1 : -1;
    }
}

#pragma mark - retry based on block

void co_retryBlock(NSArray *retryInterval, CO_BLOCK_VOID retryBlock, CO_BLOCK_RET_BOOL conditionBlock) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger retryIntervalIndex = -1;
        while(conditionBlock()) {
            // 已经超过最大重试次数，退出
            if (++ retryIntervalIndex >= retryInterval.count) {
                break;
            }
            NSInteger sleepInterval = [retryInterval[retryIntervalIndex] integerValue];
            [NSThread sleepForTimeInterval:sleepInterval];
        }
        if (retryBlock) {
            retryBlock();
        }
    });
}

#pragma mark - GCD related

void co_dispatchAsyncToMainThread(CO_BLOCK_VOID block) {
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}
