//
//  MZLShortArticleCommentCell.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-10.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLShortArticleCommentCell.h"
#import "UIView+MZLAdditions.h"
#import "MZLModelShortArticleComment.h"
#import "UIImageView+MZLNetwork.h"
#import "UITableView+COAddition.h"
#import "MZLShortArticleDetailVC.h"
#import <IBAlertView.h>

#define MZLShortArticleCommentCellDefault @"MZLShortArticleCommentCellDefault"
#define MZLShortArticleCommentCellWithFunction @"MZLShortArticleCommentCellWithFunction"

#define CELL_H_MARGIN 15.0
#define HEIGHT_FUNCTION_MODULE 24.0
#define V_MARGIN_FUNCTION_MODULE 3.0
#define WIDTH_LBL_DATE 60.0

#define PROPERTY_CELL_HEIGHT @"PROPERTY_CELL_HEIGHT"

@interface MZLShortArticleCommentCell () {
    __weak UIImageView *_deleteIcon;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgAuthor;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIView *vwFunction;

@property (strong, nonatomic) MZLModelShortArticleComment *model;

@end

@implementation MZLShortArticleCommentCell

- (void)awakeFromNib {
    // Initialization code
    [self initInternal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initInternal {
    [self initUI];
}

- (void)initUI {
    [self.imgAuthor co_toRoundShapeWithDiameter:36.0];
    self.lblName.font = MZL_BOLD_FONT(14.0);
    for (UILabel *lbl in @[self.lblName, self.lblComment]) {
        lbl.textColor = @"434343".co_toHexColor;
    }
    self.lblName.preferredMaxLayoutWidth = CO_SCREEN_WIDTH - 66 - CELL_H_MARGIN - 10 - WIDTH_LBL_DATE;
    self.lblComment.preferredMaxLayoutWidth = CO_SCREEN_WIDTH - 66 - CELL_H_MARGIN;
    self.lblDate.textColor = @"B0B0B0".co_toHexColor;
    self.lblDate.textAlignment = NSTextAlignmentRight;
    [self initFunctionView];
}

- (void)initFunctionView {
    [self.vwFunction co_height:0];
    UIImageView *deleteIcon = [[UIImageView alloc] init];
    deleteIcon.center = CGPointMake(CO_SCREEN_WIDTH - 2 * CELL_H_MARGIN - HEIGHT_FUNCTION_MODULE / 2.0, HEIGHT_FUNCTION_MODULE / 2.0 + V_MARGIN_FUNCTION_MODULE);
    deleteIcon.bounds = CGRectMake(0, 0, HEIGHT_FUNCTION_MODULE, HEIGHT_FUNCTION_MODULE);
    deleteIcon.hidden = YES;
    deleteIcon.image = [UIImage imageNamed:@"Short_Article_DeleteArticle"];
    _deleteIcon = deleteIcon;
    [deleteIcon addTapGestureRecognizer:self action:@selector(deleteComment)];
    [self.vwFunction addSubview:deleteIcon];
    [self.vwFunction.superview co_encloseSubviews];
    
//    deleteIcon.backgroundColor = [UIColor greenColor];
//    self.vwFunction.backgroundColor = [UIColor blueColor];
}

- (void)deleteComment {
    [UIAlertView showChoiceMessage:@"确定删除该评论吗？" okBlock:^{
        [self.ownerController deleteComment:self.model];
    }];
}

- (void)updateWithComment:(MZLModelShortArticleComment *)comment {
    self.model = comment;
    [self.imgAuthor loadAuthorImageFromURL:comment.user.headerImage.fileUrl];
    if (comment.user) {
        self.lblName.text = comment.user.nickName;
    } else {
        self.lblName.text = @"匿名用户";
    }
    self.lblComment.text = comment.content;
    self.lblDate.text = comment.publishedTimeStr;
    if (! [MZLShortArticleCommentCell shouldShowFunctionForModel:comment]) {
        [self.vwFunction co_updateHeight:1];
        _deleteIcon.hidden = YES;
    } else {
        [self.vwFunction co_updateHeight:HEIGHT_FUNCTION_MODULE + 2 * V_MARGIN_FUNCTION_MODULE];
        _deleteIcon.hidden = NO;
    }
}

+ (instancetype)cellFromModel:(MZLModelShortArticleComment *)model tableView:(UITableView *)tableView {
    MZLShortArticleCommentCell *cell = [tableView co_dequeueReusableCellWithNibFromClass:[MZLShortArticleCommentCell class]];
    [cell updateWithComment:model];
    return cell;
}

+ (CGFloat)heightFromModel:(MZLModelShortArticleComment *)model tableView:(UITableView *)tableView {
    NSNumber *height = [model getProperty:PROPERTY_CELL_HEIGHT];
    if (height) {
        return [height floatValue];
    }
    static MZLShortArticleCommentCell *cachedCell;
    if (! cachedCell) {
        cachedCell = [tableView co_dequeueReusableCellWithNibFromClass:[MZLShortArticleCommentCell class]];
    }
    [cachedCell updateWithComment:model];
    CGFloat cellHeight = [cachedCell.contentView co_fittingHeight] + 1;
    [model setProperty:PROPERTY_CELL_HEIGHT value:@(cellHeight)];
    return cellHeight;
}

+ (BOOL)shouldShowFunctionForModel:(MZLModelShortArticleComment *)model {
    return [MZLSharedData isAppUserLogined] && [MZLSharedData appUserId] == model.user.identifier;
}

@end
