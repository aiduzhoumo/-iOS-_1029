//
//  COCache.h
//  A handy class dealing with caching images/videos in the local temp directory
//

#import <Foundation/Foundation.h>

@interface COCache : NSObject

+ (void)resetCache;

+ (void)setObject:(NSData *)data forKey:(NSString *)key;
+ (NSData *)objectForKey:(NSString *)key;

@end
