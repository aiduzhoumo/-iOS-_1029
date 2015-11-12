//
//  MZLNotificationItemTableViewCell.h
//  mzl_mobile_ios
//
//  Created by race on 14-9-1.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZLModelNotice;
@interface MZLNotificationItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vwDotBg;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblcontent;

@property (assign, nonatomic) BOOL isVisted;

- (void)updateOnFirstVisit;
- (void)updateContentFromNotice:(MZLModelNotice *)notice;
- (void)updateOnNoticeRead;

@end
