//
//  MZLArticleCommentViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-7-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTableViewController.h"

@class MZLModelArticle, MZLArticleDetailViewController,MZLCommentItemCell;

@interface MZLArticleCommentViewController : MZLTableViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *_tvComment;
//@property (weak, nonatomic) IBOutlet UIView *vwNoComment;
//@property (weak, nonatomic) IBOutlet UILabel *lblNocomment;

@property (assign ,nonatomic) BOOL hasComments;
@property (nonatomic, weak) MZLModelArticle *article;
@property (nonatomic, weak) MZLArticleDetailViewController *articleDetailViewController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consNoCommentTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consNoCommentBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTvBottom;


- (void)addComment;
- (void)deleteCommentOnCell:(MZLCommentItemCell *)cell;

@end
