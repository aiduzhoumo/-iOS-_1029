//
//  MZLNoticeDetailViewController.m
//  mzl_mobile_ios
//
//  Created by race on 14-9-6.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLAppNotices.h"
#import "MZLModelNotice.h"
#import "MZLNoticeDetailViewController.h"
#import "UIViewController+MZLAdditions.h"

#define MZL_NOTICE_REQUEST_URL @"http://www.meizhouliu.com/notices/%@"

@interface MZLNoticeDetailViewController ()

@end

@implementation MZLNoticeDetailViewController

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
    [self checkAppMessage];
    [self initWeb];
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

- (void)initWeb {
    self.wvNoticeContent.backgroundColor = MZL_BG_COLOR();
    self.wvNoticeContent.delegate = self;
    NSString *_webUrl = [NSString stringWithFormat:MZL_NOTICE_REQUEST_URL,@(self.noticeParam.identifier)];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: webUrl(_webUrl)];
    [self showNetworkProgressIndicator];
    [self.wvNoticeContent loadRequest:request];
}


#pragma mark - web view delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self onWebViewLoadError];
}

- (void)onWebViewLoadError {
    [self onNetworkError];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideProgressIndicator];
}

#pragma mark - update app notice list

- (void)checkAppMessage {
    if (! [MZLAppNotices hasMessage:self.noticeParam]) {
        self.noticeParam.isRead = YES;
        [MZLAppNotices addMessage:self.noticeParam];
    } else {
        if (! self.noticeParam.isRead) {
            [MZLAppNotices setReadFlagOnMessage:self.noticeParam];
        }
    }
}

@end
