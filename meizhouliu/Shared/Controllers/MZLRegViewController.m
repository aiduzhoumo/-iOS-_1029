//
//  MZLRegViewController.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-6.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLRegViewController.h"
#import "UIViewController+MZLModelPresentation.h"
#import "UIViewController+MZLRegLoginCommon.h"
#import "MZLServices.h"
#import "MZLRegisterNormalSvcParam.h"
#import "MZLRegLoginResponse.h"


@interface MZLRegViewController ()

@end

@implementation MZLRegViewController

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

- (void)initUI {
    
    [self.txtEmail setTag:TAG_TEXT_EMAIL];
    [self.txtUser setTag:TAG_TEXT_USER];
    [self.txtPwd setTag:TAG_TEXT_PWD];
    self.imgUser.tag = TAG_IMAGE_USER;
    self.imgEmail.tag = TAG_IMAGE_EMAIL;
    self.imgPwd.tag = TAG_IMAGE_PWD;
    
    self.txtEmail.keyboardType = UIKeyboardTypeEmailAddress;
    [self initTextFields:@[self.txtEmail, self.txtUser, self.txtPwd]];
    [self initSeparatorView:@[self.sepEmail, self.sepUser, self.sepPwd]];
    
    [self.btnReg setBackgroundColor:colorWithHexString(@"#fdd926")];
}

- (void)initEvents {
    [self.vwContent addTapGestureRecognizerToDismissKeyboard];
    
    [self.btnReg addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - register

- (void)registerUser {
    [self dismissKeyboard];
    if (! [self validateInput]) {
        return;
    }
    MZLRegisterNormalSvcParam *param = [MZLRegisterNormalSvcParam instance];
    param.email = self.txtEmail.text;
    param.nickName = self.txtUser.text;
    param.password = self.txtPwd.text;
    [self showRegProgressIndicator];
    [MZLServices registerByNormalService:param succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        [self handleRegResponse:result type:MZLLoginTypeNormal];
    } errorBlock:^(NSError *error) {
        
        [self onRegError];
    }];
}

#pragma mark - validation 

- (BOOL)validateInput {
    if (! [super validateInput]) {
        return NO;
    }
    if (! [self verifyEmail:self.txtEmail] || ! [self verifyNickName:self.txtUser] || ! [self verifyPassword:self.txtPwd]) {
        return NO;
    }
    return YES;
}


@end
