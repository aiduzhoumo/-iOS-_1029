//
//  MZLGoodsDetailViewControler.h
//  mzl_mobile_ios
//
//  Created by race on 14/12/8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLBaseViewController.h"

@class MZLModelGoods;

@interface MZLGoodsDetailViewController : MZLBaseViewController<UIWebViewDelegate>

@property (nonatomic, copy) NSString *goodsUrl;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
