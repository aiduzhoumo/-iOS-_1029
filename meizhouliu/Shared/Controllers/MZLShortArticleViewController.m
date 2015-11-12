//
//  MZLShortArticleViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLShortArticleViewController.h"
#import "UIViewController+MZLAdditions.h"
#import "MZLTabBarViewController.h"
#import "MZLLoginViewController.h"

@interface MZLShortArticleViewController ()

@end

@implementation MZLShortArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)toShortArticle {
    UIStoryboard *shortArticleSB = MZL_SHORT_ARTICLE_STORYBOARD();
    UIViewController *controller = [shortArticleSB instantiateInitialViewController];
    [self.tabBarController presentViewController:controller animated:YES completion:nil];
}

- (BOOL)mzl_canBecomeTabVisibleController {
    // 必须先登录
    if (! [MZLSharedData isAppUserLogined]) {
        MZLTabBarViewController *tabVC = (MZLTabBarViewController *)self.tabBarController;
        [tabVC showMzlTabBar:NO animatedFlag:NO];
        __weak MZLShortArticleViewController *weakSelf = self;
        [self popupLoginFrom:MZLLoginPopupFromShortArticle executionBlockWhenDismissed:^{
            if ([MZLSharedData isAppUserLogined]) {
                [weakSelf toShortArticle];
            }
        }];
    } else {
        [self toShortArticle];
    }
    return NO;
}

@end
