//
//  MZLShortArticleDetailVC.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLTableViewController.h"

@class MZLModelShortArticle, MZLModelShortArticleComment;

@interface MZLShortArticleDetailVC : MZLTableViewController

@property (nonatomic, strong) MZLModelShortArticle *shortArticle;
@property (nonatomic, assign) BOOL popupCommentOnViewAppear;

- (void)deleteComment:(MZLModelShortArticleComment *)comment;

@end
