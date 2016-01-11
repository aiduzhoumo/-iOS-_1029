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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initWithAuthorInfo:(MZLModelUser *)author {
    self.user = author;
    
    [self.imgAuthorHeader toRoundShape];
    [self.imgAuthorHeader loadAuthorImageFromURL:author.photoUrl];
    
    [self.imgAuthorHeader addTapGestureRecognizer:self action:@selector(imgAuthorHeader:)];
    
    self.vwBottom.backgroundColor = MZL_BG_COLOR(); // colorFromRGB(239.0, 239.0, 239.0);
    
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
//    self.lblDescriptions.text = @"很长很长很长很长很长很长很长的很长很长很长很长很长很长很长的告白哟很长很长很长很长很长很长很长的很长很长很长很长很长很长很长的告白哟很长很长很长很长很长很长很长的很长很长很长很长很长很长很长的告白哟";
//    self.lblAuthorArticleTitle.text = [NSString stringWithFormat:@"%@ 去过", author.name];
    
    [self.attention addTapGestureRecognizer:self action:@selector(toFeriendList:)];
    [self.fensi addTapGestureRecognizer:self action:@selector(toFeriendList:)];
    [self.attentionLable addTapGestureRecognizer:self action:@selector(toFeriendList:)];
    [self.fensiLable addTapGestureRecognizer:self action:@selector(toFeriendList:)];

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

- (void)toFeriendList:(UITapGestureRecognizer *)tap {
    MZLModelUser *user = _user;
    self.clickBlcok(user);
}

-(void)imgAuthorHeader:(UITapGestureRecognizer *)recognizer {
    [MobClick event:@"clickAuthorDetailAuthorHeader"];
}

- (void)toggleAttentionStatus {
    [self toggleAttentionImage:self.user.isAttentionForCurrentUser];
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
    
    if (self.user.isAttentionForCurrentUser) {
        self.user.isAttentionForCurrentUser = NO;
        [self.attentionBtn setImage:[UIImage imageNamed:@"attention_darenye"] forState:UIControlStateNormal];
        [self removeAttention];
        self.user.followers_count = [NSString stringWithFormat:@"%d",([self.user.followers_count intValue] - 1)];
        self.fensiLable.text = self.user.followers_count;
        
    }else{
        self.user.isAttentionForCurrentUser = YES;
        [self.attentionBtn setImage:[UIImage imageNamed:@"attention_cancel_darenye"] forState:UIControlStateNormal];
        [self addAttention];
        self.user.followers_count = [NSString stringWithFormat:@"%d",([self.user.followers_count intValue] + 1)];
        self.fensiLable.text = self.user.followers_count;
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



@end


