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
//    [self.headerIcon addTapGestureRecognizer:self action:@selector(toAuthorDetail)];
    
    self.nameLbl.text = user.nickName;
    
    [self.attentionBtn addTapGestureRecognizer:self action:@selector(attentionClick:)];
    
    //判断是不是自己
    if (user.identifier == [MZLSharedData appUserId]) {
        self.attentionBtn.hidden = YES;
    }else {
        self.attentionBtn.hidden = NO;
    }
    
    //判断关注状态
    NSArray *idsArr = [MZLSharedData attentionIdsArr];
    
    NSInteger i = user.identifier;
    NSString *s = [NSString stringWithFormat:@"%ld",i];
    for (NSString *str in idsArr) {
        NSString *st = [NSString stringWithFormat:@"%@",str];
        
        if ([s isEqualToString:st]) {
            user.isAttentionForCurrentUser = 1;
            [self toggleAttentionImage:1];
            return;
        }else {
            user.isAttentionForCurrentUser = 0;
            [self toggleAttentionImage:0];
        }
    }
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
    
    if (![MZLSharedData isAppUserLogined]) {
        [UIAlertView showAlertMessage:@"请先登入"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(showNetworkProgressIndicatorOnFeriendVC)]) {
        [self.delegate showNetworkProgressIndicatorOnFeriendVC];
    }
    
    if (self.user.isAttentionForCurrentUser) {
        self.user.isAttentionForCurrentUser = NO;
        [self.attentionBtn setImage:[UIImage imageNamed:@"attention_shouye"] forState:UIControlStateNormal];
        [self removeAttention];
        
    }else{
        self.user.isAttentionForCurrentUser = YES;
        [self.attentionBtn setImage:[UIImage imageNamed:@"attention_shouye_cancel"] forState:UIControlStateNormal];
        [self addAttention];
    }
}

- (void)addAttention {
    __weak MZLFeriendListCell *weakSelf = self;
    [MZLServices addAttentionForShortArticleUser:self.user succBlock:^(NSArray *models) {
        if ([weakSelf.delegate respondsToSelector:@selector(hideNetworkProgressIndicatorOnFeriendVC:)]) {
            [weakSelf.delegate hideNetworkProgressIndicatorOnFeriendVC:YES];
        }
        [MZLSharedData addIdIntoAttentionIds:[NSString stringWithFormat:@"%ld",weakSelf.user.identifier]];
        weakSelf.user.isAttentionForCurrentUser = YES;
        [weakSelf.attentionBtn setImage:[UIImage imageNamed:@"attention_shouye_cancel"] forState:UIControlStateNormal];
        
    } errorBlock:^(NSError *error) {
        if ([weakSelf.delegate respondsToSelector:@selector(hideNetworkProgressIndicatorOnFeriendVC:)]) {
            [weakSelf.delegate hideNetworkProgressIndicatorOnFeriendVC:NO];
        }
    }];
}

- (void)removeAttention {
    __weak MZLFeriendListCell *weakSelf = self;
    [MZLServices removeAttentionForShortArticleUser:self.user succBlock:^(NSArray *models) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(hideNetworkProgressIndicatorOnFeriendVC:)]) {
            [weakSelf.delegate hideNetworkProgressIndicatorOnFeriendVC:YES];
        }
        [MZLSharedData removeIdFromAttentionIds:[NSString stringWithFormat:@"%ld",weakSelf.user.identifier]];
        weakSelf.user.isAttentionForCurrentUser = NO;
        [weakSelf.attentionBtn setImage:[UIImage imageNamed:@"attention_shouye"] forState:UIControlStateNormal];
       
    } errorBlock:^(NSError *error) {
        if ([weakSelf.delegate respondsToSelector:@selector(hideNetworkProgressIndicatorOnFeriendVC:)]) {
            [weakSelf.delegate hideNetworkProgressIndicatorOnFeriendVC:NO];
        }
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




