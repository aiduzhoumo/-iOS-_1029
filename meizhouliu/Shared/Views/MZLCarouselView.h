//
//  MZLLocDetailCarouselView.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-6-30.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeView.h"

@interface MZLCarouselView : WeView<UIScrollViewDelegate>

- (void)hidePageControl;

+ (MZLCarouselView *)instanceWithImageUrls:(NSArray *)imageUrls defaultImageName:(NSString *)defaultImageName frame:(CGRect)frame;

@end
