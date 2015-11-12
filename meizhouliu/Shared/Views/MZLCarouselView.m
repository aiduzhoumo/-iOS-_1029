//
//  MZLLocDetailCarouselView.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-6-30.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLCarouselView.h"
#import "MZLModelLocationDetail.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLModelImage.h"
#import "UIImage+COAdditions.h"

@interface MZLCarouselView() {
    UIImage *_defaultScaledImage;
}

@property (weak, nonatomic)UIScrollView *scrollView;
@property (weak, nonatomic)UIPageControl *pageControl;
@property (assign, nonatomic)NSInteger currentPageForImageView;
@property (assign, nonatomic)NSUInteger numberOfPages;

@property (nonatomic, copy)NSString *defaultImageName;
@property (nonatomic, assign)CGSize viewSize;
@property (nonatomic, strong)NSMutableArray *imageViews;
@property (nonatomic, strong)NSArray *imageUrls;


@end

@implementation MZLCarouselView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (MZLCarouselView *)instanceWithImageUrls:(NSArray *)imageUrls defaultImageName:(NSString *)defaultImageName frame:(CGRect)frame {
    if (! imageUrls || imageUrls.count == 0) {
        return [[MZLCarouselView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.01)];
    }
    
    MZLCarouselView *carouseView = [[MZLCarouselView alloc] initWithFrame:frame];
    carouseView.viewSize = frame.size;
//    carouseView.defaultImageName = defaultImageName;
    [carouseView initDefaultImage:defaultImageName];
    carouseView.imageUrls = imageUrls;
    
    carouseView.numberOfPages = imageUrls.count;
    carouseView.currentPageForImageView = 1;
    [carouseView initCarouselScroll];
    [carouseView initPageControl];
    
    return carouseView;
}

//- (void)setFrame:(CGRect)frame {
//    [super setFrame:frame];
//    [self carousel_onLayoutSubviews];
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self carousel_onLayoutSubviews];
}

- (void)carousel_onLayoutSubviews {
    CGRect frame = self.frame;
    if (frame.size.height < self.viewSize.height) { // 视差效果
//        self.scrollView.height = self.viewSize.height;
//        for (UIImageView *imageView in self.imageViews) {
//            imageView.contentMode = UIViewContentModeTop;
//            imageView.height = self.viewSize.height;
//        }
    } else { // 拉伸效果
        self.scrollView.height = frame.size.height;
        for (UIImageView *imageView in self.imageViews) {
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.height = frame.size.height;
        }
    }
}

- (void)initDefaultImage:(NSString *)imageName {
    self.defaultImageName = imageName;
    _defaultScaledImage = [[UIImage imageNamed:imageName] scaledToSize:self.viewSize];
}

- (void)initCarouselScroll {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, self.viewSize.height)];
    self.scrollView = scrollView;
//    [scrollView setFixedDesiredWidth:self.viewSize.width];
    
//    [scrollView setVStretches];
//    [scrollView setFixedDesiredSize:self.viewSize];
    [scrollView setBackgroundColor:MZL_BG_COLOR()];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setBounces:NO];
    [scrollView setScrollEnabled:YES];
    [scrollView setPagingEnabled:YES];// 使用翻页属性
    [scrollView setDelegate:self];
    
    [self initImageViews];

//    [self addSubviewsWithVerticalLayout:@[scrollView]];
    [self addSubview:scrollView];
}

- (UIImageView *)imageViewWithX:(CGFloat)x {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, self.viewSize.width, self.viewSize.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    if (! self.imageViews) {
        self.imageViews = [NSMutableArray array];
    }
    [self.imageViews addObject:imageView];
    return imageView;
}

- (void)initImageViews {
    // 如果只有一张图，不需要进行循环播放
    if (self.numberOfPages == 1) {
        UIImageView *imageView = [self imageViewWithX:0.0];
        [self imageView:(UIImageView *)imageView loadImage:self.imageUrls[0]];
        [self.scrollView addSubview:imageView];
        [self.scrollView setContentSize:self.viewSize];
        return;
    }
    // 包括首尾实现循环播放
    NSUInteger imageViewCount = self.numberOfPages + 2;
    int initialPage = 1;
    UIImageView *firstImageViewInPageControl;
    UIImageView *lastImageViewInPageControl;
    // 轮播的逻辑为第一张图片前加一张最后的图片，最后一张图片后加第一张图片，实现首尾轮播。
    // 同时，为避免首尾轮播图片重复加载，在第一张图片加载完后同时更新轮播最后一张图片，最后一张图片加载完成后更新轮播第一张图片
    for (int i = initialPage; i <= imageViewCount; i++) {
        UIImageView *imageView = [self imageViewWithX:(i - 1) * self.viewSize.width];
        if (i == initialPage) {
            [self placeHolderImageView:(UIImageView *)imageView loadImage:self.imageUrls[self.numberOfPages - 1]];
        } else if (i == initialPage + 1) {
            firstImageViewInPageControl = imageView;
        } else if (i == imageViewCount - 1) {
            lastImageViewInPageControl = imageView;
        } else if (i == imageViewCount) {
            [self placeHolderImageView:(UIImageView *)imageView loadImage:self.imageUrls[0]];
        } else {
            [self imageView:(UIImageView *)imageView loadImage:self.imageUrls[i - 2]];
        }
        [self.scrollView addSubview:imageView];
    }
    
    __weak MZLCarouselView *weakSelf = self;
    
    [self imageView:firstImageViewInPageControl loadImage:self.imageUrls[0] callbackOnImageLoaded:^{
        UIImage *scaledImage = [firstImageViewInPageControl.image scaledToSize:weakSelf.viewSize];
        firstImageViewInPageControl.image = scaledImage;
        [weakSelf imageView:weakSelf.scrollView.subviews[weakSelf.numberOfPages + 1] loadImage:weakSelf.imageUrls[0]];
    }];
    
    [self imageView:lastImageViewInPageControl loadImage:self.imageUrls[self.numberOfPages - 1] callbackOnImageLoaded:^{
        UIImage *scaledImage = [lastImageViewInPageControl.image scaledToSize:weakSelf.viewSize];
        lastImageViewInPageControl.image = scaledImage;
        [weakSelf imageView:weakSelf.scrollView.subviews[0] loadImage:weakSelf.imageUrls[weakSelf.numberOfPages - 1]];
    }];
    
    [self.scrollView setContentSize:CGSizeMake(self.viewSize.width * imageViewCount, self.height)];
    [self.scrollView setContentOffset:CGPointMake(self.viewSize.width, 0)];
}

- (BOOL)isNetworkImage:(NSString *)imageURL {
    return [imageURL hasPrefix:@"http"];
}

- (void)imageView:(UIImageView *)imageView loadImage:(NSString *)imageURL {
    CGSize scaledSize = self.viewSize;
    [self imageView:imageView loadImage:imageURL callbackOnImageLoaded: ^ {
        UIImage *scaledImage = [imageView.image scaledToSize:scaledSize];
        imageView.image = scaledImage;
    }];
}

- (void)imageView:(UIImageView *)imageView loadImage:(NSString *)imageURL callbackOnImageLoaded:(block_image_loaded)callbackOnImageLoaded {
    if ([self isNetworkImage:imageURL]) {
        [imageView loadImageFromURL:imageURL placeholderImage:_defaultScaledImage mode:nil callbackOnImageLoaded:callbackOnImageLoaded];
    } else {
        imageView.image = [UIImage imageNamed:imageURL];
        if (callbackOnImageLoaded) {
            callbackOnImageLoaded();
        }
    }
}

- (void)placeHolderImageView:(UIImageView *)imageView loadImage:(NSString *)imageURL {
    if ([self isNetworkImage:imageURL]) {
        imageView.image = _defaultScaledImage; //[UIImage imageNamed:self.defaultImageName];
    } else {
        UIImage *scaledImage = [[UIImage imageNamed:imageURL] scaledToSize:self.viewSize];
        imageView.image = scaledImage;
    }
}

- (void)initPageControl {
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    self.pageControl = pageControl;
    [pageControl setHidesForSinglePage:YES];
    [pageControl setNumberOfPages:self.numberOfPages];
    [pageControl setCurrentPage:0];
    [pageControl setCurrentPageIndicatorTintColor:colorWithHexString(@"#fdd414")];
    [pageControl setPageIndicatorTintColor:colorWithHexString(@"#eaeaea")];
    [pageControl setMinDesiredHeight:50.0];
    
//    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [pageControl addTarget:self action:@selector(onPageControlClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    [[self addSubviewWithCustomLayout:pageControl] setVAlign:V_ALIGN_BOTTOM];
}



#pragma mark - page control delegate and related

- (void)hidePageControl {
    self.pageControl.hidden = YES;
}

- (void)onPageControlClicked:(id)sender {
    NSInteger pageForImageView = self.pageControl.currentPage + 1;
    if (pageForImageView != self.currentPageForImageView) {
        [self setPageAndScroll:pageForImageView animatedFlag:YES];
    } else {
        if (pageForImageView == 1) {
            [self setPageAndScroll:0 animatedFlag:YES];
        } else if (pageForImageView == self.numberOfPages) {
            [self setPageAndScroll:self.numberOfPages + 1  animatedFlag:YES];
        }
    }
}

//- (void)changePage:(id)sender {}

/** 同scroll中imageView的位置，包括前后两个用于循环显示的view，page从0开始计算 */
- (void)setPage:(NSInteger)page {
    NSInteger pageIndexForPageControl = page - 1;
    // 循环逻辑
    if (pageIndexForPageControl < 0) {
        pageIndexForPageControl = self.numberOfPages - 1;
    } else if (pageIndexForPageControl > self.numberOfPages - 1) {
        pageIndexForPageControl = 0;
    }
    self.currentPageForImageView = pageIndexForPageControl + 1;
    self.pageControl.currentPage = pageIndexForPageControl;
}

- (void)setPageAndScroll:(NSInteger)page {
    [self setPageAndScroll:page animatedFlag:YES];
}

- (void)setPageAndScroll:(NSInteger)page animatedFlag:(BOOL)animatedFlag {
    [self setPage:page];
    /** 要考虑第一个和最后一个ImageView, 它们不在pageControl中显示 */
    [self.scrollView setContentOffset: CGPointMake(page * self.viewSize.width, 0.0f) animated:animatedFlag];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollToFirstPageForPageControl:(BOOL)animated {
    /** pageControl的第一页即scroll的第二页 */
    [self setPageAndScroll:1 animatedFlag:animated];
}

- (void)scrollToLastPageForPageControl:(BOOL)animated {
    /** pageControl的最后一页即scroll的倒数第二页 */
    [self setPageAndScroll:self.numberOfPages animatedFlag:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger pageForImageView = scrollView.contentOffset.x / self.viewSize.width;
    NSInteger offSetX_Mod = (NSInteger)scrollView.contentOffset.x % (NSInteger)self.viewSize.width;
    NSInteger offSetForPageChange = (NSInteger)self.viewSize.width / 2;
//    NSLog(@"%d, %d", pageForImageView, offSetX_Mod);

    // 当scroll左右滑动超过viewSize.width一半的时候，会切换到前一个/下一个页面
    if (pageForImageView == self.currentPageForImageView) {
        // 检查是否应该切换到下一个页面
        if (offSetX_Mod > offSetForPageChange) {
            [self setPage:(pageForImageView + 1)];
        }
    } else if (pageForImageView + 1 == self.currentPageForImageView) {
        // 检查是否应该切换到前一个页面
        if (offSetX_Mod < offSetForPageChange) {
            [self setPage:pageForImageView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)view {
    [self checkScrollLoop];
}

/** 循环显示逻辑 */
- (void)checkScrollLoop {
    int pageForImageView = self.scrollView.contentOffset.x / self.viewSize.width;
    if (pageForImageView == 0) {
        [self scrollToLastPageForPageControl:NO];
    } else if (pageForImageView == self.numberOfPages + 1) {
        [self scrollToFirstPageForPageControl:NO];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self checkScrollLoop];
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)view{
//        if ( view.contentOffset.x != self.width && (view.contentOffset.x == self.width * 2 || view.contentOffset.x == 0)) {
//            if (self.scrollView.contentOffset.x == 0) {
//                self.currentPage--;
//            }else{
//                self.currentPage++;
//            }
//            if (self.currentPage == self.numberOfPages) {
//                self.currentPage = 0;
//            }
//            if (self.currentPage == -1) {
//                self.currentPage = self.numberOfPages -1;
//            }
//            [self.pageControl setCurrentPage:self.currentPage];
//            
//            [self reSetScrollViewOffSet];
//        }
//}

@end
