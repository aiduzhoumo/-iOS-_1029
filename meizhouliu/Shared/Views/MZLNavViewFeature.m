//
//  MZLNavViewFeature.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-11-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLNavViewFeature.h"
#import <Masonry/Masonry.h>
#import "MZLModelFilterType.h"

@interface MZLNavViewFeature () {
    
}

@end

@implementation MZLNavViewFeature

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - protected override

- (NSString *)titleStr {
    return @"玩什么?";
}

- (NSInteger)pageIndex {
    return 1;
}

- (NSMutableDictionary *)centerViewLayoutParams {
    NSMutableDictionary *paramDict = [super centerViewLayoutParams];
    paramDict[MZLNavView_Center_ContainerSize] = [NSValue valueWithCGSize:CGSizeMake(90, 88)];
    paramDict[MZLNavView_Center_ColumnCount] = @3;
    paramDict[MZLNavView_Center_RowSpacing] = @12;
    paramDict[MZLNavView_Center_ColumnSpacing] = @9;
    paramDict[MZLNavView_Center_OddColumnTopMargin] = @18;
    paramDict[MZLNavView_Center_EvenColumnTopMargin] = @18;
    return paramDict;
}

- (NSArray *)imageNames {
    return @[@"nav_feature_1", @"nav_feature_2", @"nav_feature_3",
             @"nav_feature_4", @"nav_feature_5", @"nav_feature_6",
             @"nav_feature_7", @"nav_feature_8", @"nav_feature_9",];
}

- (NSArray *)tagForImages {
    return @[@7, @22, @55, @9, @36, @101, @23, @12, @98];
}

- (NSArray *)lblNames {
    return @[@"文艺", @"美食", @"摄影", @"古镇", @"海边", @"露营", @"夜生活", @"浪漫", @"户外"];
}

- (NSArray *)imageSequenceInAnimation {
    return @[@4, @2, @6, @8, @0, @5, @3, @1, @7];
}

- (NSArray *)umengEvents {
    return @[@"clickNavFeatureWenyi", @"clickNavFeatureDelicious", @"clickNavFeaturePhotographic", @"clickNavFeatureVillage",@"clickNavFeatureBeach",@"clickNavFeatureCamp",@"clickNavFeatureNightclub",@"clickNavFeatureRomantic",@"clickNavFeatureOuting"];
}

- (MZLModelFilterType *)filterType {
    return [MZLModelFilterType featureFilterType];
}

@end
