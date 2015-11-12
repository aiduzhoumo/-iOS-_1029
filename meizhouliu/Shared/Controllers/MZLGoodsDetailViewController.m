//
//  MZLGoodsDetailViewControler.m
//  mzl_mobile_ios
//
//  Created by race on 14/12/8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLGoodsDetailViewController.h"
#import "UIBarButtonItem+COAdditions.h"

@interface MZLGoodsDetailViewController ()

@end

@implementation MZLGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initCloseButton];
    [self initWeb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initWeb {
    self.title = @"相关商品";
    self.webView.backgroundColor = MZL_BG_COLOR();
    self.webView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:webUrl(self.goodsUrl)];
    [self.webView loadRequest:request];
}

- (void)initCloseButton {
    UIBarButtonItem *_closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(backToParent)];
    self.navigationItem.rightBarButtonItem = _closeBtn;
}

- (UIBarButtonItem *)backBarButtonItem:(SEL)action {
    
    SEL btnAction = action;
    if (! btnAction) {
        btnAction = @selector(back);
    }
    return [UIBarButtonItem itemWithSize:CGSizeMake(24.0, 24.0) imageName:@"BackArrow"  target:self action:btnAction];
}

- (void)back {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self backToParent];
    }
}

@end
