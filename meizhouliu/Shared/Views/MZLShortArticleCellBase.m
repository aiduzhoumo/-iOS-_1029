//
//  MZLShortArticleCellBase.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15/4/8.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLShortArticleCellBase.h"
#import "MZLModelShortArticle.h"
#import <IBMessageCenter.h>
#import "UIViewController+MZLShortArticle.h"


@interface MZLShortArticleCellBase () {
    MZLModelShortArticle *_shortArticle;
}

@end

@implementation MZLShortArticleCellBase

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [IBMessageCenter removeMessageListenersForTarget:self];
}

#pragma mark - model and related notifications

- (MZLModelShortArticle *)shortArticle {
    return _shortArticle;
}

- (void)setShortArticle:(MZLModelShortArticle *)shortArticle {
    [IBMessageCenter removeMessageListenersForTarget:self];
    [IBMessageCenter addMessageListener:MZL_NOTIFICATION_SINGLE_SHORT_ARTICLE_UP_STATUS_MODIFIED source:shortArticle target:self action:@selector(_onUpStatusModified)];
    [IBMessageCenter addMessageListener:MZL_NOTIFICATION_SINGLE_SHORT_ARTICLE_COMMENT_STATUS_MODIFIED source:shortArticle target:self action:@selector(_onCommentStatusModified)];
    _shortArticle = shortArticle;
}

#pragma mark - protected for override

- (void)_onUpStatusModified {
}

- (void)_onCommentStatusModified {
}


@end
