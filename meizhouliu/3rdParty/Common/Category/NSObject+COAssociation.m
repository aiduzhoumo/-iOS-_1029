//
//  NSObject+WYAssociation.m
//

#import "NSObject+COAssociation.h"
#import <objc/runtime.h>

// use a dictionary as the associated object for keeping any additional properties

@implementation NSObject (COAssociation)

const char *KEY_ASSOCIATION_MAP;

- (id)getProperty:(NSString *)key {
    NSMutableDictionary *associationMap = objc_getAssociatedObject(self, KEY_ASSOCIATION_MAP);
    if (! associationMap) {
        return nil;
    }
    return [associationMap objectForKey:key];
}

- (void)setProperty:(NSString *)key value:(id)value {
    NSMutableDictionary *associationMap = objc_getAssociatedObject(self, KEY_ASSOCIATION_MAP);
    if (! associationMap) {
        associationMap = [[NSMutableDictionary alloc]init];
        objc_setAssociatedObject(self, KEY_ASSOCIATION_MAP, associationMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (value) {
        [associationMap setObject:value forKey:key];
    } else {
        [associationMap removeObjectForKey:key];
    }
}

- (void)removeProperty:(NSString *)key {
    [self setProperty:key value:nil];
}

@end
