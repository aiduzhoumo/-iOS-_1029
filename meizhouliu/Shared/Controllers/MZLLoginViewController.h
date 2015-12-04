//
//  MZLLoginViewController.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-7-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TencentOpenAPI/TencentOAuth.h"
#import "MZLBaseViewController.h"

typedef NS_ENUM(NSInteger, MZLLoginPopupFrom) {
    MZLLoginPopupFromMenu = 0,
    MZLLoginPopupFromFavoredArticle   = 1,
    MZLLoginPopupFromInterestedLocation  = 2,
    MZLLoginPopupFromMy   = 3,
    MZLLoginPopupFromComment = 4,
    MZLLoginPopupFromShortArticle = 5
};

BOOL shouldPopupLogin();

@interface MZLLoginViewController : MZLBaseViewController <TencentSessionDelegate, UITextFieldDelegate> 

@property (weak, nonatomic) IBOutlet UIView *vwContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;

@property (weak, nonatomic) IBOutlet UIView *sepUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgPwd;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;

@property (weak, nonatomic) IBOutlet UIView *sepPwd;
@property (weak, nonatomic) IBOutlet UIView *vw3rdPartyLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UIButton *btnFavDirect;
@property (weak, nonatomic) IBOutlet UIView *statusBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conVwContentTop;

@property (weak, nonatomic) IBOutlet UIButton *freePhoneReg;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassW;

- (IBAction)loginByMail:(id)sender;

@property (copy, nonatomic) NSString *token;

@property (nonatomic, assign) MZLLoginPopupFrom popupFrom;
@property (nonatomic, copy) CO_BLOCK_VOID executionBlockWhenDismissed;

@end
