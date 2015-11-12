//
//  MZLAgreementViewController.m
//  mzl_mobile_ios
//
//  Created by  cos on 15/10/24.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLAgreementViewController.h"

@interface MZLAgreementViewController ()

@end

@implementation MZLAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0-self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height) forBarMetrics:UIBarMetricsDefault];
    
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://i.duzhoumo.com/notices/184714"]]];
    
    [self.view addSubview:webView];
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

@end
