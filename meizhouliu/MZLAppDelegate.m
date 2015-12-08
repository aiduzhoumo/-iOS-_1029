//
//  MZLAppDelegate.m
//  meizhouliu
//
//  Created by Whitman on 14-4-2.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLAppDelegate.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <ShareSDK/ShareSDK.h>
#import "iRate.h"
#import "MZLDummyObject.h"
#import "JDStatusBarNotification.h"
#import "MobClick.h"
#import "MZLServices.h"
#import "MZLiVersionDelegate.h"
#import "MZLSharedData.h"
#import "WeiboSDK.h"
#import "MZLLoginViewController.h"
#import "MZLUserDetailResponse.h"
#import "MZLModelUser.h"
#import "MZLAppUser.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "NSObject+UmengNotification.h"
#import "MZLModelArticle.h"
#import "MZLModelLocationBase.h"
#import "MZLModelNotice.h"
#import "MZLArticleDetailViewController.h"
#import "MZLLocationDetailViewController.h"
#import "MZLNoticeDetailViewController.h"
#import "MZLShortArticleDetailVC.h"
#import "MZLAppNotices.h"
#import "TalkingDataAppCpa.h"
#import <AdSupport/AdSupport.h>
#import "MZLImageGalleryNavigationController.h"
#import "NSObject+COAppDelegateForNotification.h"
#import "MZLShortArticleDetailVC.h"
#import "MZLModelShortArticle.h"
#import <TuSDK/TuSDK.h>

#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

@interface MZLAppDelegate () {
    BOOL _shouldInvokeEventsWhenActive;
}

@end

@implementation MZLAppDelegate


+ (void)initialize {
    [self initiRate];
}

#pragma mark - application life cycle

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if (launchOptions != nil) {
        NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (notification != nil) {
            [MZLSharedData setApnsInfo:notification];
        }
    }
    
    [self co_registerNotification];

    [self internalInit];
    
    [self servicesOnStartup];
    
//    [MZLDummyObject test];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [MZLSharedData stopLocationTimer];
    [MZLSharedData stopAllLocationService];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    // refresh location
    _shouldInvokeEventsWhenActive = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (_shouldInvokeEventsWhenActive) {
        _shouldInvokeEventsWhenActive = NO;
        [MZLSharedData startLocationService];
        [self checkAppMessages];
        [[self currentVisibleViewController] mzl_viewControllerBecomeActiveFromBackground];
        return;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
// 重写AppDelegate的handleOpenURL
- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url {
    return [self isMeizhouliuSchema:url] || [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}
 */


// 重写openURL方法：
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    _shouldInvokeEventsWhenActive = NO;
//    if ([self isSinaWeiboSchema:url]) {
//        return [WeiboSDK handleOpenURL:url delegate:[MZLLoginViewController sharedInstance]];
//    }
    if ([self isTencentQqSchema:url]) {
         return [TencentOAuth HandleOpenURL:url];
    }
    if ([self isMeizhouliuSchema:url]) {
        return YES;
    }
    
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - schema related

- (BOOL)isMeizhouliuSchema:(NSURL *)url {
    return [[url scheme] isEqualToString:MZL_APP_SCHEME];
}

- (BOOL)isSinaWeiboSchema:(NSURL *)url {
    return [[url scheme] isEqualToString:MZL_SINAWEIBO_SCHEME];
}

- (BOOL)isTencentQqSchema:(NSURL *)url {
    return [[url scheme] isEqualToString:MZL_TENCENT_SCHEME];
}

#pragma mark - init methods

- (void)internalInit {
    [self initTuSDK];
    [self initUmeng];
    [self initShareSDK];
    [self initAMapSearch];
    [self initTalkingDataAppCpa];
    [self initUMtrack];
    
    [self initData];
    
    [self initNavigationBar];
    [self initTabBarController];
    [self initJDStatusBar];
}

- (void)initData {
    [MZLSharedData loadAppUserFromCache];
    [MZLSharedData loadLocationFromCache];
    [MZLSharedData loadSystemLocations];
    [MZLAppNotices loadNoticesFromCache];
}

- (void)initAMapSearch {
    if (isMZLProdApp()) {
        //Bundle Identifier :com.meizhouliu.ios
        [MZLSharedData setSearchWithApiKey:@"c6351940a42dd4c8606e8577e0a76882"];
    } else {
        //Bundle Identifier :com.meizhouliu.adhoc
        [MZLSharedData setSearchWithApiKey:@"2af358067796cf96eff8bd94b59d33f9"];
    }
}

- (void)initShareSDK {
    if (isMZLProdApp()) {
        //美周六 sharesdk app_key
        [ShareSDK registerApp:@"1a478eb11888"];
    } else {
        //测试 sharesdk app_key
        [ShareSDK registerApp:@"2468eaecb318"];
    }
    
    //添加微信应用
    [ShareSDK connectWeChatWithAppId:@"wx9f26cfd28169b735"        //此参数为申请的微信AppID
                           wechatCls:[WXApi class]];
    
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"wb3269398598"
                               appSecret:@"4d48ff44147a02c17cbc10095786d0a8"//4d48ff44147a02c17cbc10095786d0a8
                             redirectUri:@"http://www.meizhouliu.com"];
    
    //添加QQ好友
//    [ShareSDK connectQQWithQZoneAppKey:@"101141759"                 //该参数填入申请的QQ AppId
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"1104934010"                 //该参数填入申请的QQ AppId
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    

    
    
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:@"101141759"
                           appSecret:@"653d3aa85c7322e3fb5f41f4a58807ba"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];

    
//    //添加腾讯微博应用
//    [ShareSDK connectTencentWeiboWithAppKey:@"801520494"
//                                  appSecret:@"653d3aa85c7322e3fb5f41f4a58807ba"
//                                redirectUri:@"http://www.meizhouliu.com"];
//    
//    //添加豆瓣应用
//    [ShareSDK connectDoubanWithAppKey:@"064d0c84b01c49f812e7258e1054dde8"
//                            appSecret:@"8b744be28cd675b9"
//                          redirectUri:@"http://www.meizhouliu.com"];
//    
//    //添加印象笔记应用
//    [ShareSDK connectEvernoteWithType:SSEverNoteTypeSandbox
//                          consumerKey:@"dev-mzl"
//                       consumerSecret:@"f9c2d9ee51cb3321"];
    
}

- (void)initTalkingDataAppCpa {
    [TalkingDataAppCpa init:@"6ffb1f36c0274cb486d8c6c5b851c588" withChannelId:MZL_APP_CHANNEL_ID_APP_STORE];
}

- (void)initUMtrack {
    if (isMZLProdApp()) {
        NSString * appKey = @"53995e3d56240b395f012eef";
        NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * mac = [self macString];
        NSString * idfa = [self idfaString];
        NSString * idfv = [self idfvString];
        NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", appKey, deviceName, mac, idfa, idfv];
        [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];
    }
}

- (void)initUmeng {
    if (isMZLProdApp()) {
        [MobClick startWithAppkey:@"53995e3d56240b395f012eef" reportPolicy:SEND_INTERVAL channelId:MZL_APP_CHANNEL_ID_APP_STORE];
        
        //设置version标识
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
        

#ifdef MZL_DEBUG
        [MobClick setLogEnabled:YES];
#endif
    }
}

//- (void)initWeibo{
//    [WeiboSDK enableDebugMode:YES];
//    [WeiboSDK registerApp:@"3269398598"];
//}


- (void)initNavigationBar {
    [[UINavigationBar appearance] setBarTintColor:MZL_NAVBAR_BG_COLOR()];
    [[UINavigationBar appearance] setTintColor:MZL_NAVBAR_TINT_COLOR()];
//    [[UINavigationBar appearance] setBackgroundImage:MZL_NAVBAR_BG_IMAGE() forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    NSDictionary *titleAttributes = @{
                                      NSForegroundColorAttributeName : MZL_NAVBAR_TITLE_COLOR(),
                                      NSFontAttributeName : MZL_NAVBAR_TITLE_FONT()
                                      };
    
    [[UINavigationBar appearance] setTitleTextAttributes: titleAttributes];
}

- (void)initTabBarController {
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
}

+ (void)initiRate {
    [iRate sharedInstance].promptAtLaunch = NO;
    [iRate sharedInstance].usesUntilPrompt = 0;
    [iRate sharedInstance].daysUntilPrompt = 0;
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    [iRate sharedInstance].promptForNewVersionIfUserRated = YES;
    [iRate sharedInstance].message = MZL_IRATE_ALERT_MESSAGE;
    [iRate sharedInstance].updateMessage = MZL_IRATE_ALERT_UPDATE_MESSAGE;
    
}

- (void)initJDStatusBar {
    [JDStatusBarNotification addStyleNamed:MZL_JDSTATUSBAR_STYLE1
                                   prepare:^JDStatusBarStyle*(JDStatusBarStyle *style) {
                                       
                                       // main properties
                                       style.barColor = colorWithHexString(@"#fdd414");
                                       style.textColor = [UIColor whiteColor];
                                       
                                       return style;
                                   }];
}

#pragma mark - start up service

- (void)servicesOnStartup {
    [self checkAppMessages];
    
    [MZLServices heartbeatOnAppStartup];
    [MZLServices filtersListService];
    [MZLServices keywordsService];
    [MZLServices tagsService];
    [MZLServices checkSystemLocations];
    [self refreshLoginedUserInfo];
    [MZLSharedData startLocationService];
    
    // 友盟广告service需要先初始化友盟服务
    [MZLServices youmengAdUrlService];
}

- (void)refreshLoginedUserInfo {
    // 刷新userInfo，如果已登录，避免当从用户升级到作者时在我的界面看不到自己的文章
    if ([MZLSharedData isAppUserLogined]) {
        [MZLServices userInfoServiceWithSuccBlock:^(NSArray *models) {
            MZLModelUser *user = ((MZLUserDetailResponse *)models[0]).user;
            MZLAppUser *appUser = [MZLSharedData appUser];
            appUser.user = user;
            [appUser saveInPreference];
            
        } errorBlock:^(NSError *error) {
            // ignore error...
        }];
    }
}

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super init]) {
//       [MZLSharedData appUser].user.level = [[aDecoder decodeObjectForKey:@"KEY_USER_LEVEL"] integerValue];
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//     [aCoder encodeObject:@([MZLSharedData appUser].user.level) forKey:@"KEY_USER_LEVEL"];;
//}

#pragma mark - remote notification delegate

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
//    [UMessage didReceiveRemoteNotification:userInfo];
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground ||
       [UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        _shouldInvokeEventsWhenActive = NO;
        if(userInfo != nil) {
            UIViewController *vc = [self currentVisibleViewController];
            UIStoryboard *sb = MZL_MAIN_STORYBOARD();
            UIViewController *targetVc;
            //article 不为空，跳转到指定文章
            if (!isEmptyString([[userInfo valueForKey:@"article"] valueForKey:@"id"])) {
                MZLModelArticle *article = [[MZLModelArticle alloc] init];
                article.identifier = [[[userInfo valueForKey:@"article"] valueForKey:@"id"] intValue];
                MZLArticleDetailViewController * vcArticleDetail = (MZLArticleDetailViewController *) [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MZLArticleDetailViewController class])];
                vcArticleDetail.articleParam = article;
                targetVc = vcArticleDetail;
            }
            //destination 不为空 跳到指定目的地
            else if(!isEmptyString([[userInfo valueForKey:@"destination"] valueForKey:@"id"])) {
                MZLModelLocationBase *location = [[MZLModelLocationBase alloc] init];
                location.identifier = [[[userInfo valueForKey:@"destination"] valueForKey:@"id"] intValue];
                MZLLocationDetailViewController * vcLocationDetail = (MZLLocationDetailViewController *) [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MZLLocationDetailViewController class])];
                vcLocationDetail.locationParam = location;
                targetVc = vcLocationDetail;
            }
            // 跳转个人通知
            else if(!isEmptyString([[userInfo valueForKey:@"notice"] valueForKey:@"id"])) {
                MZLModelNotice *notice = [[MZLModelNotice alloc] init];
                notice.identifier = [[[userInfo valueForKey:@"notice"] valueForKey:@"id"] intValue];
                MZLNoticeDetailViewController * vcNoticeDetail = (MZLNoticeDetailViewController *) [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MZLNoticeDetailViewController class])];
                vcNoticeDetail.noticeParam = notice;
                targetVc = vcNoticeDetail;
            }
            // 跳转短文详情
            else if (!isEmptyString([[[MZLSharedData apsInfo] valueForKey:@"short_article"] valueForKey:@"id"])) {
                MZLModelShortArticle *shortArticle = [[MZLModelShortArticle alloc] init];
                shortArticle.identifier = [[[[MZLSharedData apsInfo] valueForKey:@"short_article"] valueForKey:@"id"] intValue];
                MZLShortArticleDetailVC *vcShortArticle = [MZL_SHORT_ARTICLE_STORYBOARD() instantiateViewControllerWithIdentifier:NSStringFromClass([MZLShortArticleDetailVC class])];
                vcShortArticle.shortArticle = shortArticle;
                vcShortArticle.popupCommentOnViewAppear = NO;
                vcShortArticle.hidesBottomBarWhenPushed = YES;
                targetVc = vcShortArticle;
            }
            if (targetVc) {
                [vc mzl_pushViewController:targetVc];
            }
        }
    }
    //call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost
    completionHandler(UIBackgroundFetchResultNewData);
}

//获取当前的viewControll
- (UIViewController *)currentVisibleViewController {
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (! [rootVc.presentedViewController isKindOfClass:[UITabBarController class]]) {
        return nil;
    }
    UITabBarController *tabBarVc = (UITabBarController *)rootVc.presentedViewController;
    
    UINavigationController *navVc = (UINavigationController *)tabBarVc.selectedViewController;
    UIViewController *vc = navVc.visibleViewController;
    if (vc.presentedViewController) {
        // 如果以模态展示的是navVc，取visibleVc
        if ([vc.presentedViewController isKindOfClass:[UINavigationController class]]) {
            return ((UINavigationController *)vc.presentedViewController).visibleViewController;
        }
        return vc.presentedViewController;
    }
    return vc;
}


//- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
//    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
//        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
//        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
//    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
//        UINavigationController* navigationController = (UINavigationController*)rootViewController;
//        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
//    } else if (rootViewController.presentedViewController) {
//        UIViewController* presentedViewController = rootViewController.presentedViewController;
//        return [self topViewControllerWithRootViewController:presentedViewController];
//    } else {
//        return rootViewController;
//    }
//}

#pragma mark - push notifications delegate

- (void)co_onRegNotiSuccWithDeviceToken:(NSString *)token {
    [MZLSharedData setDeviceTokenForNotification:token];
}

- (void)co_onRegNotiError:(NSError *)error {
    [MZLSharedData setDeviceTokenForNotification:nil];
}

#pragma mark - auto-rotation

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    UIViewController *controller = window.rootViewController.presentedViewController.presentedViewController;
    if (controller && [controller isMemberOfClass:[MZLImageGalleryNavigationController class]]) {
        return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - application badge related

- (void)checkAppMessages {
    updateAppBadgeWithUnreadNotiCount();
    [MZLServices noticeFromLocalWithsuccBlock:^(NSArray *models) {
    } errorBlock:^(NSError *error) {
    }];
}


#pragma mark - umtrack 

- (NSString * )macString{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

- (NSString *)idfaString {
    
//    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
//    [adSupportBundle load];
//    
//    if (adSupportBundle == nil) {
//        return @"";
//    }
//    else{
//        
//        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
//        
//        if(asIdentifierMClass == nil){
//            return @"";
//        }
//        else{
//            
//            //for no arc
//            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
//            //for arc
//            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
//            
//            if (asIM == nil) {
//                return @"";
//            }
//            else{
//                
//                if(asIM.advertisingTrackingEnabled){
//                    return [asIM.advertisingIdentifier UUIDString];
//                }
//                else{
//                    return [asIM.advertisingIdentifier UUIDString];
//                }
//            }
//        }
//    }
    return @"";
}

- (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}

#pragma mark - TU SDK

- (void)initTuSDK {
    if (isMZLProdApp()) {
        [TuSDK initSdkWithAppKey:@"36d3e6bab4b16891-00-f33nn1"];
    } else {
        [TuSDK initSdkWithAppKey:@"b1375b2892606a7a-00-f33nn1"];
    }
}

@end
