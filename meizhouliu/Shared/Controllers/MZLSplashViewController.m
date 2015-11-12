//
//  MZLSplashViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLSplashViewController.h"
#import "MZLInitNavViewController.h"

@interface MZLSplashViewController () {
}
@property (weak, nonatomic) IBOutlet UIImageView *imgLaunch;

@end

@implementation MZLSplashViewController

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
    
    if (co_isIPhone6Screen()) {
        self.imgLaunch.image = [UIImage imageNamed:@"LaunchImageIphone6"];
    } else if(co_isIPhone6PlusScreen()) {
        self.imgLaunch.image = [UIImage imageNamed:@"LaunchImageIphone6+"];
    }

}

#define MZL_FLAG_LAST_VISITED_VERSION @"MZL_FLAG_LAST_VISITED_VERSION"

- (void)viewDidAppear:(BOOL)animated {
    NSString *version = co_bundleVersion();
    NSString *lastVisitedVersion = [COPreferences getUserPreference:MZL_FLAG_LAST_VISITED_VERSION];
    if (!lastVisitedVersion || ![version isEqualToString:lastVisitedVersion]) {
        [COPreferences setUserPreference:version forKey:MZL_FLAG_LAST_VISITED_VERSION];
        [self toInitNav];
    } else {
        [self toMain];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {}

- (void)toMain {
    [self performSegueWithIdentifier:@"main" sender:nil];
}

- (void)toInitNav {
    MZLInitNavViewController *initNavVC = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:@"InitNav"];
    self.view.window.rootViewController = initNavVC;
}

- (void)delayToMain {
    executeInMainThreadAfter(0.1, ^{
        [self toMain];
    });
}

@end
