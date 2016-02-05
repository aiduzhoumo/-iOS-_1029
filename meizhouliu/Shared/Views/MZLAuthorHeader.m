//
//  MZLAuthorHeader.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLAuthorHeader.h"
#import "UIImageView+MZLNetwork.h"
#import "MobClick.h"
#import "MZLModelUser.h"
#import "MZLServices.h"
#import "MZLFeriendListViewController.h"

@implementation MZLAuthorHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWithAuthorInfo:(MZLModelUser *)author {
    self.user = author;
    
    [self.imgAuthorHeader toRoundShape];
    [self.imgAuthorHeader loadAuthorImageFromURL:author.photoUrl];
    
    [self.imgAuthorHeader addTapGestureRecognizer:self action:@selector(imgAuthorHeader:)];
    
    self.vwBottom.backgroundColor = [UIColor whiteColor]; // colorFromRGB(239.0, 239.0, 239.0);
    
    for (UILabel *lbl in @[self.lblAuthorName, self.lblAreas, self.lblDescriptions]) {
        lbl.textColor = MZL_COLOR_BLACK_999999();
    }
    
    for (UILabel *lbl in @[self.lblAuthorName, self.lblAuthorArticleTitle]) {
        lbl.textColor = MZL_COLOR_BLACK_555555();
    }
    
    self.lblAuthorName.text = author.name;
    if (isEmptyString(author.tags)) {
        self.lblAreas.text = @"该作者暂时还没有专注的领域哟～";
    } else {
        self.lblAreas.text = formatTags(author.tags, @"、");
    }
    if (isEmptyString(author.introduction)) {
        self.lblDescriptions.text = @"该作者比较矜持，还没想好怎么介绍自己呢～";
    } else {
        self.lblDescriptions.text = author.introduction;
    }
    
    [self.attention addTapGestureRecognizer:self action:@selector(toFeriendAttentionList:)];
    [self.fensi addTapGestureRecognizer:self action:@selector(toFeriendFensiList:)];
    [self.attentionLable addTapGestureRecognizer:self action:@selector(toFeriendAttentionList:)];
    [self.fensiLable addTapGestureRecognizer:self action:@selector(toFeriendFensiList:)];

    self.attentionLable.text = author.followees_count;
    self.fensiLable.text = author.followers_count;
    
    [self.attentionBtn addTapGestureRecognizer:self action:@selector(attentionClick:)];
    if ([MZLSharedData appUserId] == author.identifier) {
        self.attentionBtn.hidden = YES;
    }else {
        //需要判断有没有被关注过
        [self toggleAttentionStatus];
    }
    
}

- (void)toFeriendAttentionList:(UITapGestureRecognizer *)tap {
    MZLModelUser *user = _user;
    self.clickBlcok(user,feriendListKindAttention);
}

- (void)toFeriendFensiList:(UITapGestureRecognizer *)tap {
    MZLModelUser *user = _user;
    self.clickBlcok(user,feriendListKindFensi);
}

-(void)imgAuthorHeader:(UITapGestureRecognizer *)recognizer {
    [MobClick event:@"clickAuthorDetailAuthorHeader"];
}

- (void)toggleAttentionStatus {
    
    NSArray *arr = [MZLSharedData attentionIdsArr];
    NSString *s = [NSString stringWithFormat:@"%ld",self.user.identifier];
    for (NSString *str in arr) {
        if ([s isEqualToString:str]) {
            self.user.isAttentionForCurrentUser = YES;
             [self toggleAttentionImage:self.user.isAttentionForCurrentUser];
            return;
        }
        else {
            self.user.isAttentionForCurrentUser = NO;
        }
        [self toggleAttentionImage:self.user.isAttentionForCurrentUser];
    }
}

- (void)toggleAttentionImage:(BOOL)flag {
    if (flag) {
        [self.attentionBtn setImage:[UIImage imageNamed:@"attention_cancel_darenye"] forState:UIControlStateNormal];
    }else {
        [self.attentionBtn setImage:[UIImage imageNamed:@"attention_darenye"] forState:UIControlStateNormal];
    }
}
- (void)attentionClick:(UITapGestureRecognizer *)tap
{
    if (![MZLSharedData isAppUserLogined]) {
        [UIAlertView showAlertMessage:@"请先登入"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(showProgressIndicatorAlertViewOnAuthorDetailVC)]) {
        [self.delegate showProgressIndicatorAlertViewOnAuthorDetailVC];
    }
    
    if (self.user.isAttentionForCurrentUser) {
        [self removeAttention];
    }else{
        [self addAttention];
    }

}

- (void)addAttention {
    __weak MZLAuthorHeader *weakSelf = self;
    [MZLServices addAttentionForShortArticleUser:self.user succBlock:^(NSArray *models) {
        [MZLSharedData addIdIntoAttentionIds:[NSString stringWithFormat:@"%ld",weakSelf.user.identifier]];
        weakSelf.user.isAttentionForCurrentUser = YES;
        [weakSelf.attentionBtn setImage:[UIImage imageNamed:@"attention_cancel_darenye"] forState:UIControlStateNormal];
        weakSelf.user.followers_count = [NSString stringWithFormat:@"%d",([weakSelf.user.followers_count intValue] + 1)];
        weakSelf.fensiLable.text = weakSelf.user.followers_count;
        if ([self.delegate respondsToSelector:@selector(hideProgressIndicatorAlertViewOnAuthorDetailVC:)]) {
            [self.delegate hideProgressIndicatorAlertViewOnAuthorDetailVC:YES];
        }
    } errorBlock:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(hideProgressIndicatorAlertViewOnAuthorDetailVC:)]) {
            [self.delegate hideProgressIndicatorAlertViewOnAuthorDetailVC:NO];
        }
    }];
}

- (void)removeAttention {
    MZLModelUser *user = self.user;
    __weak MZLAuthorHeader *weakSelf = self;
    [MZLServices removeAttentionForShortArticleUser:user succBlock:^(NSArray *models) {
        
        [MZLSharedData removeIdFromAttentionIds:[NSString stringWithFormat:@"%ld",weakSelf.user.identifier]];
        
        weakSelf.user.isAttentionForCurrentUser = NO;
        [weakSelf.attentionBtn setImage:[UIImage imageNamed:@"attention_darenye"] forState:UIControlStateNormal];
        weakSelf.user.followers_count = [NSString stringWithFormat:@"%d",([weakSelf.user.followers_count intValue] - 1)];
        weakSelf.fensiLable.text = weakSelf.user.followers_count;
        if ([self.delegate respondsToSelector:@selector(hideProgressIndicatorAlertViewOnAuthorDetailVC:)]) {
            [self.delegate hideProgressIndicatorAlertViewOnAuthorDetailVC:YES];
        }
    } errorBlock:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(hideProgressIndicatorAlertViewOnAuthorDetailVC:)]) {
            [self.delegate hideProgressIndicatorAlertViewOnAuthorDetailVC:NO];
        }
    }];
}

@end


