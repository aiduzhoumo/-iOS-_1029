//
//  MZLCommentItemCell.h
//  mzl_mobile_ios
//
//  Created by race on 14-8-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MZLModelComment;

#define MIN_COMMENT_CELL_HEIGHT 83.0
#define COMMENT_CELL_HEIGHT_EXCLUDING_CONTENT 68.0

@interface MZLCommentItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vwCommentCell;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblNickName;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (assign, nonatomic) BOOL isVisted;

- (void)updateOnFirstVisit:(UIViewController *)controller;

- (void)updateCellWithComment:(MZLModelComment *)comment;
@end
