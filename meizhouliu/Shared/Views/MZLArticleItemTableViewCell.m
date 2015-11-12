//
//  MZLArticleItemTableViewCell.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-10.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLArticleItemTableViewCell.h"
#import "MZLModelArticle.h"
#import "MZLModelLocation.h"
#import "MZLModelAuthor.h"
#import "UIImageView+MZLNetwork.h"
#import "MobClick.h"
#import "MZLSystemArticleListViewController.h"
#import "MZLLocationArticleListViewController.h"
#import "MZLAuthorDetailViewController.h"
#import "MZLLocationDetailViewController.h"
#import "UITableViewCell+MZLAddition.h"
#import "UIImage+COAdditions.h"

@interface MZLArticleItemTableViewCell () {
    
}

@property (nonatomic, weak) UIViewController *ownerController;

@end

@implementation MZLArticleItemTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.isVisted = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)imgBgToArticleItem:(UITapGestureRecognizer *)recognizer {
    [self jumpTo:MZL_SEGUE_TOARTICLEDETAIL eventSource:@"Img" param:[self articleFromRecognizer:recognizer]];
}

- (void)lblTitleToArticleItem:(UITapGestureRecognizer *)recognizer {
    [self jumpTo:MZL_SEGUE_TOARTICLEDETAIL eventSource:@"Title" param:[self articleFromRecognizer:recognizer]];
}

- (void)toAuthor:(UITapGestureRecognizer *)recognizer {
    [self jumpTo:MZL_SEGUE_TOAUTHORDETAIL eventSource:@"Author" param:[self articleFromRecognizer:recognizer].author];
}

- (MZLModelArticle *)articleFromRecognizer:(UITapGestureRecognizer *)recognizer {
    return [recognizer.view getProperty:MZL_KEY_ARTICLE];
}

- (void)jumpTo:(NSString *)segueName eventSource:(NSString *)eventSource param:(id)param {
    if (self.ownerController) {
        [self logTapEvent:eventSource];
        [self.ownerController performSegueWithIdentifier:segueName sender:param];
    }
}

- (void)logTapEvent:(NSString *)eventSource {
    if ([self.ownerController isKindOfClass:[MZLSystemArticleListViewController class]]) {
        NSString *eventName = [NSString stringWithFormat:@"clickArticleList%@", eventSource];
        [MobClick event:eventName];
    } else if ([self.ownerController isKindOfClass:[MZLLocationArticleListViewController class]]){
        NSString *eventName = [NSString stringWithFormat:@"clickLocationList%@", eventSource];
        [MobClick event:eventName];
    } else if ([self.ownerController isKindOfClass:[MZLLocationDetailViewController class]]){
        [MobClick event:@"clickLocationDetailPlaySingle"];
    } else if ([self.ownerController isKindOfClass:[MZLAuthorDetailViewController class]]){
        [MobClick event:@"clickAuthorDetailArticle"];
    }
}

- (void)clickTags:(UITapGestureRecognizer *)recognizer {
    if (self.ownerController) {
        [MobClick event:@"globalClickTags"];
    }
}

- (void)addTapGestureRecognizer {
    [self.imgBg addTapGestureRecognizer:self action:@selector(imgBgToArticleItem:)];
    [self.lblTitle addTapGestureRecognizer:self action:@selector(lblTitleToArticleItem:)];
    if (! self.vwAuthor.hidden) {
        [self.vwAuthor addTapGestureRecognizer:self action:@selector(toAuthor:)];
    }
    [self.lblTags addTapGestureRecognizer:self action:@selector(clickTags:)];
}

- (void)updateOnFirstVisit:(UIViewController *)controller {
    self.ownerController = controller;
    self.isVisted = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lblTitle.textColor = MZL_COLOR_BLACK_555555();
    self.lblAuthor.textColor = colorWithHexString(@"#61bcb6");
    self.lblTags.textColor = MZL_COLOR_BLACK_999999();
    self.imgAuthor.layer.cornerRadius = 5.0;
    self.imgAuthor.layer.masksToBounds = YES;
//    [self.vwContent.layer setBorderColor:[colorWithHexString(@"#dcdcdc") CGColor]];
//    [self.vwContent.layer setBorderWidth:0.5f];
//    self.vwContent.layer.cornerRadius = 5.0;
//    self.vwContent.layer.masksToBounds = YES;
    [self addTapGestureRecognizer];
}

- (void)updateContentFromArticle:(MZLModelArticle *)article {
    [self updateContentFromArticle:article showFeaturedFlag:YES];
}

- (void)updateContentFromArticle:(MZLModelArticle *)article showFeaturedFlag:(BOOL)showFeaturedFlag {
    // 更新绑定属性
    [self.imgBg setProperty:MZL_KEY_ARTICLE value:article];
    [self.lblTitle setProperty:MZL_KEY_ARTICLE value:article];
    if (! self.vwAuthor.hidden) {
        self.titleRightMargin.constant = ARTICLE_CELL_DEFAULT_TITLE_RIGHT_MARGIN;
        [self.vwAuthor setProperty:MZL_KEY_ARTICLE value:article];
        self.lblAuthor.text = article.author.name;
        [self.imgAuthor loadAuthorImageFromURL:article.author.photoUrl];
    } else {
        self.titleRightMargin.constant = ARTICLE_CELL_AUTHORDETAIL_TITLE_RIGHT_MARGIN;
        [self.vwAuthor removeProperty:MZL_KEY_ARTICLE];
        self.lblAuthor.text = @"";
        self.imgAuthor.image = nil;
    }
    self.imgExcelBadge.visible = showFeaturedFlag && article.essence;
    
    self.lblTitle.text = article.title;
    self.lblTags.text = formatTags(article.tags, @"  ");
    self.lblLocation.text = article.destination.name;
    [self.imgBg loadArticleImageFromURL:article.coverImageUrl callbackOnImageLoaded:nil];
}


- (void)willTransitionToState:(UITableViewCellStateMask)state {
    [super willTransitionToState:state];
    [self mzl_checkAndReplaceDeleteControl:state image:nil bgImage:[self bgImageForDeleteControl] bgColor:[UIColor clearColor]];

}

- (UIImage *)bgImageForDeleteControl {
    CGFloat imageWidth = 75.0;
    UIImage *bgClearImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(imageWidth, self.height)];
    CGFloat contentImageHeight = self.height - self.topMargin.constant - self.bottomMargin.constant;
    UIImage *contentImage = [UIImage imageWithColor:colorWithHexString(MZL_TABLEVIEWCELL_DELETE_BGCOLOR_HEX) size:CGSizeMake(imageWidth, contentImageHeight)];
    return [UIImage combineImagesWithBgImage:bgClearImage contentImage:contentImage contentImagePos:CGPointMake(0, self.topMargin.constant)];
}

@end
