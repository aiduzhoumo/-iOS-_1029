//
//  MZLPhotoViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15/3/12.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLPhotoViewController.h"
#import "UIView+MZLAdditions.h"
#import "UIImageView+MZLNetwork.h"
#import "UIView+COAdditions.h"
#import "NSString+MZLImageURL.h"

#import "MZLMockData.h"

//TODO 切换时zoom最小，第一次load图片有淡入淡出效果，bounds改变会有抖动

#define HEIGHT_PAGE_CONTROL 40
#define HEIGHT_TOP_MARGIN 40
#define PAGE_WIDTH CO_SCREEN_WIDTH
#define PAGE_HEIGHT CO_SCREEN_HEIGHT
#define PHOTO_WIDTH PAGE_WIDTH

#define TAG_PAGESCROLL 199
#define TAG_IMAGEVIEW_IMAGENOTLOAD 98
#define TAG_IMAGEVIEW_IMAGELOADED 99

#define MIN_ZOOM_LEVER 1.0
#define MAX_ZOOM_LEVER 1.5

@interface MZLPhotoViewController () {
    NSArray *_photoUrls;
    /** 0 based */
    NSInteger _activeIndex;
}

@property (weak, nonatomic) UIScrollView *photoScroll;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (weak, nonatomic) UIImageView *activeImageView;

@end

@implementation MZLPhotoViewController

- (void)viewDidLoad {
    _photoUrls = @[@"http://meizhouliu-photo.b0.upaiyun.com/uploads/photo/file/29364/image.jpg", @"http://meizhouliu-photo.b0.upaiyun.com/uploads/photo/file/68401/image.jpg", @"http://meizhouliu-photo.b0.upaiyun.com/uploads/photo/file/68402/image.jpg"]; // @[[MZLMockData mockImageUrl], [MZLMockData mockImageUrl], [MZLMockData mockImageUrl]];
    _activeIndex = 1;
    [self initInternal];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)initInternal {
    [self initPhotoScroll];
    [self initPageControl];
    [self initPhotos];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.photoScroll.backgroundColor = [UIColor clearColor];
    self.pageControl.backgroundColor = [UIColor clearColor];
}

- (void)initPhotoScroll {
    UIScrollView *photoScroll = [[UIScrollView alloc] init];
    [self.view addSubview:photoScroll];
    photoScroll.pagingEnabled = YES;
    photoScroll.showsVerticalScrollIndicator = NO;
    photoScroll.showsHorizontalScrollIndicator = NO;
    photoScroll.bounces = NO;
    photoScroll.delegate = self;
    [photoScroll co_withinParent];
    self.photoScroll = photoScroll;
}

- (void)initPageControl {
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [self.view addSubview:pageControl];
    pageControl.enabled = NO;
    [pageControl co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, 0, 0) width:COInvalidCons height:HEIGHT_PAGE_CONTROL];
    self.pageControl = pageControl;
}

- (void)initPhotos {
    NSInteger numOfPhotos = _photoUrls.count;
    self.photoScroll.contentSize = CGSizeMake(numOfPhotos * PAGE_WIDTH, PAGE_HEIGHT);
    
    self.pageControl.numberOfPages = numOfPhotos;
    self.pageControl.currentPage = _activeIndex;
    
    for (NSInteger i = 0; i < numOfPhotos; i ++) {
        UIScrollView *pageScroll = [[UIScrollView alloc] init];
        pageScroll.tag = TAG_PAGESCROLL;
        pageScroll.showsVerticalScrollIndicator = NO;
        pageScroll.showsHorizontalScrollIndicator = NO;
        pageScroll.minimumZoomScale = MIN_ZOOM_LEVER;
        pageScroll.maximumZoomScale = MAX_ZOOM_LEVER;
        pageScroll.contentSize = CGSizeMake(PAGE_WIDTH, PAGE_HEIGHT);
        pageScroll.frame = CGRectMake(i * PAGE_WIDTH, 0, PAGE_WIDTH, PAGE_HEIGHT);
        pageScroll.delegate = self;
        UITapGestureRecognizer *singleTap = [pageScroll addTapGestureRecognizer:self action:@selector(onSingleTapped:)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTapped:)];
        doubleTap.numberOfTapsRequired = 2;
        [pageScroll addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [self.photoScroll addSubview:pageScroll];
        
        UIImageView *imageView = [pageScroll createSubViewImageView];
        imageView.tag = TAG_IMAGEVIEW_IMAGENOTLOAD;
        // assign default image so we can calculate height
        imageView.image = [UIImage imageNamed:MZL_DEFAULT_IMAGE_LOCATION_BIG];
        imageView.bounds = CGRectMake(0, 0, PHOTO_WIDTH, [self getPhotoHeight:imageView.image]);
        [imageView co_pos_centerParent];
        __weak UIImageView *weakImageView = imageView;
        __weak MZLPhotoViewController *weakSelf = self;
        block_co_before_image_load beforeImageLoad = ^ (UIImage *image, UIImageView *imageView, BOOL cached) {
            CGRect bounds = imageView.bounds;
            bounds.size.height = [weakSelf getPhotoHeight:image];
            imageView.bounds = bounds;
        };
        block_image_loaded imageLoadedBlock = ^ {
            weakImageView.tag = TAG_IMAGEVIEW_IMAGELOADED;
        };
        NSDictionary *contextInfo = @{
                                      KEY_CO_BEFORE_IMAGE_LOAD_BLOCK : beforeImageLoad,
                                      KEY_CO_IMAGE_LOADED_BLOCK : imageLoadedBlock
                                      };
        [imageView loadImageFromURL:_photoUrls[i] placeholderImageName:MZL_DEFAULT_IMAGE_LOCATION_BIG mode:MZL_IMAGE_MODE_SCALED contextInfo:contextInfo];
        
//        if (i % 2 == 0) {
//            pageScroll.backgroundColor = [UIColor redColor];
//        } else {
//            pageScroll.backgroundColor = [UIColor purpleColor];
//        }
    }

    CGFloat newOffsetX = _activeIndex * PAGE_WIDTH;
    [self.photoScroll setContentOffset:CGPointMake(newOffsetX, 0) animated:NO];
    [self onActivePhotoChanged];
}

- (CGFloat)getPhotoHeight:(UIImage *)image {
    return CO_SCREEN_WIDTH * image.size.height / image.size.width;
}

#pragma mark - events handler

- (void)onDoubleTapped:(UITapGestureRecognizer *)tap {
    // disable zoom if image not loaded
    UIScrollView *scroll = (UIScrollView *)tap.view;
    UIView *view = [scroll viewWithTag:TAG_IMAGEVIEW_IMAGELOADED];

    if (view) {
        if (scroll.zoomScale >= MAX_ZOOM_LEVER) {
            [scroll setZoomScale:MIN_ZOOM_LEVER animated:YES];
        } else {
            [scroll setZoomScale:MAX_ZOOM_LEVER animated:YES];
        }
    }
}

- (void)onSingleTapped:(UITapGestureRecognizer *)tap {
    UIScrollView *scroll = (UIScrollView *)tap.view;
    UIView *view = [scroll viewWithTag:TAG_IMAGEVIEW_IMAGELOADED];
}

#pragma mark - scroll delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView.tag == TAG_PAGESCROLL) {
        return [scrollView viewWithTag:TAG_IMAGEVIEW_IMAGELOADED];
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.tag == TAG_PAGESCROLL) {
        if (! CGSizeEqualToSize(scrollView.contentSize, CGSizeZero)) {
            UIView *view = [scrollView viewWithTag:TAG_IMAGEVIEW_IMAGELOADED];
            [view co_pos_centerParent];
        }
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.photoScroll) {
        [self onActivePhotoChangedWithOffsetX:scrollView.contentOffset.x];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.photoScroll) {
        [self onActivePhotoChangedWithOffsetX:(* targetContentOffset).x];
    }
}

#pragma mark - misc

- (void)onActivePhotoChanged {
    [self onActivePhotoChangedWithOffsetX:self.photoScroll.contentOffset.x];
}

- (void)onActivePhotoChangedWithOffsetX:(CGFloat)offsetX {
    if (_activeIndex >= 0) {
        UIScrollView *pageScroll = self.photoScroll.subviews[_activeIndex];
        if (pageScroll.zoomScale > MIN_ZOOM_LEVER) {
            pageScroll.zoomScale = MIN_ZOOM_LEVER;
        }
    }
    NSInteger pageIndex = offsetX / PAGE_WIDTH;
    _activeIndex = pageIndex;
    self.pageControl.currentPage = pageIndex;
}


@end
