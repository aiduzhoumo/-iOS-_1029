//
//  MZLTabBarViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-11.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTabBarViewController.h"
#import "MZLTabBar.h"
#import "UIViewController+MZLAdditions.h"

@interface MZLTabBarViewController () {
    __weak MZLTabBar *_mzlTabBar;
}

@end

@implementation MZLTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWindow *window = globalWindow();
    MZLTabBar *mzlTabBar = [MZLTabBar tabBarInstance:window.bounds.size];
    [window addSubview:mzlTabBar];
    _mzlTabBar = mzlTabBar;
    [self showMzlTabBar:NO animatedFlag:NO];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    // 如果选中短文输入tab，不响应事件
    if ([tabBar.items indexOfObject:item] == TAB_WRITE_SHORT_ARTICLE) {
        return;
    }
    [_mzlTabBar onTabSelected:item.tag];
}

- (void)hideTabBarTitles {
    self.tabBar.tintColor = [UIColor clearColor];
    for (UITabBarItem *item in self.tabBar.items) {
        item.title = nil;
    }
}

- (void)showMzlTabBar:(BOOL)flag animatedFlag:(BOOL)animatedFlag {
    [self hideTabBarTitles];

    UIWindow *window = globalWindow();
    CGFloat winHeight = window.bounds.size.height;
    CGRect frame = _mzlTabBar.frame;
    // fix iOS8 旋屏后tabbar变高的bug
    if (frame.size.height != MZLTabBarHeight) {
        frame.size.height = MZLTabBarHeight;
        _mzlTabBar.frame = frame;
    }
    if (flag) { // show
        frame.origin.y = winHeight - frame.size.height;
    } else {
        frame.origin.y = winHeight;
    }
    if (frame.origin.y == _mzlTabBar.frame.origin.y) {
        return;
    }
    if (animatedFlag) {
        [UIView animateWithDuration:0.2 animations:^{
            _mzlTabBar.frame = frame;
        } completion:^(BOOL finished) {
            self.tabBar.hidden = ! flag;
        }];
    } else {
        _mzlTabBar.frame = frame;
        self.tabBar.hidden = ! flag;
    }
}

#pragma mark - tab navigation

- (void)toExploreTab {
    [self selectTabAtIndex:TAB_EXPLORE];
}

- (void)toMyTab {
    [self selectTabAtIndex:TAB_MY];
}

- (void)selectTabAtIndex:(NSInteger)index {
//    if (self.viewControllers.count < (index + 1)) {
//        return;
//    }
    UIViewController *vc = self.viewControllers[index];
    self.selectedViewController = vc;
    [_mzlTabBar onTabSelected:index];
}

#pragma mark - tabbarController delegate

- (UIViewController *)topController:(UIViewController *)navController {
    UIViewController *temp = navController;
    if ([temp isKindOfClass:[UINavigationController class]]) {
        temp = ((UINavigationController *)temp).topViewController;
    }
    return temp;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    // 因为顶层的是nav controller，要取到它的root
    UIViewController *ctl = [self topController:viewController];
    [ctl mzl_onWillBecomeTabVisibleController];
    return [ctl mzl_canBecomeTabVisibleController];
}

//#pragma mark - orientation related
//
//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}
//

- (BOOL)shouldAutorotate {
    return NO;
}

@end
