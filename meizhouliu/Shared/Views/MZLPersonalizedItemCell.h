//
//  MZLPersonalizedItemCell.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-11-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PCELL_BASE_COVER_IMAGE_HEIGHT 200.0
#define PCELL_BASE_HEIGHT (PCELL_BASE_COVER_IMAGE_HEIGHT + 134.0)

@class MZLModelLocationDetail, MZLPersonalizedViewController;

@interface MZLPersonalizedItemCell : UITableViewCell <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *vwCover;
@property (weak, nonatomic) IBOutlet UIView *vwInfo;
@property (weak, nonatomic) IBOutlet UIView *vwLocDesp;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consCoverHeight;

@property (weak, nonatomic) IBOutlet UIImageView *imgLocCover;

@property (nonatomic, strong) MZLModelLocationDetail *location;
@property (nonatomic, weak) MZLPersonalizedViewController *vc;
@property (nonatomic, assign) BOOL isLastCell;
@property (nonatomic, assign) BOOL isLastSection;
@property (nonatomic, assign) BOOL hasMore;

- (void)updateCell;
+ (CGFloat)cellHeight;

//- (void)toNextArticleIfPossible;

@end
