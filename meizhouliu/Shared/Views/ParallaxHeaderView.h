//
//  ParallaxHeaderView.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-02.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ParallaxHeaderViewDelegate <NSObject>

-(void)parallaxShowNavigationView;
-(void)parallaxHiddenNavigationView;

@end

@interface ParallaxHeaderView : UIView
@property (nonatomic,strong)  UILabel *headerTitleLabel;
@property (nonatomic,strong)  UIImage *navImage;
@property (weak,nonatomic)id<ParallaxHeaderViewDelegate>delegate;

+ (id)parallaxHeaderViewWithImageUrl:(NSString *)imageUrl forSize:(CGSize)headerSize;
//+ (id)parallaxHeaderViewWithSubView:(UIView *)subView;
- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset;
//- (void)refreshBlurViewForNewImage;
@end