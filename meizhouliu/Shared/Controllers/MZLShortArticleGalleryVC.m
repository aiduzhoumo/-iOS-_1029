//
//  MZLShortArticleGalleryVC.h
//  mzl_mobile_ios
//
//  Created by race on 15/1/27.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLShortArticleGalleryVC.h"
#import "MZLTabBarViewController.h"

@interface MZLShortArticleGalleryVC ()

@end

@implementation MZLShortArticleGalleryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.toolbar setTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]];
    self.navigationItem.rightBarButtonItem = [self backBarButtonItem];
    [self.previousButton setImage:[UIImage imageNamed:@"PreviousArrowWhite"]];
    [self.nextButton setImage:[UIImage imageNamed:@"NextArrowWhite"]];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.presentingViewController isKindOfClass:[MZLTabBarViewController class]]) {
        MZLTabBarViewController *tabBarVc = (MZLTabBarViewController *)self.presentingViewController;
        [tabBarVc showMzlTabBar:NO animatedFlag:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitle:(NSString *)title {
    NSString *newTitle = [title stringByReplacingOccurrencesOfString:@" of " withString:@"  /  "];
    [super setTitle:newTitle];
}

- (UIBarButtonItem *)backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([[UIApplication sharedApplication] isStatusBarHidden]) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
    return YES;
}


#pragma mark - PTImageAlbumViewDataSource

- (NSInteger)numberOfImagesInAlbumView:(PTImageAlbumView *)imageAlbumView
{
    return self.photos.count;
}

- (CGSize)imageAlbumView:(PTImageAlbumView *)imageAlbumView sizeForImageAtIndex:(NSInteger)index
{
    return CGSizeMake(CO_SCREEN_WIDTH, CO_SCREEN_HEIGHT);
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForImageAtIndex:(NSInteger)index
{
    return [self.photos objectAtIndex:index];
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForThumbnailImageAtIndex:(NSInteger)index
{
    return nil;
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView captionForImageAtIndex:(NSInteger)index
{
    return @" ";
}

@end
