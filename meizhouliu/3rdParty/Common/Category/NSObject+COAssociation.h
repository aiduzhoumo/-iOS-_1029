//
//  NSObject+WYAssociation.h
//

#import <Foundation/Foundation.h>

@interface NSObject (COAssociation)

- (id)getProperty:(NSString *)key;
- (void)setProperty:(NSString *)key value:(id)value;
- (void)removeProperty:(NSString *)key;

@end
