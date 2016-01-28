//
//  MZLPersonalizedItemCell.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-11-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLPersonalizedItemCell.h"
#import <Masonry/Masonry.h>
#import "UIView+MZLAdditions.h"
#import "MZLModelLocationDetail.h"
#import "MZLModelArticleDetail.h"
#import "MZLModelAuthor.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLServices.h"
#import "MZLPersonalizedViewController.h"
#import "MZLFilterParam.h"
#import "MZLModelLocationDesp.h"

#define SCROLL_MARGIN 36.0
#define SCROLL_HEIGHT 80.0
#define SCROLL_PAGE_WIDTH (CO_SCREEN_WIDTH)
#define KEY_ARTICLE @"KEY_ARTICLE"
#define MAX_LOC_DESP_COUNT 4

#define TAG_INFO_VIEW_LBL_NUMBER 8

#define TAG_LOC_DESP_VIEW_AUTHOR_IMAGE 101
#define TAG_LOC_DESP_VIEW_AUTHOR_NAME 102
#define TAG_LOC_DESP_VIEW_ARTICLE_CONTENT 103


@interface MZLPersonalizedItemCell () {
    __weak UILabel *_nameLbl;
    __weak UILabel *_parentLocationLbl;
    __weak UILabel *_productLbl;
    __weak UIImageView *_productIcon;
    __weak UILabel *_articleCountLbl;
    __weak UIImageView *_articleCountIcon;
    __weak UIScrollView *_locDespScroll;
    __weak UIView *_pagingView;
    __weak UIActivityIndicatorView *_indicator;
    NSMutableArray *_locDespViews;
    
    __weak UIView *_locDespContentView;
    __weak UIView *_noLocDespView;
}

@end

@implementation MZLPersonalizedItemCell

- (void)awakeFromNib {
    // Initialization code
    [self initCoverView];
    [self initLocationDespView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - UI for cover

- (void)initCoverView {
    //    [self.imgLocCover addTapGestureRecognizer:self action:@selector(onImgCoverClicked)];
    
    self.consCoverHeight.constant = [MZLPersonalizedItemCell coverImageHeight];
    
    UIView *bottomView = [self.vwCover createSubView];
    //    bottomView.userInteractionEnabled = NO;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(bottomView.superview);
        make.height.mas_equalTo(200);
    }];
    // 加上阴影和名字
    UIImageView *shadowImage = [bottomView createSubViewImageView];
    shadowImage.image = [UIImage imageNamed:@"Personalize_Shadow"];
    [shadowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.bottom.mas_equalTo(shadowImage.superview);
    }];
    
    UIView *bottomContent = [[bottomView createSubView] co_insetsParent:UIEdgeInsetsMake(0, 16, 16, 16)];
    
    UIView *infoView = [[bottomContent createSubView] co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, 0, 0)];
    UILabel *articleLbl = [infoView createSubViewLabelWithFontSize:12 textColor:[UIColor whiteColor]];
    UIImageView *articleIcon = [infoView createSubViewImageViewWithImageNamed:@"Personalized_Articles"];
    
    //    UILabel *productLbl = [infoView createSubViewLabelWithFontSize:12 textColor:[UIColor whiteColor]];
    //    UIImageView *productIcon = [infoView createSubViewImageViewWithImageNamed:@"Personalized_Goods"];
    
    [articleLbl co_rightCenterYParentWithWidth:COInvalidCons height:COInvalidCons];
    // 确定infoView的上边界
    [articleIcon co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, 0, COInvalidCons) width:16 height:16];
    [articleIcon co_rightFromLeftOfView:articleLbl offset:6];
    
    //    [[productLbl co_centerYParent] co_rightFromLeftOfView:articleIcon offset:24];
    //    [productIcon co_insetsParent:UIEdgeInsetsMake(COInvalidCons, COInvalidCons, 0, COInvalidCons) width:16 height:16];
    //    [productIcon co_rightFromLeftOfView:productLbl offset:6];
    
    UILabel *parentLocationLbl = [infoView createSubViewLabelWithFontSize:11 textColor:[UIColor whiteColor]];
    [parentLocationLbl co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, COInvalidCons)];
    _parentLocationLbl = parentLocationLbl;
    _articleCountLbl = articleLbl;
    _articleCountIcon = articleIcon;
    
    //    _productLbl = productLbl;
    //    _productIcon = productIcon;
    
    UILabel *nameLbl = [bottomContent createSubViewLabelWithFontSize:18 textColor:[UIColor whiteColor]];
    [nameLbl co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, COInvalidCons)];
    [nameLbl co_bottomFromTopOfView:infoView offset:9];
    _nameLbl = nameLbl;
    
}

- (void)updateLocParent {
    if (! isEmptyString(self.location.topParentLocationName)) {
        _parentLocationLbl.text = self.location.topParentLocationName;
    } else {
        _parentLocationLbl.text = @"";
    }
}

#pragma mark - UI for articles

- (void)initLocationDespView {
    [self initLocDespContentView];
    [self initRefreshView];
    [self initNoLocDespView];
}

- (void)initLocDespContentView {
    UIView *locDespContentView = [[self.vwLocDesp createSubView] co_insetsParent:UIEdgeInsetsMake(16, 0, 16, 0)];
    _locDespContentView = locDespContentView;
    [self initLocationDespScroll];
    [self initLocationDespPagingView];
}

- (void)initLocationDespScroll {
    UIScrollView *locDespScroll = [[UIScrollView alloc] init];
    _locDespScroll = locDespScroll;
    [_locDespContentView addSubview:locDespScroll];
    //    [locDespScroll co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, COInvalidCons) width:SCROLL_PAGE_WIDTH height:SCROLL_HEIGHT];
    [locDespScroll co_withinParent];
    locDespScroll.scrollsToTop = NO;
    NSInteger locDespCount = MAX_LOC_DESP_COUNT;
    locDespScroll.contentSize = CGSizeMake(locDespCount * SCROLL_PAGE_WIDTH, SCROLL_HEIGHT);
    locDespScroll.pagingEnabled = YES;
    locDespScroll.showsHorizontalScrollIndicator = NO;
    locDespScroll.bounces = NO;
    locDespScroll.delegate = self;
    _locDespViews = [NSMutableArray array];
    for (int i = 0; i < MAX_LOC_DESP_COUNT; i++) {
        UIView *locDespView = [[UIView alloc] initWithFrame:CGRectMake(i * SCROLL_PAGE_WIDTH, 0, SCROLL_PAGE_WIDTH, locDespScroll.contentSize.height)];
        [self initLocDespViewWithSuperView:locDespView];
        [locDespScroll addSubview:locDespView];
    }
}

- (void)initLocDespViewWithSuperView:(UIView *)superView {
    UIView *content = [[superView createSubView] co_withinParent];
    [_locDespViews addObject:content];
    
    CGFloat hMargin = 32;
    
    UILabel *despLbl = [content createSubViewLabelWithFontSize:14 textColor:@"434343".co_toHexColor];
    [despLbl co_insetsParent:UIEdgeInsetsMake(0, hMargin, COInvalidCons, hMargin) width:COInvalidCons height:49];
    despLbl.textAlignment = NSTextAlignmentLeft;
    despLbl.numberOfLines = 2;
    despLbl.tag = TAG_LOC_DESP_VIEW_ARTICLE_CONTENT;
    
    UIView *authorView = [[content createSubView] co_insetsParent:UIEdgeInsetsMake(COInvalidCons, hMargin, 0, hMargin) width:COInvalidCons height:16];
    UIImageView *authorImage = [authorView createSubViewImageView];
    CGFloat authorImageHeight = 16;
    [authorImage co_leftCenterYParentWithWidth:authorImageHeight height:authorImageHeight];
    authorImage.tag = TAG_LOC_DESP_VIEW_AUTHOR_IMAGE;
    [authorImage co_toRoundShapeWithDiameter:authorImageHeight];
    UILabel *authorNameLbl = [authorView createSubViewLabelWithFontSize:11 textColor:@"999999".co_toHexColor];
    [authorNameLbl co_leftFromRightOfView:authorImage offset:6];
    [authorNameLbl co_centerYParent];
    authorNameLbl.tag = TAG_LOC_DESP_VIEW_AUTHOR_NAME;
}

- (void)initNoLocDespView {
    UIView *noLocDespView = [[self.vwLocDesp createSubView] co_withinParent];
    noLocDespView.backgroundColor = [UIColor whiteColor];
    UILabel *noLocDespLbl = [noLocDespView createSubViewLabelWithFontSize:14 textColor:@"434343".co_toHexColor];
    [noLocDespLbl co_centerParent];
    noLocDespLbl.text = @"来这里玩的人很懒，除了图，什么都没留下";
    noLocDespView.hidden = YES;
    _noLocDespView = noLocDespView;
}

- (NSString *)formattedContent:(NSString *)content {
    NSString * desp = content;
    if (desp.length > 0) {
        desp = [desp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        desp = [desp stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    }
    return desp;
}

- (void)initLocationDespPagingView {
    UIView *view = [_locDespContentView createSubView];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_locDespScroll.mas_bottom);
        make.left.right.and.bottom.mas_equalTo(view.superview);
    }];
    
    UIView *pagingView = [view createSubView];
    _pagingView = pagingView;
    CGFloat indicatorHeight = 6.0;
    NSMutableArray *indicators = [NSMutableArray array];
    for (int i = 0; i < MAX_LOC_DESP_COUNT; i ++) {
        UIView *indicator = [pagingView createSubView];
        [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(indicatorHeight, indicatorHeight));
            make.centerY.mas_equalTo(indicator.superview);
            if (i == 0) {
                make.left.mas_equalTo(indicator.superview);
            } else {
                make.left.mas_equalTo([indicators[i - 1] mas_right]).offset(indicatorHeight);
            }
        }];
        [indicator co_toRoundShapeWithDiameter:indicatorHeight];
        [indicators addObject:indicator];
    }
    
    [pagingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(pagingView.superview);
        make.height.mas_equalTo(indicatorHeight);
        make.right.mas_equalTo([indicators[indicators.count - 1] mas_right]);
    }];
}

- (void)setPageIndex:(NSInteger)index {
    for (UIView *indicator in _pagingView.subviews) {
        indicator.backgroundColor = colorWithHexString(@"#e5e5e5");
    }
    [_pagingView.subviews[index] setBackgroundColor:colorWithHexString(@"#ffd521")];
}

- (void)initRefreshView {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.vwLocDesp addSubview:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(indicator.superview);
    }];
    _indicator = indicator;
}

#pragma mark - update UI

- (void)updatePagingView {
    for (int index = 0; index <= 3; index ++) {
        UIView *indicator = (UIView *)_pagingView.subviews[index];
        if (index < self.location.locDesps.count) {
            indicator.hidden = NO;
        } else {
            indicator.hidden = YES;
        }
    }
    [self setPageIndex:0];
}

- (void)updateLocDespView:(UIView *)locDespView withDesp:(MZLModelLocationDesp *)locDesp {
    UIImageView *authorImage = (UIImageView *)[locDespView viewWithTag:TAG_LOC_DESP_VIEW_AUTHOR_IMAGE];
    UILabel *authorNameLbl = (UILabel *)[locDespView viewWithTag:TAG_LOC_DESP_VIEW_AUTHOR_NAME];
    authorImage.image = nil;
    authorNameLbl.text = @"";
    if (locDesp.user) {
        [authorImage loadAuthorImageFromURL:locDesp.userImageUrl];
        authorNameLbl.text = locDesp.userName;
    }
    UILabel *locDespLbl = (UILabel *)[locDespView viewWithTag:TAG_LOC_DESP_VIEW_ARTICLE_CONTENT];
    locDespLbl.text = [self formattedContent:locDesp.content];
    [locDespView addTapGestureRecognizer:self action:@selector(toLocationDetail:)];
}

- (void)updateLocDespViews {
    NSInteger locDespCount = self.location.locDesps.count;
    _locDespScroll.contentSize = CGSizeMake(locDespCount * SCROLL_PAGE_WIDTH, _locDespScroll.contentSize.height);
    for (int i = 0; i < locDespCount; i++) {
        UIView *locationDespView = _locDespViews[i];
        [self updateLocDespView:locationDespView withDesp:self.location.locDesps[i]];
    }
    _locDespScroll.contentOffset = CGPointMake(0, 0);
}

- (void)updateLocDespAndPaging {
    _noLocDespView.hidden = YES;
    if (self.location.locDesps) {
        NSInteger locDespCount = self.location.locDesps.count;
        _noLocDespView.hidden = locDespCount > 0;
        _locDespScroll.hidden = locDespCount <= 0;
        _pagingView.hidden = locDespCount <= 1;
        if (locDespCount > 0) {
            [self updateLocDespViews];
            if (locDespCount > 1) {
                [self updatePagingView];
            }
        }
    } else {
        [self _loadLocationDesps];
    }
}

#pragma mark - service related

- (void)_loadLocationCoverImage {
    MZLModelLocationDetail *locDetail = self.location;
    __weak MZLPersonalizedItemCell *weakSelf = self;
    [MZLServices locationPersonalizeCoverServiceWithLocation:locDetail succBlock:^(NSArray *models) {
        MZLModelLocationBase *locationFromSvc = models[0];
        locDetail.coverImage = locationFromSvc.coverImage;
        if (locDetail.identifier == weakSelf.location.identifier) {
            [weakSelf onLocDespsSvcSucceed:models];
            [weakSelf.imgLocCover loadLocationImageFromURL:locationFromSvc.coverImageUrl];
        }
    } errorBlock:^(NSError *error) {
        // ignore
    }];
}

- (void)_loadLocationDesps {
    [_indicator startAnimating];
    MZLModelLocationDetail *locDetail = self.location;
    __weak MZLPersonalizedItemCell *weakSelf = self;
    MZLFilterParam *filterParam = [MZLFilterParam filterParamsFromFilterTypes:[MZLSharedData selectedFilterOptions]];
    [MZLServices locationPersonalizeDespServiceWithLocation:locDetail filter:filterParam succBlock:^(NSArray *models) {
        if (models && models.count > 0) {
            locDetail.locDesps = [NSArray arrayWithArray:models];
            if (locDetail.identifier == weakSelf.location.identifier) {
                [weakSelf onLocDespsSvcSucceed:models];
            }
        } else {
            // 赋值空数组
            locDetail.locDesps = [NSArray array];
            [weakSelf onNoLocDesps];
        }
    } errorBlock:^(NSError *error) {
        if (locDetail.identifier == weakSelf.location.identifier) {
            [weakSelf onLocDespsSvcFailure:error];
        }
    }];
}

- (void)onLocDespsSvcSucceed:(NSArray *)modelsFromSvc {
    [_indicator stopAnimating];
    [self updateLocDespAndPaging];
}

- (void)onLocDespsSvcFailure:(NSError *)error {
    [self onNoLocDesps];
}

- (void)onNoLocDesps {
    [_indicator stopAnimating];
    _noLocDespView.hidden = NO;
}

#pragma mark - navigation

- (void)toLocationDetail:(UITapGestureRecognizer *)tap {
    [self.vc toLocationDetailWithLocation:self.location];
}

#pragma mark - misc

- (NSInteger)getCurrentPageIndex {
    CGFloat offsetX = _locDespScroll.contentOffset.x;
    NSInteger pageIndex = offsetX / SCROLL_PAGE_WIDTH;
    return pageIndex;
}

- (NSInteger)getNextPageIndex {
    NSInteger nextPageIndex = [self getCurrentPageIndex] + 1;
    if ((nextPageIndex + 1) * SCROLL_PAGE_WIDTH > _locDespScroll.contentSize.width) {
        nextPageIndex = 0;
    }
    return nextPageIndex;
}

- (void)loadLocationCoverImage {
    if (! isEmptyString(self.location.coverImageUrl)) {
        [self.imgLocCover loadLocationImageFromURL:self.location.coverImageUrl];
    } else {
        self.imgLocCover.image = [UIImage imageNamed:@"Default_Article"];
        [self _loadLocationCoverImage];
    }
}

+ (CGFloat)cellHeight {
    CGFloat height = PCELL_BASE_HEIGHT - PCELL_BASE_COVER_IMAGE_HEIGHT + [self coverImageHeight];
    return height;
}

+ (CGFloat)coverImageHeight {
    CGFloat scale = CO_SCREEN_WIDTH / MZL_BASE_SCREEN_WIDTH;
    CGFloat height = round(PCELL_BASE_COVER_IMAGE_HEIGHT * scale);
    return height;
}

#pragma mark - scroll view delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setPageIndex:[self getCurrentPageIndex]];
}

#pragma mark - public

//- (void)toNextArticleIfPossible {
//    // 当前scroll有显示且文章数大于1
//    if (_locDespScroll.superview && self.location.articles.count > 1) {
//        NSInteger nextPageIndex = [self getNextPageIndex];
//        CGFloat nextPageXPos = nextPageIndex * SCROLL_PAGE_WIDTH;
//        [_locDespScroll setContentOffset:CGPointMake(nextPageXPos, 0) animated:YES];
//        [self setPageIndex:nextPageIndex];
//    }
//}

- (void)updateLbl:(UILabel *)label image:(UIImageView *)image withCount:(NSInteger)count {
    image.hidden = NO;
    label.hidden = NO;
    if (count > 0) {
        label.text = INT_TO_STR(count);
    } else {
        image.hidden = YES;
        label.hidden = YES;
        label.text = @"";
    }
}

- (void)updateCell {
    _nameLbl.text = self.location.name;
    [self updateLocParent];
    [self updateLbl:_articleCountLbl image:_articleCountIcon withCount:self.location.shortArticleCount];
#pragma mark - 隐藏目的地tab的小购物袋功能
    //    [self updateLbl:_productLbl image:_productIcon withCount:self.location.productsCount];
    [self loadLocationCoverImage];
    [self updateLocDespAndPaging];
}

@end
