//
//  MZLTuiJianDarenCell.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/12/31.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLTuiJianDarenCell.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLModelUser.h"
#import "MZLShortArticlesModel.h"
#import "MZLServices.h"

@implementation MZLTuiJianDarenCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithInfo:(MZLModelUser *)user {
    
    _user = user;
    
    [self.headerIcon toRoundShape];
    [self.headerIcon loadAuthorImageFromURL:user.photoUrl];
//    [self.headerIcon addTapGestureRecognizer:self action:@selector(toAuthorDetail)];
    
    self.nameLbl.text = user.nickName;
    
    [self.attentionBtn addTapGestureRecognizer:self action:@selector(attentionClick:)];
    
    //判断是不是自己
    if (user.identifier == [MZLSharedData appUserId]) {
        self.attentionBtn.hidden = YES;
    }
    
    
    NSArray *short_articles = user.short_articles;
    
    MZLShortArticlesModel *model1 = short_articles[0];
    [self.imageOne loadSmallLocationImageFromURL:model1.cover.fileUrl];
    MZLShortArticlesModel *model2 = short_articles[1];
    [self.imageTwo loadSmallLocationImageFromURL:model2.cover.fileUrl];
    MZLShortArticlesModel *model3 = short_articles[2];
    [self.imageThree loadSmallLocationImageFromURL:model3.cover.fileUrl];
    
    //判断有没有被关注过
    NSArray *arr = [MZLSharedData attentionIdsArr];
    NSString *s = [NSString stringWithFormat:@"%ld",user.identifier];
    for (NSString *str in arr) {
        if ([s isEqualToString:str]) {
            user.isAttentionForCurrentUser = YES;
            [self toggleAttentionImage:1];
            return;
        }else {
            user.isAttentionForCurrentUser = NO;
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


- (void)toAuthorDetail {
    
}

- (void)attentionClick:(UITapGestureRecognizer *)tap
{
    if (![MZLSharedData isAppUserLogined]) {
        [UIAlertView showAlertMessage:@"请先登入"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(showNetworkProgressIndicatorOnTuijianVc)]) {
        [self.delegate showNetworkProgressIndicatorOnTuijianVc];
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
    __weak MZLTuiJianDarenCell *weakSelf = self;
    [MZLServices addAttentionForShortArticleUser:self.user succBlock:^(NSArray *models) {
        if ([weakSelf.delegate respondsToSelector:@selector(hideNetworkProgressIndicatorOnTuijianVc:)]) {
            [weakSelf.delegate hideNetworkProgressIndicatorOnTuijianVc:YES];
        }
        [MZLSharedData addIdIntoAttentionIds:[NSString stringWithFormat:@"%ld",weakSelf.user.identifier]];
        weakSelf.user.isAttentionForCurrentUser = 1;
        [weakSelf toggleAttentionImage:1];
    } errorBlock:^(NSError *error) {
        if ([weakSelf.delegate respondsToSelector:@selector(hideNetworkProgressIndicatorOnTuijianVc:)]) {
            [weakSelf.delegate hideNetworkProgressIndicatorOnTuijianVc:NO];
        }
    }];
}

- (void)removeAttention {
    __weak MZLTuiJianDarenCell *weakSelf = self;
    [MZLServices removeAttentionForShortArticleUser:self.user succBlock:^(NSArray *models) {
        if ([weakSelf.delegate respondsToSelector:@selector(hideNetworkProgressIndicatorOnTuijianVc:)]) {
            [weakSelf.delegate hideNetworkProgressIndicatorOnTuijianVc:YES];
        }
        [MZLSharedData removeIdFromAttentionIds:[NSString stringWithFormat:@"%ld",weakSelf.user.identifier]];
        weakSelf.user.isAttentionForCurrentUser = NO;
        [weakSelf toggleAttentionImage:0];
        
    } errorBlock:^(NSError *error) {
        if ([weakSelf.delegate respondsToSelector:@selector(hideNetworkProgressIndicatorOnTuijianVc:)]) {
            [weakSelf.delegate hideNetworkProgressIndicatorOnTuijianVc:NO];
        }
    }];
}

@end
