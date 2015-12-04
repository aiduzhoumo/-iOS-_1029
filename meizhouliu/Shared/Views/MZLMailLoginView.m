//
//  MZLMailLoginView.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/29.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLMailLoginView.h"

@implementation MZLMailLoginView

+ (id)mailLoginViewInstance {

    MZLMailLoginView *mailView = [MZLMailLoginView viewFromNib:@"MZLMailLoginView"];
    mailView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height , [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64);
    mailView.phoneLoginInMailView.enabled = NO;
    return mailView;
}

+ (void)removeFromCurrentView {

    
    [[MZLMailLoginView alloc] removeFromSuperview];

}

@end
