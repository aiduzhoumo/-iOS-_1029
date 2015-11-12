//
//  MZLHighlightedControl.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15/3/10.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLHighlightedControl.h"

#define MZL_KEY_CONTROL_HIGHLIGHTED @"highlighted"

@interface MZLHighlightedControlObserver : NSObject

@end

@interface MZLHighlightedControl ()

@end

@implementation MZLHighlightedControl


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initInternal];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [self removeObserver:self forKeyPath:MZL_KEY_CONTROL_HIGHLIGHTED];
}

- (void)initInternal {
    _normalColor = [UIColor clearColor];
    [self addObserver:self forKeyPath:MZL_KEY_CONTROL_HIGHLIGHTED options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:MZL_KEY_CONTROL_HIGHLIGHTED]) {
        BOOL highlighted = [change[NSKeyValueChangeNewKey] boolValue];
        if (highlighted) {
            if (self.highlightedColor) {
                self.backgroundColor = self.highlightedColor;
            }
        } else {
            if (self.normalColor) {
                self.backgroundColor = self.normalColor;
            }
        }
    }
}

@end

@implementation MZLHighlightedControlObserver



@end
