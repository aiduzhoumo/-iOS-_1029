//
//  MZLRegModifyNameViewController.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-6.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLRegModifyNameViewController.h"
#import "UIViewController+MZLModelPresentation.h"
#import "UIViewController+MZLRegLoginCommon.h"
#import "MZLServices.h"
#import "MZLRegisterSinaWeiboSvcParam.h"
#import "MZLRegisterTencentQqSvcParam.h"
#import "MZLSharedData.h"
#import "MZLAppUser.h"
#import "UIImageView+MZLNetwork.h"

@interface MZLRegModifyNameViewController ()

@end

@implementation MZLRegModifyNameViewController

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
//    //键盘升起
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [self initWithStatusBar:self.statusBar navBar:self.navBar];
    [self initInternal];
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

#pragma mark - init 

- (void)initInternal {
    [self initUI];
    [self initEvents];
}

- (void)initEvents {
    [self.vwContent addTapGestureRecognizerToDismissKeyboard];
    [self.btnChange addTarget:self action:@selector(modifyNickName) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initUI {
    [self.imgHead toRoundShape];
    [self.imgHead setBackgroundColor:colorWithHexString(@"#5c5c5c")];
    [self.btnChange setBackgroundColor:colorWithHexString(@"#fdd926")];
    [self.lblTips setTextColor:colorWithHexString(@"#b2b2b2")];
    
    MZLAppUser *user = [MZLSharedData appUser];
    NSString *errorMessage = @"该昵称不可用，换一个更霸气的名字吧~";
    [self.lblTips setText:errorMessage];
    self.txtNickName.tag = TAG_TEXT_USER;
    self.txtNickName.text = user.nickNameFrom3rdParty;
    self.imgUser.tag = TAG_IMAGE_USER;
    
    [self.imgHead loadUserImageFromURL:user.imageUrlFrom3rdParty];
    [self initTextFields:@[self.txtNickName]];
    [self initSeparatorView:@[self.sepNickSep]];
}

#pragma mark - validation

- (BOOL)validateInput {
    if (! [super validateInput]) {
        return NO;
    }
    if (! [self verifyNickName:self.txtNickName]) {
        return NO;
    }
    return YES;
}

#pragma mark - modify nick name

- (void)modifyNickName{
    [self dismissKeyboard];
    if (! [self validateInput]) {
        return;
    }
    MZLAppUser *user = [MZLSharedData appUser];
    user.nickNameFrom3rdParty = self.txtNickName.text;
    [self showRegProgressIndicator];
//    [self reg];
    if (self.loginType == MZLLoginTypeSinaWeibo) {
        [self regWithSinaWeibo];
    } else if(self.loginType == MZLLoginTypeQQ){
        [self regWithQQ];
    } else {
        [self regWithWechat];
    }
}

#pragma mark - reg

- (void)reg {
    MZLRegisterBaseSvcParam *params = [MZLRegisterBaseSvcParam instance];
    [MZLServices registerServiceWithType:self.loginType param:params succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        [self handleRegResponse:result type:self.loginType];
    } errorBlock:^(NSError *error) {
        [self onRegError];
    }];
}

- (void)regWithWechat{
    
    MZLRegister3rdPartySvcParam *params = [MZLRegister3rdPartySvcParam instance];
    [MZLServices registerByWeixinService:params succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        [self handleRegResponse:result type:MZLLoginTypeWeiXin];
    } errorBlock:^(NSError *error) {
        [self onRegError];
    }];
    
}

- (void)regWithSinaWeibo {
    MZLRegisterSinaWeiboSvcParam *params = [MZLRegisterSinaWeiboSvcParam instance];
    [MZLServices registerBySinaWeiboService:params succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        [self handleRegResponse:result type:MZLLoginTypeSinaWeibo];
    } errorBlock:^(NSError *error) {
        [self onRegError];
    }];
}

- (void)regWithQQ {
    MZLRegisterTencentQqSvcParam *params = [MZLRegisterTencentQqSvcParam instance];
    [MZLServices registerByTencentQqService:params succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        [self handleRegResponse:result type:MZLLoginTypeQQ];
    } errorBlock:^(NSError *error) {
        [self onRegError];
    }];
}

@end
