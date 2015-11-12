//
//  MZLCommentItemCell.m
//  mzl_mobile_ios
//
//  Created by race on 14-8-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLCommentItemCell.h"
#import "MZLArticleCommentViewController.h"
#import "UITableViewCell+MZLAddition.h"
#import "MZLModelComment.h"
#import "UIImageView+MZLNetwork.h"

@interface MZLCommentItemCell () {
    
}

@property (nonatomic, weak) UIViewController *ownerController;

@end

@implementation MZLCommentItemCell

- (void)awakeFromNib
{
    // Initialization code
    self.isVisted = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma mark -comment

- (void)updateOnFirstVisit:(UIViewController *)controller {
    self.ownerController = controller;
    self.isVisted = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.imgUserHeader toRoundShape];
    [self.lblNickName setTextColor:MZL_COLOR_BLACK_999999()];
    [self.lblComment setTextColor:MZL_COLOR_BLACK_555555()];
    [self.btnDelete setVisible:NO];
    
    [self addTapGestureRecognizer];
}

- (void)updateCellWithComment:(MZLModelComment *)comment {
    [self.imgUserHeader loadUserImageFromURL:comment.user.headerImage.fileUrl];
    self.lblComment.text = isEmptyString(comment.content) ? @"" : comment.content;
    self.lblNickName.text = comment.user? comment.user.nickName : @"匿名用户";
    self.btnDelete.visible = [self commentUserIsLoginedUser:comment];
}
- (void)addTapGestureRecognizer {
    [self.btnDelete addTarget:self action:@selector(deleteComment) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteComment {
    [((MZLArticleCommentViewController *)self.ownerController) deleteCommentOnCell:self];
}

#pragma mark - replace image of delete

-(void)willTransitionToState:(UITableViewCellStateMask)state{
    [super willTransitionToState:state];
    [self mzl_checkAndReplaceDeleteControl:state];
}

- (BOOL)commentUserIsLoginedUser:(MZLModelComment *)comment {
    return comment.user && [MZLSharedData appUserId] > 0 && comment.user.identifier == [MZLSharedData appUserId];
}

@end
