//
//  MZLArticleItemTableViewCell.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-10.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ARTICLE_CELL_DEFAULT_BOTTOM_MARGIN 15.0
#define ARTICLE_CELL_DEFAULT_TITLE_RIGHT_MARGIN 68.0
#define ARTICLE_CELL_AUTHORDETAIL_TITLE_RIGHT_MARGIN 10.0

@class MZLModelArticle;

@interface MZLArticleItemTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTags;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (weak, nonatomic) IBOutlet UIImageView *imgAuthor;
@property (weak, nonatomic) IBOutlet UIView *vwBg;
@property (weak, nonatomic) IBOutlet UIView *vwAuthor;
@property (weak, nonatomic) IBOutlet UIView *vwContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgShadow;
@property (weak, nonatomic) IBOutlet UIImageView *imgExcelBadge;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleRightMargin;

@property (assign, nonatomic) BOOL isVisted;

- (void)updateOnFirstVisit:(UIViewController *)controller;
- (void)updateContentFromArticle:(MZLModelArticle *)article;
/** showFeaturedFlag-是否显示精选标识，systemArticleController不需要显示精选标识 */
- (void)updateContentFromArticle:(MZLModelArticle *)article showFeaturedFlag:(BOOL)showFeaturedFlag;

@end
