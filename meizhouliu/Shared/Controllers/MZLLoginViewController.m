//
//  MZLLoginViewController.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-7-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLoginViewController.h"
#import "UIAlertView+MZLAdditions.h"
#import "MZLSharedData.h"
#import "UIViewController+MZLAdditions.h"
#import <ShareSDK/ShareSDK.h>
#import "UIViewController+MZLRegLoginCommon.h"
#import "UIViewController+MZLModelPresentation.h"
#import "MZLServices.h"
#import "MZLRegisterSinaWeiboSvcParam.h"
#import "MZLRegisterTencentQqSvcParam.h"
#import "MZLRegLoginResponse.h"
#import "MZLServiceResponseDetail.h"
#import "MZLAppUser.h"
#import "MZLLoginSvcParam.h"
#import "MZLRegViewController.h"
#import "MZLRegModifyNameViewController.h"
#import "Reachability.h"
#import <TencentOpenAPI/QQApi.h>
#import "TalkingDataAppCpa.h"
#import "UIBarButtonItem+COAdditions.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "UIView+MZLAdditions.h"
#import <QZoneConnection/ISSQZoneApp.h>
#import <WeChatConnection/WeChatConnection.h>
#import "MZLPhoneRegViewController.h"
#import "MZLPhoneRegNameViewController.h"
#import "MZLPhoneLoginSvcParam.h"
#import "MZLMailLoginView.h"
#import "MZLBindPhoneViewController.h"
#import "MZLAppUser.h"
#import "MZLModifyNameByPhoneViewController.h"
#import "APService.h"
#import "NSString+COValidation.h"

#define LOGIN_BTN_TEXT_NORMAL @"登    录"
#define LOGIN_BTN_TEXT_DISABLED @"登  录  中..."
#define SEGUE_TOMODIFYNAME @"toModifyNameByPhone"
#define SEGUE_TOFORGETPASSWORD @"toForgetPassWord"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface MZLLoginViewController (){
    TencentOAuth *_tencentOAuth;
    NSMutableArray *_permissions;
}


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consVw3rdPartyViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consVw3rdPartyViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnSinaWeiboOAuth;
@property (weak, nonatomic) IBOutlet UIButton *btnTencentQqOAuth;
@property (weak, nonatomic) IBOutlet UIButton *btnWeixinLogin;

@property (weak, nonatomic) MZLMailLoginView *mailLoginView;

@end

@implementation MZLLoginViewController

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
    
    [self initInternal];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dismissKeyboard];
 
//    NSArray *subViewsArr = [UIApplication sharedApplication].keyWindow.subviews;
//    for (int i = 0; i<subViewsArr.count; i++) {
//        NSLog(@"subViewsArr[%d] = %@",i,subViewsArr[i]);
//    }
//    [MZLMailLoginView removeFromCurrentView];
    
    if ([MZLSharedData isAppUserLogined]) { // 从注册界面跳转回来
        
        self.phoneNumTF.text = [MZLSharedData appUser].user.phone;
        self.passWordTF.text = @"somepassword"; // fake password, just for display purpose
        
        [self showLoginProgressIndicator];
    }
    [self hideProgressIndicator];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([SEGUE_TOMODIFYNAME isEqualToString:segue.identifier]) {
//         MZLRegModifyNameViewController *controller = (MZLRegModifyNameViewController *)segue.destinationViewController;
         MZLModifyNameByPhoneViewController *controller = (MZLModifyNameByPhoneViewController *)segue.destinationViewController;
//         controller.token = self.token;
         controller.fromController = self;
         if (sender) {
             MZLLoginType type = [sender[0] integerValue];
             controller.loginType = type;
             controller.errorMessage = sender[1];
         }
     } else if ([MZL_SEGUE_TOREG isEqualToString:segue.identifier]) {
         MZLRegViewController *controller = (MZLRegViewController *)segue.destinationViewController;
         controller.fromController = self;
     }else if ([MZL_SEGUE_TOPHONEREG isEqualToString:segue.identifier]){
         MZLPhoneRegViewController *phoneController = (MZLPhoneRegViewController *)segue.destinationViewController;
         phoneController.fromController = self;
     }else if ([MZL_SEGUE_TOBINDPHONE isEqualToString:segue.identifier]) {
         MZLBindPhoneViewController *bindPhone = (MZLBindPhoneViewController *)segue.destinationViewController;
         bindPhone.token = self.token;
         bindPhone.fromController = self;
     }
//     else if ([MZL_SEGUE_TOPHONEREGNAME isEqualToString:segue.identifier]){
//         MZLPhoneRegNameViewController *name = (MZLPhoneRegNameViewController *)segue.destinationViewController;
//         name.fromVieController = self;
//     }
}


- (void)toModifyNickNameWithType:(MZLLoginType)type message:(NSString *)message {
    NSArray *result = [NSArray arrayWithObjects:@(type),message,nil];
    [self performSegueWithIdentifier:SEGUE_TOMODIFYNAME sender:result];
}

- (void)toPhoneFreeReg {
    [self performSegueWithIdentifier:MZL_SEGUE_TOPHONEREG sender:nil];
}


//- (void)toReg {
//    [self performSegueWithIdentifier:MZL_SEGUE_TOREG sender:nil];
//}
//
//- (void)toPhoneReg {
//    [self performSegueWithIdentifier:MZL_SEGUE_TOPHONEREG sender:nil];
//}

#pragma mark - init methods

- (void)initInternal {
    [self initAuth];
    [self initUI];
    [self initEvents];
}

- (void)initAuth {
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"101141759" andDelegate:self]; //testID = @"222222";
    _permissions = [NSMutableArray arrayWithObjects:
                    kOPEN_PERMISSION_GET_USER_INFO,
                    kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                    nil] ;

}

- (void)initUI {
    if (self.navigationController) {
        // from menu
        self.title = @"登录";
        self.conVwContentTop.constant = 0;
    } else {
        self.conVwContentTop.constant = 45;
        [self initWithStatusBar:self.statusBar navBar:self.navBar];
        // hides back button
        self.navBar.topItem.leftBarButtonItem = nil;
        self.navBar.topItem.hidesBackButton = YES;
    }
    
    switch (self.popupFrom) {
        case MZLLoginPopupFromMenu:
//            [self.btnFavDirect setTitle:@"" forState:UIControlStateNormal];
            self.btnFavDirect.visible = NO;
            break;
        case MZLLoginPopupFromFavoredArticle:
            [self.btnFavDirect setTitle:@"不登录，直接收藏" forState:UIControlStateNormal];
            break;
        case MZLLoginPopupFromInterestedLocation:
            [self.btnFavDirect setTitle:@"不登录，直接想去" forState:UIControlStateNormal];
            break;
        case MZLLoginPopupFromMy:
            [self.btnFavDirect setTitle:@"跳过，暂不登录" forState:UIControlStateNormal];
            break;
        case MZLLoginPopupFromComment:
            [self.btnFavDirect setTitle:@"不登录，直接评论" forState:UIControlStateNormal];
            break;
        case MZLLoginPopupFromShortArticle:
            self.btnFavDirect.visible = NO;
            self.navBar.topItem.rightBarButtonItem = [UIBarButtonItem itemWithSize:CGSizeMake(24.0, 24.0) imageName:@"Short_Article_Close"  target:self action:@selector(skip)];
            break;
        default:
            self.btnFavDirect.visible = NO;
            break;
    }
    
    self.phoneNumTF.tag = TAG_TEXT_USER;
    self.passWordTF.tag = TAG_TEXT_PWD;
    self.passWordTF.secureTextEntry = YES;
    [self initTextFields:@[self.phoneNumTF, self.passWordTF]];
    
    self.imgUser.tag = TAG_IMAGE_USER;
    self.imgPwd.tag = TAG_IMAGE_PWD;
    
    [self initSeparatorView:@[self.sepPwd, self.sepUser]];
    
    [self.btnFavDirect setTitleColor:colorWithHexString(@"#9A9898") forState:UIControlStateNormal];
    
    [self.btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnLogin setBackgroundColor:colorWithHexString(@"#fdd926")]; //f0b80c
    [self.btnLogin setTitle:LOGIN_BTN_TEXT_NORMAL forState:UIControlStateNormal];
    [self.btnLogin setTitle:LOGIN_BTN_TEXT_DISABLED forState:UIControlStateDisabled];
    
    //给免费注册按钮设置颜色
    [self.freePhoneReg setTitleColor:colorWithHexString(@"#e2c251") forState:UIControlStateNormal];
    
    self.vw3rdPartyLogin.backgroundColor = [UIColor clearColor];
    self.consVw3rdPartyViewHeight.constant = 40.0;
//    if (! [QQApi isQQInstalled] && ![WeiboSDK isWeiboAppInstalled] && ![WXApi isWXAppInstalled]) {
//        self.consVw3rdPartyViewTop.constant = 0.0;
//        self.consVw3rdPartyViewHeight.constant = 0.0;
//    } else {
//        UIView *vwCenter = [self.vw3rdPartyLogin createSubView];
//        [vwCenter co_centerParent];
//        NSMutableArray *btns = co_emptyMutableArray();
//        if ([WXApi isWXAppInstalled]) {
//            UIButton *btnWeiXin = [vwCenter createSubViewBtn];
//            [btnWeiXin setBackgroundImage:[UIImage imageNamed:@"Login_Weixin"] forState:UIControlStateNormal];
//            self.btnWeixinLogin = btnWeiXin;
//            [btns addObject:btnWeiXin];
//        }
//        if ([QQApi isQQInstalled]) {
//            UIButton *btnQQ = [vwCenter createSubViewBtn];
//            [btnQQ setBackgroundImage:[UIImage imageNamed:@"Login_QQ"] forState:UIControlStateNormal];
//            self.btnTencentQqOAuth = btnQQ;
//            [btns addObject:btnQQ];
//        }
//        if ([WeiboSDK isWeiboAppInstalled]) {
//            UIButton *btnWeibo = [vwCenter createSubViewBtn];
//            [btnWeibo setBackgroundImage:[UIImage imageNamed:@"Login_Sina"] forState:UIControlStateNormal];
//            self.btnSinaWeiboOAuth = btnWeibo;
//            [btns addObject:btnWeibo];
//        }
//        for (NSInteger i = 0; i < btns.count; i ++) {
//            UIButton *btn = btns[i];
//            [btn co_topParent];
//            [btn co_width:40.0 height:40.0];
//            if (i == 0) {
//                [btn co_leftParent];
//            } else {
//                [btn co_leftFromRightOfPreSiblingWithOffset:12.0];
//            }
//            if (i == btns.count - 1) {
//                [[btn co_rightParent] co_bottomParent];
//            }
//        }
//    }
    
    UIView *vwCenter = [self.vw3rdPartyLogin createSubView];
    [vwCenter co_centerParent];
    NSMutableArray *btns = co_emptyMutableArray();
    
    /* 暂时隐藏微信登陆按钮，等待SDK支持web登陆 */
//    UIButton *btnWeiXin = [vwCenter createSubViewBtn];
//    [btnWeiXin setBackgroundImage:[UIImage imageNamed:@"Login_Weixin"] forState:UIControlStateNormal];
//    self.btnWeixinLogin = btnWeiXin;
//    [btns addObject:btnWeiXin];
    
    
    //判断用户是否已安装微信，若安装了则创建按钮，没有就不创建
    if ([WXApi isWXAppInstalled]) {
        
        UIButton *btnWeiXin = [vwCenter createSubViewBtn];
        [btnWeiXin setBackgroundImage:[UIImage imageNamed:@"Login_Weixin"] forState:UIControlStateNormal];
        self.btnWeixinLogin = btnWeiXin;
        [btns addObject:btnWeiXin];
        
    }

    UIButton *btnQQ = [vwCenter createSubViewBtn];
    [btnQQ setBackgroundImage:[UIImage imageNamed:@"Login_QQ"] forState:UIControlStateNormal];
    self.btnTencentQqOAuth = btnQQ;
    [btns addObject:btnQQ];

    UIButton *btnWeibo = [vwCenter createSubViewBtn];
    [btnWeibo setBackgroundImage:[UIImage imageNamed:@"Login_Sina"] forState:UIControlStateNormal];
    self.btnSinaWeiboOAuth = btnWeibo;
    [btns addObject:btnWeibo];

    for (NSInteger i = 0; i < btns.count; i ++) {
        UIButton *btn = btns[i];
        [btn co_topParent];
        [btn co_width:40.0 height:40.0];
        if (i == 0) {
            [btn co_leftParent];
        } else {
            [btn co_leftFromRightOfPreSiblingWithOffset:12.0];
        }
        if (i == btns.count - 1) {
            [[btn co_rightParent] co_bottomParent];
        }
    }
}

- (void)initEvents {
    [self.vwContent addTapGestureRecognizerToDismissKeyboard];
    
    [self.btnLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.freePhoneReg addTarget:self action:@selector(toPhoneFreeReg) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetPassW addTarget:self action:@selector(toForgetPassWord) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSinaWeiboOAuth addTarget:self action:@selector(onClickSinaWeiboOAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.btnWeixinLogin addTarget:self action:@selector(onClickWeixinOAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTencentQqOAuth addTarget:self action:@selector(onClickTencentOAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.btnFavDirect addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [self.forgetPassW addTarget:self action:@selector(toFindPassWord) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - tip message

- (void)showLoginProgressIndicator {
    [self showNetworkProgressIndicator:@"正在登录中..."];
}

#pragma mark - login

- (BOOL)validateInput {
    if (isEmptyString(self.phoneNumTF.text)) {
        [UIAlertView showAlertMessage:@"请填写手机号码！"];
        return NO;
    }
    if (! [super validateInput]) {
        return NO;
    }
    return YES;
}

- (void)login {
    [self dismissKeyboard];
    if (! [self validateInput]) {
        return;
    }
    [self showLoginProgressIndicator];
    
    MZLPhoneLoginSvcParam *param = [MZLPhoneLoginSvcParam phoneLoginSvcParamWithPhoneNum:self.phoneNumTF.text password:self.passWordTF.text];

    [MZLServices loginByPhoneNumService:param succBlock:^(NSArray *models) {
        
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);

        [self handleRegLoginResponse:result type:MZLLoginTypeNormal];
        
    } errorBlock:^(NSError *error) {
        [self onLoginError];
    }];
}

#pragma mark - skip

- (void)skip {
    [MZLSharedData setLoginRemind];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (self.executionBlockWhenDismissed) {
            self.executionBlockWhenDismissed();
        }
    }];

}

#pragma mark - QQ第三方登录

/*
 如果需要保存授权信息，需要保存登录完成后返回的accessToken，openid 和 expirationDate三个数据，下次登录的时候直接将这三个数据是设置到TencentOAuth对象中即可。
 获得：
 [_tencentOAuth accessToken] ;
 [_tencentOAuth openId] ;
 [_tencentOAuth expirationDate] ;
 设置：
 [_tencentOAuth setAccessToken:accessToken] ;
 [_tencentOAuth setOpenId:openId] ;
 [_tencentOAuth setExpirationDate:expirationDate] ;
 **/

// qq登录
- (void)onClickTencentOAuth {
    if(![QQApi isQQInstalled])
    {
        id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
        [app setIsAllowWebAuthorize:YES];
        [self loginWithShareType:ShareTypeQQSpace];
    }
    else
    {
        if (! [[Reachability reachabilityForInternetConnection] isReachable]) {
            [UIAlertView alertOnNetworkError];
            return;
        }
        [_tencentOAuth authorize:_permissions inSafari:NO];
    }
}

//// qq注销
//- (void)cancelQqOAuth {
//    [_tencentOAuth logout:self];
//}

- (void)getUserInfo {
	if (! [_tencentOAuth getUserInfo]) {
        [self onLoginErrorWithCode:ERROR_CODE_API_INVOKATION_FAILED];
    }
}

#pragma mark - QQ第三方登录 - TencentSessionDelegate

- (void)tencentDidLogin {
	// 登录成功
    if (_tencentOAuth.accessToken
        && 0 != [_tencentOAuth.accessToken length] && 0 != [_tencentOAuth.openId length] && _tencentOAuth.expirationDate)
    {
        [self showLoginProgressIndicator];
        [self saveUser3rdPartyAuthData:@[_tencentOAuth.openId, _tencentOAuth.accessToken, _tencentOAuth.expirationDate]];
        [self getUserInfo];
    }
    else
    {
        [self onLoginErrorWithCode:ERROR_CODE_OAUTH_FAILED];
    }
}

// Called when the get_user_info has response.
- (void)getUserInfoResponse:(APIResponse*) response {
	if (response.retCode == URLREQUEST_SUCCEED)
	{
        NSString *nickName = [response.jsonResponse objectForKey:@"nickname"];
        NSString *photo = [response.jsonResponse objectForKey:@"figureurl_qq_1"];
        [self saveUser3rdPartyNickName:nickName imageUrl:photo];
        [self loginWithQQ];
	}
	else
    {
		[self onLoginError];
	}
}

- (void)loginWithQQ {
    [MZLServices loginByTencentQqServiceWithOpenId:[MZLSharedData appUser].openIdFrom3rdParty succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        if (result.error == MZL_RL_RCODE_USER_NOTEXIST) { // 不存在账号，注册
            [self regWithQQ];
        } else {
            [self handleRegLoginResponse:result type:MZLLoginTypeQQ];
        }
    } errorBlock:^(NSError *error) {
        [self onLoginError];
    }];
}

- (void)regWithQQ {
    MZLRegisterTencentQqSvcParam *params = [MZLRegisterTencentQqSvcParam instance];
    [MZLServices registerByTencentQqService:params succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        [self handle3rdPartyRegResponse:result type:MZLLoginTypeQQ];
    } errorBlock:^(NSError *error) {
        [self onLoginError];
    }];
}

// Called when the user dismissed the dialog without logging in.
- (void)tencentDidNotLogin:(BOOL)cancelled {
}

// Called when the notNewWork.
-(void)tencentDidNotNetWork {}

// Called when the logout.
-(void)tencentDidLogout {}

#pragma mark - 三方登录, ShareSDK 通用

- (void)loginWithShareType:(ShareType)type {
    [ShareSDK authWithType:type options:nil result:^(SSAuthState state, id<ICMErrorInfo> error) {
        if (state == SSAuthStateSuccess) {
            id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:type];
            
            if (! credential) {
                return;
            }
       
            [self showLoginProgressIndicator];
            
            [self saveUser3rdPartyAuthData:@[[credential uid], [credential token], [credential expired]]];
            [self getUserInfoWithShareType:type];
        } else if (state == SSAuthStateFail) {
            [self onLoginErrorWithCode:ERROR_CODE_OAUTH_FAILED];
        } else {
            // cancel, do nothing
        }
    }];
}

- (void)getUserInfoWithShareType:(ShareType)type {
    [ShareSDK getUserInfoWithType:type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            
            [self saveUser3rdPartyNickName:[userInfo nickname] imageUrl:[userInfo profileImage]];
            MZLLoginType loginType = [self loginTypeFromShareType:type];
            [self login:loginType];
        } else {
            [self onLoginErrorWithCode:ERROR_CODE_USER_INFO_NOT_ACCQUIRED];
        }
    }];
}

- (void)login:(MZLLoginType)type {
    [MZLServices loginBy3rdPartyWithType:type openId:[MZLSharedData appUser].openIdFrom3rdParty succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        if (result.error == MZL_RL_RCODE_USER_NOTEXIST) { // openId不存在，注册
            [self reg:type];
        } else {
            [self handleRegLoginResponse:result type:type];
        }
    } errorBlock:^(NSError *error) {
        [self onLoginError];
    }];
}

- (void)reg:(MZLLoginType)type {
    MZLRegister3rdPartySvcParam *params = [MZLRegister3rdPartySvcParam instance];
    
    //给昵称做一次判断
    if(![self judgmentNickName:params.nickName]) {
        return;
    }
    
    [MZLServices registerServiceWithType:type param:params succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        [self handle3rdPartyRegResponse:result type:type];
    } errorBlock:^(NSError *error) {
        [self onLoginError];
    }];
}

- (MZLLoginType)loginTypeFromShareType:(ShareType)type {
    switch (type) {
        case ShareTypeQQSpace:
            return MZLLoginTypeQQ;
            break;
        case ShareTypeWeixiSession:
            return MZLLoginTypeWeiXin;
            break;
        case ShareTypeSinaWeibo:
            return MZLLoginTypeSinaWeibo;
            break;
        default:
            return MZLLoginTypeNormal;
            break;
    }
}

#pragma mark - 微信第三方登录

- (void)onClickWeixinOAuth {
    [self loginWithShareType:ShareTypeWeixiSession];
//    [ShareSDK authWithType:ShareTypeWeixiSession options:nil result:^(SSAuthState state, id<ICMErrorInfo> error) {
//        if (state == SSAuthStateSuccess) {
//            id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeWeixiSession];
//            if (! credential) {
//                return;
//            }
//            [self showLoginProgressIndicator];
//            [self saveUser3rdPartyAuthData:@[[credential uid], [credential token], [credential expired]]];
//            [self getUserInfoFromWeixin];
//        } else if (state == SSAuthStateFail) {
//            [self onLoginErrorWithCode:ERROR_CODE_OAUTH_FAILED];
//        } else {
//            // cancel, do nothing
//        }
//    }];
}

//- (void)getUserInfoFromWeixin {
//    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//        if (result) {
//            [self saveUser3rdPartyNickName:[userInfo nickname] imageUrl:[userInfo profileImage]];
//            [self loginWithWeixin];
//        } else {
//            [self onLoginErrorWithCode:ERROR_CODE_USER_INFO_NOT_ACCQUIRED];
//        }
//    }];
//}
//
//- (void)loginWithWeixin {
//    [MZLServices loginByWeiXinServiceWithOpenId:[MZLSharedData appUser].openIdFrom3rdParty succBlock:^(NSArray *models) {
//        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
//        if (result.error == MZL_RL_RCODE_USER_NOTEXIST) { // openId不存在，注册
//            [self regWithWeixin];
//        } else {
//            [self handleRegLoginResponse:result type:MZLLoginTypeWeiXin];
//        }
//    } errorBlock:^(NSError *error) {
//        [self onLoginError];
//    }];
//}
//
//- (void)regWithWeixin {
//    MZLRegister3rdPartySvcParam *params = [MZLRegister3rdPartySvcParam instance];
//    [MZLServices registerByWeixinService:params succBlock:^(NSArray *models) {
//        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
//        [self handle3rdPartyRegResponse:result type:MZLLoginTypeWeiXin];
//    } errorBlock:^(NSError *error) {
//        [self onLoginError];
//    }];
//}

#pragma mark - 微博第三方登录

- (void)onClickSinaWeiboOAuth {
    [self loginWithShareType:ShareTypeSinaWeibo];
//    [ShareSDK authWithType:ShareTypeSinaWeibo options:nil result:^(SSAuthState state, id<ICMErrorInfo> error) {
//        if (state == SSAuthStateSuccess) {
//            id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
//            if (! credential) { // 用户选择了取消，新浪SSO接口无法区分cancel与success
//                return;
//            }
//            [self showLoginProgressIndicator];
//            [self saveUser3rdPartyAuthData:@[[credential uid], [credential token], [credential expired]]];
//            [self getUserInfoFromSinaWeibo];
//        } else if (state == SSAuthStateFail) {
//            [self onLoginErrorWithCode:ERROR_CODE_OAUTH_FAILED];
//        } else {
//            // cancel, do nothing
//        }
//    }];
}

//- (void)getUserInfoFromSinaWeibo {
//    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//        if (result) {
//            
////            [ShareSDK currentAuthUserWithType:ShareTypeSinaWeibo];
////            [ShareSDK setCurrentAuthUser:userInfo type:ShareTypeSinaWeibo];
//            [self saveUser3rdPartyNickName:[userInfo nickname] imageUrl:[userInfo profileImage]];
//            [self loginWithSinaWeibo];
//        } else {
//            [self onLoginErrorWithCode:ERROR_CODE_USER_INFO_NOT_ACCQUIRED];
//        }
//    }];
//}
//
//- (void)loginWithSinaWeibo {
//    [MZLServices loginBySinaWeiboServiceWithOpenId:[MZLSharedData appUser].openIdFrom3rdParty succBlock:^(NSArray *models) {
//        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
//        if (result.error == MZL_RL_RCODE_USER_NOTEXIST) { // openId不存在，注册
//            [self regWithSinaWeibo];
//        } else {
//            [self handleRegLoginResponse:result type:MZLLoginTypeSinaWeibo];
//        }
//    } errorBlock:^(NSError *error) {
//        [self onLoginError];
//    }];
//}
//
//- (void)regWithSinaWeibo {
//    MZLRegisterSinaWeiboSvcParam *params = [MZLRegisterSinaWeiboSvcParam instance];
//    [MZLServices registerBySinaWeiboService:params succBlock:^(NSArray *models) {
//        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
//        [self handle3rdPartyRegResponse:result type:MZLLoginTypeSinaWeibo];
//    } errorBlock:^(NSError *error) {
//        [self onLoginError];
//    }];
//}
//
//- (void)cancelSinaWeiboOAuth{
//    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
//}

#pragma mark - helper methods

- (void)saveUser3rdPartyAuthData:(NSArray *)authData {
    MZLAppUser *user = [MZLSharedData appUser];
    user.openIdFrom3rdParty = authData[0];
    user.tokenFrom3rdParty = authData[1];
    user.expirationDateFrom3rdParty = authData[2];
}

- (void)saveUser3rdPartyNickName:(NSString *)name imageUrl:(NSString *)imageUrl {
    MZLAppUser *user = [MZLSharedData appUser];
    
//    //自己将name及imageUrl转成UTF8类型
//    user.nickNameFrom3rdParty = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    user.imageUrlFrom3rdParty = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    user.nickNameFrom3rdParty = name;
    user.imageUrlFrom3rdParty = imageUrl;
}

- (void)saveUserAndToken:(MZLRegLoginResponse *)response {
    [[MZLSharedData appUser] setUser:response.user token:response.accessToken];
}


#pragma mark - error related

- (void)onLoginError {
    [self onLoginErrorWithCode:ERROR_CODE_NETWORK];
}

- (void)onLoginErrorWithCode:(NSInteger)errorCode {
    [self hideProgressIndicator];
    NSString *message = [NSString stringWithFormat:@"登录失败，请稍后重试！(code=%@)", @(errorCode)];
    [UIAlertView showAlertMessage:message];
}

#pragma mark - handle response

- (void)handle3rdPartyRegResponse:(MZLRegLoginResponse *)response type:(MZLLoginType)type {
    [self hideProgressIndicator:NO];
    if (response.error == MZL_RL_RCODE_USER_ALREADY_EXIST) {
        [UIAlertView showAlertMessage:response.errorMessage];
        [self toModifyNickNameWithType:type message:response.errorMessage ];
    } else {
        [self handleRegLoginResponse:response type:type];
    }
}

- (void)handleRegLoginResponse:(MZLRegLoginResponse *)response type:(MZLLoginType)type {
    [self hideProgressIndicator:NO];
    
    if (response.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
        [self saveUserAndToken:response];
        
        if (![response.user.bind isEqualToString:@"true"]) {
            self.token = response.accessToken.token;
            [self performSegueWithIdentifier:MZL_SEGUE_TOBINDPHONE sender:nil];
            return ;
        }
        
        //给服务器进行极光的注册
        [MZLServices registerJpushWithUser];
        
        //给服务器注册度周末的产品userToken
        [MZLServices getDuzhoumoUserToken];
        
        [self onLogined:type];
        [self dismissCurrentViewController:self.executionBlockWhenDismissed];
        [TalkingDataAppCpa onLogin:response.accessToken.token];
    } else if (response.error == MZL_RL_RCODE_GENERAL_ERROR) { // 错误码-1
        [UIAlertView showAlertMessage:response.errorMessage];
    } else if (response.error == MZL_RL_RCODE_TOKEN_NOTACCQUIRED) { // server端token获取失败
        [self onLoginErrorWithCode:ERROR_CODE_SERVER_TOKEN_ISSUE];
    } else if (! isEmptyString(response.errorMessage)) { // 其它server返回的错误
        [UIAlertView showAlertMessage:response.errorMessage];
    } else { // 不明错误
        [self onLoginErrorWithCode:ERROR_CODE_LOGIN_FAILED];
    }
}


- (IBAction)loginByMail:(id)sender {

    self.mailLoginView = [MZLMailLoginView mailLoginViewInstance];
    [self.mailLoginView.mailLoginBtn addTarget:self action:@selector(tologinText) forControlEvents:UIControlEventTouchUpInside];
    [self.mailLoginView.mailForgetPassWord addTarget:self action:@selector(toForgetPassWord) forControlEvents:UIControlEventTouchUpInside];
    [self.mailLoginView.phoneLoginInMailView addTarget:self action:@selector(tologinTextByphone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mailLoginView];
    
    [UIView animateWithDuration:0.3 animations:^{
       self.mailLoginView.frame = CGRectMake(0, 65 , SCREENWIDTH, SCREENHEIGHT - 64);
    } completion:^(BOOL finished) {
        self.mailLoginView.phoneLoginInMailView.enabled = YES;
    }];
    
    
}

- (void)tologinTextByphone {

    [UIView animateWithDuration:0.3 animations:^{
        self.mailLoginView.phoneLoginInMailView.enabled = NO;
        self.mailLoginView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    } completion:^(BOOL finished) {
        self.mailLoginView.phoneLoginInMailView.enabled = NO;
    }];
}

- (void)tologinText {

    [self dismissKeyboard];
    if (! [self validateInputMail]) {
        return;
    }
    [self showLoginProgressIndicator];
    MZLLoginSvcParam *param = [MZLLoginSvcParam loginSvcParamWithname:self.mailLoginView.mailOrNameTF.text password:self.mailLoginView.passWordTF.text];
    [MZLServices loginByNormalService:param succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        
        [self handleRegLoginResponse:result type:MZLLoginTypeNormal];
    } errorBlock:^(NSError *error) {
        [self onLoginError];
    }];
}


#pragma mark - 判断昵称用的
- (BOOL)judgmentNickName:(NSString *)name {
    NSInteger strLen = [name lengthUsingCustomRule];
    BOOL isValidLen = strLen >=4 && strLen <= 30;
    if (! isValidLen) {
        [self hideProgressIndicator];
        [UIAlertView showAlertMessage:@"昵称长度为4-30个字符（2-15个汉字）哦!"];
        return NO;
    }
    if (! [self isjudgmentNickname:name]) {
        [self hideProgressIndicator];
        [UIAlertView showAlertMessage:@"昵称只支持中英文和数字哦!"];
        return NO;
    }
    return YES;
}

- (BOOL)isjudgmentNickname:(NSString *)str {
    return [str isValidViaRegExp:@"^[\u4e00-\u9fa5_a-zA-Z0-9]+$"];
}

#pragma mark - login

- (BOOL)validateInputMail {
    if (isEmptyString(self.mailLoginView.mailOrNameTF.text)) {
        [UIAlertView showAlertMessage:@"请填写昵称或邮箱！"];
        return NO;
    }
    return YES;
}

- (void)toForgetPassWord {
    [self performSegueWithIdentifier:SEGUE_TOFORGETPASSWORD sender:nil];
}

- (void)dealloc {

    MZLLog(@"登入界面消失了");
}


@end

#pragma mark - login remind

// 7 days for remind interval
#define LOGIN_REMIND_INTERVAL (7.0 * 24 * 3600)

BOOL shouldRemindLogin() {
    NSDate *loginRemindDateTime = [MZLSharedData loginRemindDateTime];
    if (! loginRemindDateTime) {
        return YES;
    }
    NSDate *now = [NSDate date];
    if ([now timeIntervalSinceDate:loginRemindDateTime] >= LOGIN_REMIND_INTERVAL) {
        return YES;
    }
    return NO;
}

BOOL shouldPopupLogin() {
    // 未登录且需要提醒
    if (! [MZLSharedData isAppUserLogined] &&  shouldRemindLogin()) {
        return YES;
    }
    return NO;
}
