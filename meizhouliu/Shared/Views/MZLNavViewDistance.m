//
//  MZLNavViewDistance.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-11-6.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLNavViewDistance.h"
#import <Masonry/Masonry.h>
#import "MZLModelFilterType.h"

@interface MZLNavViewDistance () {
    __weak UIImageView *_bgDistance;
}

@end

@implementation MZLNavViewDistance

#pragma mark - protected override

- (void)initBackground {
    [super initBackground];
    UIImageView *bgDistance = [self createImageViewWithParentView:self];
    _bgDistance = bgDistance;
    bgDistance.image = [UIImage imageNamed:@"nav_distance_bg"];
    [bgDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (NSString *)titleStr {
    return @"去多远?";
}

- (NSInteger)pageIndex {
    return 2;
}

- (NSString *)nextBtnStr {
    return @"开启";
}

- (NSMutableDictionary *)centerViewLayoutParams {
    NSMutableDictionary *paramDict = [super centerViewLayoutParams];
    paramDict[MZLNavView_Center_ContainerSize] = [NSValue valueWithCGSize:CGSizeMake(140, 120)];
    paramDict[MZLNavView_Center_RowSpacing] = @18;
    paramDict[MZLNavView_Center_ColumnSpacing] = @8;
    paramDict[MZLNavView_Center_OddColumnTopMargin] = @5;
    paramDict[MZLNavView_Center_EvenColumnTopMargin] = @72;
    return paramDict;
}

- (void)onImageContainerClicked:(UIGestureRecognizer *)sender {
    UIView *targetView = sender.view;
    for (UIView *view in _imageContainers) {
        if (view == targetView) {
            continue;
        }
        UIView *tempCheckmark = [view viewWithTag:MZLNavView_Center_TAG_CHECKMARK_IMAGE];
        tempCheckmark.hidden = YES;
    }
    [super onImageContainerClicked:sender];
}

- (NSArray *)imageNames {
    return @[@"nav_distance_1", @"nav_distance_2", @"nav_distance_3", @"nav_distance_4"];
}

- (NSArray *)tagForImages {
    return @[@5, @4, @3, @2];
}

- (NSArray *)lblNames {
    return @[@"更远", @"两小时车程", @"一小时车程", @"城内"];
}

- (NSArray *)umengEvents {
    return @[@"clickDistanceOver200", @"clickDistance200", @"clickDistance100", @"clickDistanceInner"];
}

- (void)hideSubviews {
    _bgDistance.alpha = 0;
    [super hideSubviews];
}

- (MZLModelFilterType *)filterType {
    return [MZLModelFilterType distanceFilterType];
}

#pragma mark - custom animation steps

- (void)showImagesAnimated {
    [UIView animateWithDuration:1 animations:^{
        _bgDistance.alpha = 1;
    } completion:^(BOOL finished) {
        [super showImagesAnimated];
    }];
}


@end
