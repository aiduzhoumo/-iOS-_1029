//
//  CountdownButtonByTime.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/30.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "CountdownButtonByTime.h"

@implementation CountdownButtonByTime

+ (void)countdownButton:(UIButton *)button time:(int)time {

    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:@"重新发送" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
    
            });
        }else{
            //int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
           
                [button setTitle:@"" forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"getSecCodeBtn.png"] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:12.0];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%@秒重新发送",strTime] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);

}

@end
