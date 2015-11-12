//
//  NSString+COMd5.h
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (COMd5)

- (NSString *) MD5Hash;

@end
