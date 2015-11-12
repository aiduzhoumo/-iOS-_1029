//
//  ParallaxHeaderView.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-02.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "ParallaxHeaderView.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+COAdditions.h"
#import "UIImageView+MZLNetwork.h"

@interface ParallaxHeaderView ()
@property (weak, nonatomic)  UIView *contentView;
@property (weak, nonatomic)  UIImageView *imageView;
@property (weak, nonatomic)  UIView *bottomView;
@property (strong, nonatomic)  UIImageView *bluredImageView;
@end

#define DEFAULT_NAVGATION_HEIGHT 64
#define MZL_DEFAULT_NAVGATION_FRAME CGRectMake(0, (self.frame.size.height - DEFAULT_NAVGATION_HEIGHT)/2, self.frame.size.width,DEFAULT_NAVGATION_HEIGHT)
#define kDefaultHeaderFrame CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

static CGFloat kParallaxDeltaFactor = 0.5f;
static CGFloat kMaxTitleAlphaOffset = 100.0f;
static CGFloat kLabelPaddingDist = 8.0f;

@implementation ParallaxHeaderView

+ (id)parallaxHeaderViewWithImageUrl:(NSString *)imageUrl forSize:(CGSize)headerSize
{
    ParallaxHeaderView *headerView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    UIImageView *coverImage = [[UIImageView alloc] init];
    [coverImage loadArticleImageFromURL:imageUrl callbackOnImageLoaded:^{
        //当图片加载完毕重新刷新模糊图层以及导航背景
        [headerView refreshBlurViewForNewImage];
        [headerView cropViewForNavImage];
    }];
    headerView.imageView = coverImage;
    [headerView initialSetupForDefaultHeader];
    return headerView;
}

- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset
{
    CGRect frame = self.contentView.frame;
    
    if (offset.y > 0)
    {
        frame.origin.y = MAX(offset.y*kParallaxDeltaFactor , 0);
        self.contentView.frame = frame;
        self.bluredImageView.alpha =   1 / kDefaultHeaderFrame.size.height * offset.y * 2;
        self.clipsToBounds = YES;
        
        //DEFAULT_NAVGATION_HEIGHT+2 防止画面抖动
        if(self.contentView.frame.size.height - offset.y <= DEFAULT_NAVGATION_HEIGHT + 2)
        {
            if ([self.delegate respondsToSelector:@selector(parallaxShowNavigationView)])
            {
                [self.delegate parallaxShowNavigationView];
            }
        }
        
        else{
            if ([self.delegate respondsToSelector:@selector(parallaxHiddenNavigationView)])
            {
                [self.delegate parallaxHiddenNavigationView];
            }
        }
    }
    
    else
    {
        CGFloat delta = 0.0f;
        CGRect rect = kDefaultHeaderFrame;
        delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.size.height += delta;
        self.contentView.frame = rect;
        self.clipsToBounds = NO;
        self.headerTitleLabel.alpha = 1 - (delta) * 1 / kMaxTitleAlphaOffset;
    }
}

#pragma mark -
#pragma mark Private

- (void)initialSetupForDefaultHeader
{
    UIView *contentView = [[UIView alloc] initWithFrame:self.frame];
    self.contentView = contentView;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.frame = self.frame;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageView];
    
    //添加30%灰度的蒙层
    UIView *transparentView = [[UIView alloc]initWithFrame:self.frame];
    transparentView.backgroundColor = [UIColor blackColor];
    transparentView.alpha = 0.3;
    transparentView.autoresizingMask = self.imageView.autoresizingMask;
    [self.contentView addSubview:transparentView];
    
    //创建目的地名称Label
    CGRect labelRect = self.contentView.bounds;
    labelRect.origin.x  = kLabelPaddingDist;
    labelRect.origin.y = kLabelPaddingDist + 10;
    labelRect.size.width = labelRect.size.width - 2 * kLabelPaddingDist;
    labelRect.size.height = labelRect.size.height - 2 * kLabelPaddingDist;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:labelRect];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.numberOfLines = 0;
    headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    headerLabel.autoresizingMask = self.imageView.autoresizingMask;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = MZL_BOLD_FONT(18);
    self.headerTitleLabel = headerLabel;
    
    self.bluredImageView = [[UIImageView alloc] initWithFrame:self.imageView.frame];
    self.bluredImageView.autoresizingMask = self.imageView.autoresizingMask;
    self.bluredImageView.alpha = 0.0f;
    
    [self.contentView addSubview:self.bluredImageView];
    [self.contentView addSubview:headerLabel];
    [self addSubview:self.contentView];

    [self refreshBlurViewForNewImage];
    [self cropViewForNavImage];
}

- (void)refreshBlurViewForNewImage
{
    self.headerTitleLabel.hidden = YES;
    UIImage *screenShot = [UIImage co_screenshotFromView:self.contentView];
    self.headerTitleLabel.hidden = NO;
    screenShot = [screenShot applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:0.6 alpha:0.2] saturationDeltaFactor:1.0 maskImage:nil];
    self.bluredImageView.image = screenShot;
}

- (void)cropViewForNavImage
{
    self.navImage = [self.bluredImageView.image co_cropInRect:MZL_DEFAULT_NAVGATION_FRAME];
}

@end
