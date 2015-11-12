//
//  MZLNoticeDetailViewController.h
//  mzl_mobile_ios
//
//  Created by race on 14-9-6.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLBaseViewController.h"
#import "MZLModelNotice.h"

@interface MZLNoticeDetailViewController : MZLBaseViewController<UIWebViewDelegate>

@property (nonatomic, strong) MZLModelNotice *noticeParam;
@property (weak, nonatomic) IBOutlet UIWebView *wvNoticeContent;

@end
