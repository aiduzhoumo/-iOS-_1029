//
//  MZLFilterBar.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-4.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WIDTH_MZL_FILTER_BAR 30.0

@interface MZLFilterBar : UIView

@property (nonatomic, weak) IBOutlet UIImageView *filterImage;

- (void)toggleFilterImage:(BOOL)hasFilters;

@end
