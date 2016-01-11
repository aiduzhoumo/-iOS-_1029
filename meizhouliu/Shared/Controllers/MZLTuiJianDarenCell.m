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
    [self.headerIcon addTapGestureRecognizer:self action:@selector(toAuthorDetail)];
    
    self.nameLbl.text = user.nickName;
    
    [self.attentionBtn addTapGestureRecognizer:self action:@selector(attentionClick:)];
    
    //判断是不是自己
    if (user.identifier == [MZLSharedData appUserId]) {
        self.attentionBtn.hidden = YES;
    }
    
    //发请求判断关注状态
    __weak MZLTuiJianDarenCell *weakSelf = self;
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
    [self toggleAttentionStatus];
    
    NSArray *short_articles = user.short_articles;
    
    MZLShortArticlesModel *model1 = short_articles[0];
    MZLLog(@"%@",model1.cover.fileUrl);
    [self.imageOne loadSmallLocationImageFromURL:model1.cover.fileUrl];
    MZLShortArticlesModel *model2 = short_articles[1];
    MZLLog(@"%@",model2.cover.fileUrl);
    [self.imageTwo loadSmallLocationImageFromURL:model2.cover.fileUrl];
    MZLShortArticlesModel *model3 = short_articles[2];
    MZLLog(@"%@",model3.cover.fileUrl);
    [self.imageThree loadSmallLocationImageFromURL:model3.cover.fileUrl];
    
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


- (void)toAuthorDetail {
    
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



@end
