//
//  MZLModifyPWByMailViewController.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/27.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLModifyPWByMailViewController.h"
#import "IBAlertView.h"

@interface MZLModifyPWByMailViewController ()

@end

@implementation MZLModifyPWByMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backLoginBtn:(id)sender {
    
    //跳回登入界面
//    [IBAlertView showDetermineWithTitle:@"提示" message:@"修改成功" dismissBlock:^{
//        NSArray *controllers = self.navigationController.viewControllers;
//        for (int i = 0; i< controllers.count ; i++) {
//            NSLog(@"controllers[%d] == %@",i,controllers[i]);
//        }
//        
//        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
//    }];
//
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];

}
@end
