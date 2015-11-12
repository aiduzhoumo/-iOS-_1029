//
//  MZLNavViewPeople.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-10-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLNavViewPeople.h"
#import <Masonry/Masonry.h>
#import "UIView+COAdditions.h"
#import "MZLModelFilterType.h"

@interface MZLNavViewPeople () {
//    UIView *_topView;
//    UIView *_bottomView;
//    UIView *_imageContainerView;
}

//@property (nonatomic, readonly) NSArray *imageNames;
//@property (nonatomic, readonly) NSArray *lblTitles;


@end

@implementation MZLNavViewPeople

#pragma mark - protected override

- (NSString *)titleStr {
    return @"和谁玩?";
}

- (NSInteger)pageIndex {
    return 0;
}

- (NSMutableDictionary *)centerViewLayoutParams {
    NSMutableDictionary *paramDict = [super centerViewLayoutParams];
    paramDict[MZLNavView_Center_ContainerSize] = [NSValue valueWithCGSize:CGSizeMake(115, 161)];
    paramDict[MZLNavView_Center_HMargin] = @30;
    paramDict[MZLNavView_Center_RowSpacing] = @8;
    paramDict[MZLNavView_Center_ColumnSpacing] = @30;
    return paramDict;
}

- (NSArray *)imageNames {
    return @[@"nav_people_1", @"nav_people_2", @"nav_people_3", @"nav_people_4"];
}

- (NSArray *)tagForImages {
    return @[@5, @3, @6, @2];
}

- (NSArray *)lblNames {
    return @[@"单身", @"情侣", @"群体", @"闺蜜"];
}

- (NSArray *)umengEvents {
    return @[@"clickNavPeopleSingle", @"clickNavPeopleSweetheart", @"clickNavPeopleGroup", @"clickNavPeopleBFF"];
}

- (MZLModelFilterType *)filterType {
    return [MZLModelFilterType peopleFilterType];
}

@end
