//
//  MZLImageGalleryNavigationControllerViewController.m
//  mzl_mobile_ios
//
//  Created by race on 14-8-21.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLImageGalleryNavigationController.h"

@interface MZLImageGalleryNavigationController ()

@end

@implementation MZLImageGalleryNavigationController

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
    self.navigationBar.barTintColor = [UIColor blackColor];
    UIColor *fontColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.navigationBar.tintColor = fontColor;
    NSDictionary *titleAttributes = @{
                                      NSForegroundColorAttributeName : fontColor,
                                      NSFontAttributeName : MZL_NAVBAR_TITLE_FONT()
                                      };
    self.navigationBar.titleTextAttributes = titleAttributes;
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

#pragma mark - rotation support

/** 需要结合appDelegate的application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window来确定 */
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate {
    return YES;
}


@end
