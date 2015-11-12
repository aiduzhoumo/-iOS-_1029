//
//  MZLFilterBar.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-4.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterBar.h"
#import "UIView+CODrawing.h"

@implementation MZLFilterBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void)awakeFromNib {
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)toggleFilterImage:(BOOL)hasFilters {
    NSString *imageName = hasFilters ? @"Filter_Highlight" : @"Filter";
    self.filterImage.image = [UIImage imageNamed:imageName];
}


@end
