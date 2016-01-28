//
//  MZLChooseModeViewController.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/27.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLChooseModeViewController.h"
#import "UIViewController+MZLModelPresentation.h"

@interface MZLChooseModeViewController ()<UINavigationBarDelegate>

@end

@implementation MZLChooseModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self initWithStatusBar:nil navBar:self.navigationController.navigationBar];
    
   
        // 移除默认背景
        [self.navigationController.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        
        UINavigationItem *topItem = self.navigationController.navigationBar.topItem;
        UINavigationItem *bottomItem = [[UINavigationItem alloc]init];
        bottomItem.title = @"取消";
        
        [self.navigationController.navigationBar popNavigationItemAnimated:NO];
        [self.navigationController.navigationBar pushNavigationItem:bottomItem animated:NO];
        [self.navigationController.navigationBar pushNavigationItem:topItem animated:NO];
        
        self.navigationController.navigationBar.delegate = self;
}

#pragma mark - navigation bar delegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

//- (void)viewWillAppear:(BOOL)animated {
//
//    [super viewWillAppear:YES];
//    [self initWithStatusBar:nil navBar:self.navigationController.navigationBar];
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)chooseModeByPhone:(id)sender {
    
//    [self.chooseModeByPhoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.chooseModeByMailBtn setTitleColor:<#(nullable UIColor *)#> forState:<#(UIControlState)#>]
    
    [self performSegueWithIdentifier:@"toPhoneForgetPW" sender:nil];
}

- (IBAction)chooseModeBymail:(id)sender {
    
    [self performSegueWithIdentifier:@"toMailForgetPW" sender:nil];
}
@end
