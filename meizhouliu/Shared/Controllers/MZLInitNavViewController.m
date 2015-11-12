//
//  MZLInitNavViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-10-27.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLInitNavViewController.h"
#import "UIView+COAdditions.h"
#import "MZLNavViewPeople.h"
#import "MZLNavViewFeature.h"
#import "MZLNavViewDistance.h"
#import "MZLSharedData.h"
#import "MZLTabBarViewController.h"

@interface MZLInitNavViewController () {
    UIScrollView *_contentScroll;
    NSArray *_navViews;
}

@end

@implementation MZLInitNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addBg];
    [self addNavViews];
    [self onViewLoaded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self onViewDidAppear];
}

- (void)onViewLoaded {
    for (MZLNavView *navView in _navViews) {
        [navView hideSubviews];
    }
}

- (void)onViewDidAppear {
    [_navViews[0] showSubviewsAnimatedIfNecessary];
}

- (void)addBg {
    CGRect frame = CGRectMake(0, 0, self.view.width, self.view.height);
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:frame];
    bgImage.image = [UIImage imageNamed:@"nav_bg_1"];
    [self.view addSubview:bgImage];
}

- (void)addNavViews {
    CGRect frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    UIScrollView *contentScroll = [[UIScrollView alloc] initWithFrame:frame];
    _contentScroll = contentScroll;
    
    _navViews = [NSMutableArray array];
    MZLNavView *firstView = [[MZLNavViewPeople alloc] initWithFrame:frame];
    frame.origin.x += self.view.width;
    MZLNavView *secondView = [[MZLNavViewFeature alloc] initWithFrame:frame];
    frame.origin.x += self.view.width;
    MZLNavView *thirdView = [[MZLNavViewDistance alloc] initWithFrame:frame];
    _navViews = @[firstView, secondView, thirdView];
    
    contentScroll.contentSize = CGSizeMake(_navViews.count * self.view.width, self.view.height);
    contentScroll.pagingEnabled = YES;
    contentScroll.showsHorizontalScrollIndicator = NO;
    contentScroll.bounces = NO;
    contentScroll.delegate = self;
    [self.view addSubview:contentScroll];
    
    for (MZLNavView *navView in _navViews) {
        navView.delegate = self;
        [contentScroll addSubview:navView];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger pageIndex = scrollView.contentOffset.x / self.view.width;
    MZLNavView *navView = _navViews[pageIndex];
    [navView showSubviewsAnimatedIfNecessary];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

#pragma mark - nav view delegate

- (void)onNextStep:(id)sender {
    NSInteger totalPage = _contentScroll.contentSize.width / self.view.width;
    NSInteger pageIndex = _contentScroll.contentOffset.x / self.view.width;
    if (pageIndex < totalPage - 1) {
        CGFloat newOffsetX = _contentScroll.contentOffset.x + self.view.width;
        [_contentScroll setContentOffset:CGPointMake(newOffsetX, _contentScroll.contentOffset.y) animated:YES];
    } else if (pageIndex == totalPage - 1) {
        NSMutableArray *selectedFitlers = [NSMutableArray array];
        for (MZLNavView *navView in _navViews) {
            MZLModelFilterType *filterTypeWithSelectedOptions = [navView filterTypeWithSelectedOptions];
            if (filterTypeWithSelectedOptions) {
                [selectedFitlers addObject:filterTypeWithSelectedOptions];
            }
        }
        [MZLSharedData setSelectedFilterOptions:selectedFitlers];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self performSegueWithIdentifier:@"main" sender:nil];
        // 仅当有选中filter时呈现过场动画，因为此时不会有定制filter界面弹出
        if (selectedFitlers.count > 0) {
            MZLNavView *navView = _navViews[pageIndex];
            [navView disappearAnimated];
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            MZLTabBarViewController *mainTab = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:@"MainTab"];
//            self.view.window.rootViewController = mainTab;
//        });
    }
}

- (void)onAnimationStart {
    _contentScroll.scrollEnabled = NO;
}

- (void)onAnimationEnd {
    _contentScroll.scrollEnabled = YES;
}

@end
