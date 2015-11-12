//
//  MZLShortArticleCommentCell.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-10.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZLModelShortArticleComment, MZLShortArticleDetailVC;

@interface MZLShortArticleCommentCell : UITableViewCell

@property (nonatomic, weak) MZLShortArticleDetailVC *ownerController;

- (void)updateWithComment:(MZLModelShortArticleComment *)comment;

//+ (void)registerForCellReuseIdentifierWithTableView:(UITableView *)tableView;
+ (instancetype)cellFromModel:(MZLModelShortArticleComment *)model tableView:(UITableView *)tableView;
+ (CGFloat)heightFromModel:(MZLModelShortArticleComment *)model tableView:(UITableView *)tableView;

@end
