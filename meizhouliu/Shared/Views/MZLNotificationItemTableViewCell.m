//
//  MZLNotificationItemTableViewCell.m
//  mzl_mobile_ios
//
//  Created by race on 14-9-1.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLNotificationItemTableViewCell.h"
#import "UITableViewCell+MZLAddition.h"
#import "MZLModelNotice.h"

@interface MZLNotificationItemTableViewCell ()

//@property (nonatomic, weak) UIViewController *ownerController;

@end

@implementation MZLNotificationItemTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark -comment

- (void)updateOnFirstVisit {
//    self.ownerController = controller;
    self.isVisted = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.vwDotBg setBackgroundColor:[UIColor whiteColor]];
    [self addTapGestureRecognizer];
}

- (void)addTapGestureRecognizer {
//    [self.btnDelete addTarget:self action:@selector(deleteComment) forControlEvents:UIControlEventTouchUpInside];
}


- (void)updateContentFromNotice:(MZLModelNotice *)notice {
    // 更新绑定属性
    self.vwDotBg.visible = !(notice.isRead);
    self.lblTitle.text = notice.title;
    self.lblcontent.text = notice.content;
    self.lblDate.text = notice.editedDate;
}

- (void)updateOnNoticeRead {
    self.vwDotBg.hidden = YES;
}

#pragma mark - replace image of delete

-(void)willTransitionToState:(UITableViewCellStateMask)state{
    [super willTransitionToState:state];
    [self mzl_checkAndReplaceDeleteControl:state];
}
@end
