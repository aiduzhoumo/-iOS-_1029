//
//  MZLArticleDetailViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-12.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLBaseViewController.h"
#import "iRate.h"

@class MZLModelArticle, MZLModelLocationBase, MZLLocationRouteInfo;

@interface MZLArticleDetailViewController : MZLBaseViewController <UIWebViewDelegate, UIScrollViewDelegate, iRateDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *wvArticleContent;
@property (weak, nonatomic) IBOutlet UIView *vwChild;
@property (weak, nonatomic) IBOutlet UIWebView *wvAdVContent;
@property (nonatomic, strong) MZLModelArticle *articleParam;
/** 从目的地详情跳转过来时需要设置该属性 */
@property (nonatomic, strong) MZLModelLocationBase *targetLocation;
@property (nonatomic, strong) NSDate *adViewShowDate;

- (void)onChildViewDisappeared;
- (void)scrollToLocationHeader:(MZLLocationRouteInfo *)locRouteInfo;
//- (void)scrollToLocationHeaderWithLocation:(MZLModelLocationBase *)location;
- (BOOL)shouldShowAdView;

- (void)updateCommentCount:(NSInteger)changeCount;

@end
