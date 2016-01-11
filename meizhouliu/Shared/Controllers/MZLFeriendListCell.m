//
//  MZLFeriendListCell.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/7.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLFeriendListCell.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLModelUser.h"
#import "MZLServices.h"
#import "MZLAuthorDetailViewController.h"
#import "MZLFeriendListViewController.h"

@implementation MZLFeriendListCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithFeriendListInfo:(MZLModelUser *)user {
    
    _user = user;
    
    [self.headerIcon toRoundShape];
    [self.headerIcon loadAuthorImageFromURL:user.photoUrl];
    [self.headerIcon addTapGestureRecognizer:self action:@selector(toAuthorDetail)];
    
    self.nameLbl.text = user.nickName;
    
    [self.attentionBtn addTapGestureRecognizer:self action:@selector(attentionClick:)];
    
    //判断是不是自己
    if (user.identifier == [MZLSharedData appUserId]) {
        self.attentionBtn.hidden = YES;
    }
    
    //发请求判断关注状态
    __weak MZLFeriendListCell *weakSelf = self;
    [MZLServices attentionStatesForCurrentUser:user succBlock:^(NSArray *models) {
        if (models && models.count > 0) {
            user.isAttentionForCurrentUser = 1;
            [weakSelf toggleAttentionImage:user.isAttentionForCurrentUser];
        }else {
            user.isAttentionForCurrentUser = 0;
            [weakSelf toggleAttentionImage:user.isAttentionForCurrentUser];
        }
    } errorBlock:^(NSError *error) {
        //
    }];
    
    //需要判断有没有被关注过
//    [self toggleAttentionStatus];
}

- (void)toggleAttentionStatus {
    [self toggleAttentionImage:self.user.isAttentionForCurrentUser];
}

- (void)toggleAttentionImage:(BOOL)flag {
    if (flag) {
        [self.attentionBtn setImage:[UIImage imageNamed:@"attention_shouye_cancel"] forState:UIControlStateNormal];
    }else {
        [self.attentionBtn setImage:[UIImage imageNamed:@"attention_shouye"] forState:UIControlStateNormal];
    }
}


#pragma mark - attention

- (void)attentionClick:(UITapGestureRecognizer *)tap {
    
    if (self.user.isAttentionForCurrentUser) {
        self.user.isAttentionForCurrentUser = NO;
        [self.attentionBtn setImage:[UIImage imageNamed:@"attention_darenye"] forState:UIControlStateNormal];
        [self removeAttention];
        
    }else{
        self.user.isAttentionForCurrentUser = YES;
        [self.attentionBtn setImage:[UIImage imageNamed:@"attention_cancel_darenye"] forState:UIControlStateNormal];
        [self addAttention];
    }
}

- (void)addAttention {
    [MZLServices addAttentionForShortArticleUser:self.user succBlock:^(NSArray *models) {
        //
    } errorBlock:^(NSError *error) {
        //
    }];
}

- (void)removeAttention {
    MZLModelUser *user = self.user;
    [MZLServices removeAttentionForShortArticleUser:user succBlock:^(NSArray *models) {
        //
    } errorBlock:^(NSError *error) {
        //
    }];
}

#pragma mark - toAuthor

- (MZLBaseViewController *)ownerBaseViewController {
    if (self.user && [self.owenerController isKindOfClass:[MZLBaseViewController class]]) {
        return (MZLBaseViewController *)self.owenerController;
    }
    return nil;
}

- (void)toAuthorDetail {
    [[self ownerBaseViewController] toAuthorDetailWithAuthor:self.user];
}

@end




