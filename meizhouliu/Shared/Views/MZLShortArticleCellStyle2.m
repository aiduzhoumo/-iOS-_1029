//
//  MZLShortArticleCellStyle2.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15/3/27.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLShortArticleCellStyle2.h"
#import <IBMessageCenter.h>
#import "UITableViewCell+COAddition.h"
#import "UIView+MZLAdditions.h"
#import "MZLModelShortArticle.h"
#import "MZLHighlightedControl.h"
#import "UIImage+COAdditions.h"
#import "UIButton+COAddition.h"
#import "UIImageView+MZLNetwork.h"
#import "NSString+MZLImageURL.h"
#import "UIViewController+MZLShortArticle.h"
#import "MZLModelLocationBase.h"
#import "MZLBaseViewController.h"
#import "MZLShortArticleCell.h"
#import "MZLLoginViewController.h"
#import "MZLServices.h"
#import "MZLShortArticleUpResponse.h"
#import "MZLTabBarViewController.h"
#import "MZLPersonalizedShortArticleVC.h"

#define ReuseId_SinglePhotoShortContent @"ReuseId_SinglePhotoShortContent"
#define ReuseId_MultiPhotosShortContent @"ReuseId_MultiPhotosShortContent"
#define ReuseId_SinglePhotoLongContent @"ReuseId_SinglePhotoLongContent"
#define ReuseId_MultiPhotosLongContent @"ReuseId_MultiPhotosLongContent"

#define CELL_MARGIN 16.0
#define CONTENT_READ_ALL_TEXT @"展开阅读"
#define CONTENT_WIDTH (CO_SCREEN_WIDTH - 2 * CELL_MARGIN)
#define CONTENT_FONT_SIZE 14.0
#define CONTENT_MAX_LINES 4

#define PHOTO_HEIGHT 48.0
#define PHOTO_WIDTH 48.0
#define PHOTO_SPACING 16.0
#define MAX_PHOTO_COUNT MZL_SHORT_ARTICLE_MAX_DISPLAY_PHOTO

#define FUNCTION_BTN_DEFAULT_INSET 8.0

#define KEY_SA_PROTOTYPE_CELLS @"KEY_SA_PROTOTYPE_CELLS"

typedef enum : NSInteger {
    MZLShortArticleCellStyle2ModeDisplay,
    MZLShortArticleCellStyle2ModeCalcHeight
} MZLShortArticleCellStyle2Mode;

@interface MZLShortArticleCellStyle2 ()<UIActionSheetDelegate,UIAlertViewDelegate> {
    __weak UIView *_bg;
    NSMutableArray *_photoImages;
    NSArray *_photos;
}

@property (nonatomic, assign) MZLShortArticleCellStyle2Mode mode;

@property (nonatomic, weak) UIImageView *authorImage;
@property (nonatomic, weak) UILabel *nameLbl;
@property (nonatomic, weak) UILabel *dateLbl;
@property (nonatomic, weak) UIButton *attentionBtn;

@property (nonatomic, weak) UIImageView *bigPhoto;
@property (nonatomic, weak) UIScrollView *photoScroll;
//@property (nonatomic, strong) NSMutableArray *photos;
//@property (nonatomic, strong) NSArray *photoUrls;

//@property (nonatomic, weak) UILabel *addressLbl;
//@property (nonatomic, weak) UIView *addressView;
@property (nonatomic, weak) UIButton *addressBtn;
@property (nonatomic, weak) UILabel *distanceLbl;

@property (nonatomic, weak) UILabel *contentLbl;
@property (nonatomic, weak) UIButton *contentBtn;

@property (nonatomic, weak) UILabel *tagsLbl;
@property (nonatomic, weak) UILabel *priceLbl;

@property (nonatomic, weak) UIView *functionView;
//@property (nonatomic, weak) UILabel *commentLbl;
//@property (nonatomic, weak) UILabel *upsLbl;
@property (nonatomic, weak) UIImageView *upsImage;
@property (nonatomic, weak) UIButton *commentBtn;
@property (nonatomic, weak) UIButton *upsBtn;
@property (nonatomic, weak) UIButton *shareBtn;
@property (nonatomic, weak) UIButton *gouwuBtn;
//@property (nonatomic, weak) UIButton *reportBrn;
@property (nonatomic, weak) UILabel *goodsLbl;
@property (nonatomic, assign) UIView *goodsView;

//@property (nonatomic, weak) UIAlertView *alert;

@property (nonatomic, weak) UITableView *ownerTable;

@end

@implementation MZLShortArticleCellStyle2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commontInit];
    }
    return self;
}

- (void)dealloc {
    [IBMessageCenter removeMessageListenersForTarget:self];
}

- (void)commontInit {
    if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(iOS_VER_7_1)) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = @"EFEFF4".co_toHexColor;
    self.mode = MZLShortArticleCellStyle2ModeDisplay;
}

- (void)initInternal {
    
    UIView *bg = [[self.contentView createSubView] co_withinParent];
    bg.backgroundColor = [UIColor whiteColor];
    [bg addTapGestureRecognizer:self action:@selector(toShortArticleDetail)];
    _bg = bg;
    
    [self initAuthorView];
    [self initPhotoGallery];
    [self initBottomView];
    
    // separotor
    UIView *sepView = [bg createSubView];
    sepView.backgroundColor = @"EFEFF4".co_toHexColor;
    [sepView co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, 0) width:COInvalidCons height:12.0];
    [sepView co_topFromBottomOfPreSiblingWithOffset:CELL_MARGIN];
    UIView *sepViewTopSep = [sepView createTopSepView];
    sepViewTopSep.backgroundColor = @"D8D8D8".co_toHexColor;
    
    [bg co_encloseSubviews];
}

#pragma mark - UI, author & date time

- (void)initAuthorView {
    UIView *author = [_bg createSubView].co_insetsParentSizeBk(0, 0, COInvalidCons, 0, COInvalidCons, 48.0);
    UIView *topSep = [author createTopSepView];
    topSep.backgroundColor = @"D8D8D8".co_toHexColor;
    
    UIImageView *authorImage = [author createSubViewImageView];
    CGFloat imageSize = 36.0;
    [[authorImage co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 10, COInvalidCons, COInvalidCons) width:imageSize height:imageSize] co_centerYParent];
    [authorImage co_toRoundShapeWithDiameter:imageSize];
    [authorImage addTapGestureRecognizer:self action:@selector(toAuthorDetail)];
    self.authorImage = authorImage;
    
    UILabel *authorName = [author createSubViewLabelWithFont:MZL_BOLD_FONT(14.0) textColor:@"333333".co_toHexColor];
    [[[authorName co_leftFromRightOfPreSiblingWithOffset:8] co_rightParentWithOffset:96] co_centerYParent];
    [authorName addTapGestureRecognizer:self action:@selector(toAuthorDetail)];
    self.nameLbl = authorName;
    
    UILabel *dateTime = [author createSubViewLabelWithFontSize:10 textColor:@"B9B9B9".co_toHexColor];
    [[dateTime co_leftFromRightOfView:authorImage offset:8] co_bottomParent:5];
    dateTime.hidden = YES;
    self.dateLbl = dateTime;
    
    //  关注按钮
    UIButton *attentionBtn = [author createSubViewBtn];
    CGFloat attentionH = 28.0;
    CGFloat attentionW = 80.0;
    [[attentionBtn co_insetsParent:UIEdgeInsetsMake(COInvalidCons, COInvalidCons, COInvalidCons, 10) width:attentionW height:attentionH] co_centerYParent];
    [attentionBtn setImage:[UIImage imageNamed:@"attention_shouye"] forState:UIControlStateNormal];
    [attentionBtn addTarget:self action:@selector(toAttention) forControlEvents:UIControlEventTouchUpInside];
    self.attentionBtn = attentionBtn;
    
}

#pragma mark - UI, photo gallery

- (void)initPhotoGallery {
    CGFloat height = [self photoGalleryHeight];
    UIView *photoGallery = [[_bg createSubView] co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, 0) width:COInvalidCons height:height];
    [photoGallery co_topFromBottomOfPreSiblingWithOffset:0.0];
    
    UIImageView *bigPhoto = [photoGallery createSubViewImageView];
    [bigPhoto co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0) width:COInvalidCons height:[self bigPhotoHeight]];
    bigPhoto.contentMode = UIViewContentModeScaleAspectFit;
    [bigPhoto addTapGestureRecognizer:self action:@selector(onBigPhotoClicked)];
    self.bigPhoto = bigPhoto;
    
    if ([self isMultiPhotoLayout]) {
        UIScrollView *photoScroll = [[UIScrollView alloc] init];
        photoScroll.scrollsToTop = NO;
        photoScroll.showsHorizontalScrollIndicator = NO;
        [photoGallery addSubview:photoScroll];
        [photoScroll co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 16.0, COInvalidCons, 0.0) width:COInvalidCons height:PHOTO_HEIGHT];
        [photoScroll co_topFromBottomOfPreSiblingWithOffset:16.0];
        self.photoScroll = photoScroll;
        _photoImages = co_emptyMutableArray();
        for (NSInteger i = 0; i < MAX_PHOTO_COUNT; i ++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(i * (PHOTO_WIDTH + PHOTO_SPACING), 0, PHOTO_WIDTH, PHOTO_HEIGHT)];
            image.layer.cornerRadius = 4.0;
            image.layer.borderColor = [@"FFD414".co_toHexColor CGColor];
            image.clipsToBounds = YES;
            [photoScroll addSubview:image];
            [_photoImages addObject:image];
        }
    }
}

- (void)onBigPhotoClicked {
    [self.ownerController mzl_toShortArticlePhotoGallery:self.shortArticle];
}

- (void)onSmallPhotoClicked:(UITapGestureRecognizer *)tap {
    UIView *photo = tap.view;
    [self highlightPhoto:photo];
    NSUInteger index = [photo.superview.subviews indexOfObject:photo];
    if (index != NSNotFound) {
        [self loadBigPhotoWithUrl:[_photos[index] fileUrl]];
    }
}

- (void)loadBigPhotoWithUrl:(NSString *)photoUrl {
    self.bigPhoto.backgroundColor = @"EEEEEE".co_toHexColor;
    block_co_before_image_load beforeImageLoad = ^ (UIImage *image, UIImageView *imageView, BOOL cached) {
        imageView.backgroundColor = [UIColor clearColor];
    };
    NSDictionary *contextInfo = @{
                                  KEY_CO_BEFORE_IMAGE_LOAD_BLOCK : beforeImageLoad
                                  };
    [self.bigPhoto loadImageFromURL:photoUrl placeholderImageName:nil mode:MZL_IMAGE_MODE_SCALED contextInfo:contextInfo];
}

- (void)highlightPhoto:(UIView *)highlighted {
    for (UIView *photoImage in _photoImages) {
        photoImage.layer.borderWidth = 0.0;
    }
    highlighted.layer.borderWidth = 2.0;
}

- (CGFloat)bigPhotoHeight {
    CGFloat width = CO_SCREEN_WIDTH;
    CGFloat height = width * 3.0 / 4.0;
    return height;
}

- (CGFloat)photoGalleryHeight {
    CGFloat height = [self bigPhotoHeight];
    if ([self isMultiPhotoLayout]) {
        height = height + CELL_MARGIN + PHOTO_HEIGHT;
    }
    return height;
}

#pragma mark - UI, bottom view

- (void)initBottomView {
    UIView *bottomView = [[_bg createSubView] co_insetsParent:UIEdgeInsetsMake(COInvalidCons, CELL_MARGIN, COInvalidCons, CELL_MARGIN)];
    [bottomView co_topFromBottomOfPreSiblingWithOffset:16.0];
    
    [self initContentView:bottomView];
    [self initAddressView:bottomView];
    [self initTagsView:bottomView];
    [self initPriceView:bottomView];
    [self initFunctionView:bottomView];
    
    [bottomView co_encloseSubviews];
}

- (void)initContentView:(UIView *)parent {
    UIView *contentView = [[parent createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0)];
    
    UILabel *contentLbl = [contentView createSubViewLabelWithFontSize:CONTENT_FONT_SIZE textColor:@"434343".co_toHexColor];
    contentLbl.numberOfLines = CONTENT_MAX_LINES;
    contentLbl.preferredMaxLayoutWidth = CONTENT_WIDTH;
    if ([self isLongContentLayout]) {
        [contentLbl co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0)];
        UIButton *contentBtn = [contentView createSubViewBtn];
        [contentBtn setTitle:CONTENT_READ_ALL_TEXT forState:UIControlStateNormal];
        [contentBtn setTitleColor:@"B9B9B9".co_toHexColor forState:UIControlStateNormal];
        [contentBtn setBackgroundImage:[UIImage imageWithColor:@"f7f7f7".co_toHexColor] forState:UIControlStateHighlighted];
        contentBtn.layer.cornerRadius = 4;
        contentBtn.layer.borderColor = [@"B9B9B9".co_toHexColor CGColor];
        contentBtn.layer.borderWidth = 1;
        contentBtn.titleLabel.font = MZL_FONT(12);
        [contentBtn co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, 0, COInvalidCons) width:64 height:20];
        [contentBtn co_topFromBottomOfView:contentLbl offset:9];
        [contentBtn addTarget:self action:@selector(toggleContentStatus:) forControlEvents:UIControlEventTouchUpInside];
        self.contentBtn = contentBtn;
    } else {
        [contentLbl co_withinParent];
    }
    self.contentLbl = contentLbl;
}

- (void)initAddressView:(UIView *)parent {
    UIView *addressView = [[parent createSubView] co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, 0) width:COInvalidCons height:24.0];
    
    UIButton *addressBtn = [addressView createSubViewBtn];
    addressBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 6, 3, 6);
    [addressBtn co_centerButtonAndImageWithSpacing:6.0];
    [addressBtn co_setCornerRadius:4.0];
    addressBtn.titleLabel.font = MZL_FONT(12.0);
    [addressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addressBtn setImage:[UIImage imageNamed:@"Short_Article_List_Style2_Location"] forState:UIControlStateNormal];
    [addressBtn co_setNormalBgColor:@"64A3DC".co_toHexColor];
    [addressBtn co_setHighlightBgColor: @"4993DB".co_toHexColor];
    [addressBtn co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, COInvalidCons)];
    [addressBtn co_centerYParent];
    [addressBtn addTarget:self action:@selector(toLocationDetail) forControlEvents:UIControlEventTouchUpInside];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_lessThanOrEqualTo(200.0);
    }];
    self.addressBtn = addressBtn;
    
    UILabel *distanceLbl = [addressView createSubViewLabelWithFontSize:12 textColor:@"B9B9B9".co_toHexColor];
    [[distanceLbl co_bottomParent:3.0] co_leftFromRightOfPreSiblingWithOffset:8.0];
    self.distanceLbl = distanceLbl;
    
    [addressView co_topFromBottomOfPreSiblingWithOffset:12.0];
}

- (void)initTagsView:(UIView *)parent {
    UILabel *lblTags = [parent createSubViewLabelWithFontSize:12 textColor:@"999999".co_toHexColor];
    [[lblTags co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, 0)] co_topFromBottomOfPreSiblingWithOffset:8];
    self.tagsLbl = lblTags;
}

- (void)initPriceView:(UIView *)parent {
    UILabel *lblPrice = [parent createSubViewLabelWithFontSize:12 textColor:@"999999".co_toHexColor];
    [[lblPrice co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, 0)] co_topFromBottomOfPreSiblingWithOffset:4];
    self.priceLbl = lblPrice;
}

- (void)initFunctionView:(UIView *)parent {
    UIView *functionView = [[parent createSubView] co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, 0) width:COInvalidCons height:36.0];
    [functionView co_topFromBottomOfPreSiblingWithOffset:22.0];
    
    UIButton *upBtn = [self functionBtn:functionView imageName:@"Short_Article_List_Style2_Up"];
    [upBtn co_insetsParent:UIEdgeInsetsMake(0, 0, 0, COInvalidCons)];
    self.upsBtn = upBtn;
    [upBtn addTarget:self action:@selector(onUpBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableArray *btns = co_emptyMutableArray();
    UIButton *commentBtn = [self functionBtn:functionView imageName:@"Short_Article_List_Style2_Comment"];
    [btns addObject:commentBtn];
    self.commentBtn = commentBtn;
    [commentBtn addTarget:self action:@selector(onCommentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *gouwuBtn = [self functionBtn:functionView imageName:@"Short_Article_List_Style2_gouwu"];
    [btns addObject:gouwuBtn];
    self.gouwuBtn = gouwuBtn;
    [gouwuBtn addTarget:self action:@selector(onGoodsViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([UIViewController mzl_shouldShowShareShortArticleModule]) {
        UIButton *shareBtn = [self functionBtn:functionView imageName:@"Short_Article_List_Style2_Share"];
        self.shareBtn = shareBtn;
        [btns addObject:shareBtn];
        [shareBtn addTarget:self action:@selector(onShareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //    UIButton *reportBrn = [self functionBtn:functionView imageName:@"Short_Article_List_Style2_Share"];
    //    self.reportBrn = reportBrn;
    //    [btns addObject:reportBrn];
    //    [reportBrn addTarget:self action:@selector(onReportBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    for (UIButton *btn in btns) {
        [btn co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, 0, COInvalidCons)];
        [btn co_leftFromRightOfPreSiblingWithOffset:12.0];
    }
    
    //    UIView *goodsView = [[functionView createSubView] co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, 0, 0)];
    //    [goodsView addTapGestureRecognizer:self action:@selector(onGoodsViewClicked:)];
    //    self.goodsView = goodsView;
    //    [goodsView co_leftFromRightOfPreSiblingWithOffset:0.0];
    //    UILabel *lblGoodsCount = [goodsView createSubViewLabelWithFontSize:12 textColor:@"999999".co_toHexColor];
    //    self.goodsLbl = lblGoodsCount;
    //    [lblGoodsCount co_rightCenterYParentWithWidth:COInvalidCons height:COInvalidCons];
    //    UILabel *lblGoodsTip = [goodsView createSubViewLabelWithFontSize:12 textColor:@"999999".co_toHexColor];
    //    lblGoodsTip.text = @"相关商品";
    //    [[lblGoodsTip co_rightFromLeftOfView:lblGoodsCount offset:8] co_centerYParent];
    //    UIImageView *lblGoodsImage = [goodsView createSubViewImageViewWithImageNamed:@"Short_Article_List_Style2_Goods"];
    //    [[lblGoodsImage co_rightFromLeftOfView:lblGoodsTip offset:4] co_centerYParent];
}

- (void)onGoodsViewClicked:(UITapGestureRecognizer *)tap {
    [self toLocationDetailGoods];
}

- (UIButton *)functionBtn:(UIView *)parent imageName:(NSString *)imageName {
    UIButton *btn = [parent createSubViewBtn];
    CGFloat inset = FUNCTION_BTN_DEFAULT_INSET;
    btn.contentEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset);
    btn.layer.cornerRadius = 4.0;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [@"B9B9B9".co_toHexColor CGColor];
    btn.titleLabel.font = MZL_FONT(12.0);
    [btn setTitleColor:@"999999".co_toHexColor forState:UIControlStateNormal];
    if (imageName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    return btn;
}

#pragma mark - update

- (void)updateWithModel:(MZLModelShortArticle *)model {
    self.shortArticle = model;
    [self updateAuthorAndDate];
    [self updatePhotos];
    [self updateContent];
    [self updateAddress];
    [self updateTagsAndPrice];
    [self updateFunctionView];
}

- (void)updateAuthorAndDate {
    if ([self isModeDisplay]) {
        self.nameLbl.text = self.shortArticle.author.nickName;
        [self.authorImage loadAuthorImageFromURL:self.shortArticle.author.headerImage.fileUrl];
        self.dateLbl.text = self.shortArticle.publishedAtStr;
        
        //判断是不是自己
        if ([MZLSharedData appUserId] == self.shortArticle.author.identifier) {
            self.attentionBtn.hidden = YES;
        }else {
            self.attentionBtn.hidden = NO;
        }
        
        
        if (![MZLSharedData isAppUserLogined]) {
            [self.attentionBtn setImage:[UIImage imageNamed:@"attention_shouye"] forState:UIControlStateNormal];
        }else{
            [self getAttentionStatus];
        }
    }
}

- (void)updatePhotos {
    if ([self isModeDisplay]) {
        for (UIView *photoImage in _photoImages) {
            photoImage.hidden = YES;
        }
        [self highlightPhoto:_photoImages[0]];
        NSArray *photos = self.shortArticle.sortedPhotos;
        _photos = photos;
        MZLModelImage *firstPhoto = [photos firstObject];
        [self loadBigPhotoWithUrl:firstPhoto.fileUrl];
        if ([self isMultiPhotoLayout]) {
            CGFloat photoCount = MIN(photos.count, _photoImages.count);
            CGFloat width = PHOTO_WIDTH * photoCount + PHOTO_SPACING * photoCount;
            [self.photoScroll setContentSize:CGSizeMake(width, PHOTO_HEIGHT)];
            for (int i = 0; i < photoCount; i ++) {
                MZLModelImage *photo = photos[i];
                UIImageView *photoImageView = _photoImages[i];
                [photoImageView addTapGestureRecognizer:self action:@selector(onSmallPhotoClicked:)];
                photoImageView.hidden = NO;
                photoImageView.backgroundColor = @"EEEEEE".co_toHexColor;
                __weak UIImageView *weakPhotoImageView = photoImageView;
                [photoImageView loadImageFromURL:photo.fileUrl placeholderImageName:nil mode:MZL_IMAGE_MODE_210_210 callbackOnImageLoaded:^{
                    weakPhotoImageView.backgroundColor = [UIColor clearColor];
                }];
            }
        }
    }
}

- (void)updateContent {
    if ([self isLongContentLayout]) {
        if (self.shortArticle.isViewAll) {
            self.contentLbl.numberOfLines = 0;
            [self.contentBtn setTitle:@"收起全文" forState:UIControlStateNormal];
        } else {
            self.contentLbl.numberOfLines = CONTENT_MAX_LINES;
            [self.contentBtn setTitle:CONTENT_READ_ALL_TEXT forState:UIControlStateNormal];
        }
    }
    self.contentLbl.text = [MZLShortArticleCellStyle2 contentFromModel:self.shortArticle];
}

- (void)updateAddress {
    if ([self isModeDisplay]) {
        [self.addressBtn setTitle:self.shortArticle.location.locationName forState:UIControlStateNormal];
        self.distanceLbl.text = [self.shortArticle.location distanceInKm];
    }
}

- (void)updateTagsAndPrice {
    self.tagsLbl.text = self.shortArticle.tags;
    NSString *priceFormat = @"RMB %d/人";
    if (self.shortArticle.consumption > 0) {
        self.priceLbl.text = [NSString stringWithFormat:priceFormat, self.shortArticle.consumption];
    } else {
        self.priceLbl.text = @"";
    }
}

- (void)updateFunctionView {
    if ([self isModeDisplay]) {
        [self updateBtn:self.commentBtn withCount:self.shortArticle.commentsCount];
        [self toggleUp:self.shortArticle.isUpForCurrentUser];
        [self updateBtn:self.upsBtn withCount:self.shortArticle.upsCount];
        
        if ([self needsGetUpStatusForCurrentUser]) {
            [self getUpStatus];
        }
    }
}

#pragma mark - comments and up

- (void)updateBtn:(UIButton *)btn withCount:(NSInteger)count {
    CGFloat inset = FUNCTION_BTN_DEFAULT_INSET;
    btn.contentEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset);
    if (count > 0) {
        [btn co_centerButtonAndImageWithSpacing:3.0];
        [btn setTitle:INT_TO_STR(count) forState:UIControlStateNormal];
    } else {
        [btn co_centerButtonAndImageWithSpacing:0.0];
        [btn setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)toggleUp:(BOOL)flag {
    UIImage *upImage = flag ? [UIImage imageNamed:@"Short_Article_List_Style2_Up_High"] : [UIImage imageNamed:@"Short_Article_List_Style2_Up"];
    UIColor *titleColor = flag ? [UIColor whiteColor] : @"999999".co_toHexColor;
    UIColor *bgColor = flag ? @"FFD414".co_toHexColor : [UIColor whiteColor];
    CGFloat borderWidth = flag ? 0 : 0.5;
    [self.upsBtn setImage:upImage forState:UIControlStateNormal];
    self.upsBtn.layer.borderWidth = borderWidth;
    [self.upsBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [self.upsBtn setBackgroundColor:bgColor];
}

- (void)toggleUpStatus {
    [self toggleUp:self.shortArticle.isUpForCurrentUser];
    [self updateBtn:self.upsBtn withCount:self.shortArticle.upsCount];
}

//- (void)onReportBtnClicked:(id)sender
//{
//    UIActionSheet *reportSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报", nil];
//    reportSheet.delegate=self;
//    [reportSheet showInView:self];
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex ==0)
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"确定举报这篇玩法？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"举报", nil];
//        [alert show];
//    }
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex ==1)
//    {
//        [self report];
//    }
//}

- (void)onUpBtnClicked:(id)sender {
    if (self.shortArticle.isUpForCurrentUser) {
        self.shortArticle.upsCount = self.shortArticle.upsCount - 1;
        self.shortArticle.isUpForCurrentUser = NO;
        [self removeUp];
    } else {
        self.shortArticle.upsCount = self.shortArticle.upsCount + 1;
        self.shortArticle.isUpForCurrentUser = YES;
        [self addUp];
    }
    [self toggleUpStatus];
}



- (void)onCommentBtnClicked:(id)sender {
    if (shouldPopupLogin()) {
        [self.ownerController popupLoginFrom:MZLLoginPopupFromComment executionBlockWhenDismissed:^{
            [self toShortArticleDetailComment];
        }];
        return;
    }
    [self toShortArticleDetailComment];
}

- (void)onShareBtnClicked:(id)sender {
    [self.ownerController mzl_shareShortArticle:self.shortArticle];
}

//- (void)dismissAlertView:(NSTimer*)timer
//{
//    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
//}

//- (void)alertMessage:(NSString *)message
//{
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [alert show];
//    self.alert=alert;
//    [NSTimer scheduledTimerWithTimeInterval:2.0f
//                                     target:self
//                                   selector:@selector(dismissAlertView:)
//                                   userInfo:nil
//                                    repeats:NO];
//}

#pragma mark - attention
- (void)toAttention {
    if (![MZLSharedData isAppUserLogined]) {
        
        MZLTabBarViewController *tabVC = (MZLTabBarViewController *)self.ownerController.tabBarController;
        [tabVC showMzlTabBar:NO animatedFlag:NO];
        __weak MZLShortArticleCellStyle2 *weakSelf = self;
        [self.ownerController popupLoginFrom:MZLLoginPopupFromShortArticle executionBlockWhenDismissed:^{
            if ([MZLSharedData isAppUserLogined]) {
                [weakSelf toAttention];
            }
        }];
        
    }else{
        if (self.shortArticle.author.isAttentionForCurrentUser) {
            [self removeAttention];
        }else {
            [self addAttention];
        }
    }
}

- (void)toggleAttentionStatus {
    [self toggleAttention:self.shortArticle.author.isAttentionForCurrentUser];
    
}
- (void)toggleAttention:(BOOL)flag {
    UIImage *upImage = flag ? [UIImage imageNamed:@"attention_shouye_cancel"] : [UIImage imageNamed:@"attention_shouye"];
    [self.attentionBtn setImage:upImage forState:UIControlStateNormal];
}

- (void)addAttention {
    [self.ownerController showNetworkProgressIndicator];
    __weak MZLShortArticleCellStyle2 *weakSelf = self;
    [MZLServices addAttentionForShortArticleUser:self.shortArticle.author succBlock:^(NSArray *models) {
        weakSelf.shortArticle.author.isAttentionForCurrentUser = YES;
        [MZLSharedData addIdIntoAttentionIds:[NSString stringWithFormat:@"%ld",weakSelf.shortArticle.author.identifier]];
        [weakSelf toggleAttentionStatus];
        [weakSelf.ownerController hideProgressIndicator];
    } errorBlock:^(NSError *error) {
        [weakSelf.ownerController onNetworkError];
    }];
}

- (void)removeAttention {
    [self.ownerController showNetworkProgressIndicator];
    __weak MZLShortArticleCellStyle2 *weakSelf = self;
    [MZLServices removeAttentionForShortArticleUser:self.shortArticle.author succBlock:^(NSArray *models) {
        weakSelf.shortArticle.author.isAttentionForCurrentUser = NO;
        [MZLSharedData removeIdFromAttentionIds:[NSString stringWithFormat:@"%ld",weakSelf.shortArticle.author.identifier]];
        [weakSelf toggleAttentionStatus];
        [weakSelf.ownerController hideProgressIndicator];
    } errorBlock:^(NSError *error) {
        [weakSelf.ownerController onNetworkError];
    }];
}

- (void)getAttentionStatus {
    
    //不应该是每个cell取一次数据，而是从已关注的人Id中进行比对
    NSArray *idsArr = [MZLSharedData attentionIdsArr];
    
    //如果数组长度为0,说明没有关注任何人
    if (idsArr.count == 0) {
        self.shortArticle.author.isAttentionForCurrentUser = 0;
        [self toggleAttention:0];
        return;
    }
    
    for (NSString *str in idsArr) {
        NSInteger i = self.shortArticle.author.identifier;
        NSString *s = [NSString stringWithFormat:@"%ld",i];
        NSString *st = [NSString stringWithFormat:@"%@",str];
                
        if ([s isEqualToString:st]) {
            self.shortArticle.author.isAttentionForCurrentUser = 1;
            [self toggleAttention:1];
            return;
        }else {
            self.shortArticle.author.isAttentionForCurrentUser = 0;
            [self toggleAttention:0];
        }
    }
}


#pragma mark - service related

//- (void)report
//{
//    [MZLServices reportForShortArticle:self.shortArticle succBlock:^(NSArray *models) {
//        [self alertMessage:@"举报成功"];
//    } errorBlock:^(NSError *error) {
//        [self alertMessage:@"举报失败"];
//    }];
//}

- (void)addUp {
    [MZLServices addUpForShortArticle:self.shortArticle succBlock:^(NSArray *models) {
        // ignore
    } errorBlock:^(NSError *error) {
        // ignore
    }];
}

- (void)getUpStatus {
    MZLModelShortArticle *shortArticle = self.shortArticle;
    __weak MZLShortArticleCellStyle2 *weakSelf = self;
    [MZLServices upStatusForShortArticle:shortArticle succBlock:^(NSArray *models) {
        if (models && models.count > 0) {
            MZLShortArticleUpResponse *response = models[0];
            shortArticle.isUpForCurrentUser = (response.up != nil);
            if (shortArticle.identifier == weakSelf.shortArticle.identifier) {
                [weakSelf toggleUp:shortArticle.isUpForCurrentUser];
            }
        }
    } errorBlock:^(NSError *error) {
        // ignore
    }];
}

- (void)removeUp {
    MZLModelShortArticle *shortArticle = self.shortArticle;
    [MZLServices removeUpForShortArticle:shortArticle succBlock:^(NSArray *models) {
        // ignore
    } errorBlock:^(NSError *error) {
        // ignore
    }];
}




#pragma mark - override parent

- (void)_onUpStatusModified {
    [self updateFunctionView];
}

- (void)_onCommentStatusModified {
    [self updateFunctionView];
}

- (void)_onAttentionStateModified {
    [self getAttentionStatus];
}

#pragma mark - public methods

+ (instancetype)cellWithTableview:(UITableView *)tableView model:(MZLModelShortArticle *)model {
    NSString *reuseId = [self reuseIdFromModel:model];
    MZLShortArticleCellStyle2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (! cell) {
        cell = [[MZLShortArticleCellStyle2 alloc]co_initWithReuseIdentifier:reuseId];
        [cell initInternal];
    }
    
    if (tableView.dataSource && [tableView.dataSource isKindOfClass:[UIViewController class]]) {
        cell.ownerController = (UIViewController *)tableView.dataSource;
    }
    cell.ownerTable = tableView;
    [cell updateWithModel:model];
    
    return cell;
}

+ (CGFloat)heightForTableView:(UITableView *)tableView withModel:(MZLModelShortArticle *)model {
    CGFloat height = [self heightFromModel:model];
    if (height > 0) {
        return height;
    }
    NSString *reuseId = [self reuseIdFromModel:model];
    NSMutableDictionary *cells = [self prototypeCellsForTableView:tableView];
    MZLShortArticleCellStyle2 *cell = cells[reuseId];
    if (! cell) {
        cell = [[MZLShortArticleCellStyle2 alloc]co_initWithReuseIdentifier:reuseId];
        cells[reuseId] = cell;
        cell.mode = MZLShortArticleCellStyle2ModeCalcHeight;
        [cell initInternal];
    }
    [cell updateWithModel:model];
    [self setHeightIfNecessaryForModel:model withCell:cell];
    return [self heightFromModel:model];
}

+ (CGFloat)heightFromModel:(MZLModelShortArticle *)model {
    if (model.isViewAll) {
        return model.cellHeightUnderViewAll;
    }
    return model.cellHeight;
}

#pragma mark - navigation

- (MZLModelLocationBase *)locationBaseFromSurroundingLocation {
    MZLModelLocationBase *loc = [[MZLModelLocationBase alloc] init];
    loc.identifier = self.shortArticle.location.identifier;
    loc.name = self.shortArticle.location.locationName;
    return loc;
}

- (void)toLocationDetail {
    [[self ownerBaseViewController] toLocationDetailWithLocation:[self locationBaseFromSurroundingLocation]];
}

- (void)toLocationDetailGoods {
    [[self ownerBaseViewController] toLocationDetailGoods:[self locationBaseFromSurroundingLocation]];
}

- (void)toShortArticleDetail {
    [[self ownerBaseViewController] toShortArticleDetailWithShortArticle:self.shortArticle];
}

- (void)toShortArticleDetailComment {
    [[self ownerBaseViewController] toShortArticleDetailWithShortArticle:self.shortArticle commentFlag:YES];
}

- (void)toAuthorDetail {
    [[self ownerBaseViewController] toAuthorDetailWithAuthor:self.shortArticle.author];
}

#pragma mark - misc

- (MZLBaseViewController *)ownerBaseViewController {
    if (self.shortArticle && [self.ownerController isKindOfClass:[MZLBaseViewController class]]) {
        return (MZLBaseViewController *)self.ownerController;
    }
    return nil;
}

- (BOOL)isModeCalcHeight {
    return self.mode == MZLShortArticleCellStyle2ModeCalcHeight;
}

- (BOOL)isModeDisplay {
    return self.mode == MZLShortArticleCellStyle2ModeDisplay;
}

- (void)toggleContentStatus:(UIButton *)sender {
    // 短文全文阅读和收起
    self.shortArticle.isViewAll = ! self.shortArticle.isViewAll;
    NSIndexPath *indexPath = [self.ownerTable indexPathForCell:self];
    if (indexPath) {
        [self.ownerTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

+ (NSString *)reuseIdFromModel:(MZLModelShortArticle *)model {
    BOOL flag = [self isLongContentFor:model];
    if (model.photos.count == 1) {
        if (flag) {
            return ReuseId_SinglePhotoLongContent;
        } else {
            return ReuseId_SinglePhotoShortContent;
        }
    } else {
        if (flag) {
            return ReuseId_MultiPhotosLongContent;
        } else {
            return ReuseId_MultiPhotosShortContent;
        }
    }
}

+ (NSString *)contentFromModel:(MZLModelShortArticle *)model {
    NSString *content = model.content;
    if (isEmptyString(content)) {
        return content;
    }
    content = [content co_strip];
    return content;
}

+ (void)setHeight:(CGFloat)height forModel:(MZLModelShortArticle *)model {
    if (model.isViewAll) {
        model.cellHeightUnderViewAll = height;
    } else {
        model.cellHeight = height;
    }
}

+ (void)setHeightIfNecessaryForModel:(MZLModelShortArticle *)model withCell:(MZLShortArticleCellStyle2 *)cell {
    CGFloat height = [self heightFromModel:model];
    if (height > 0) {
        return;
    }
    // 预留高度1给cell separator
    height = (cell.contentView.co_fittingHeight + 1);
    [self setHeight:height forModel:model];
}

+ (BOOL)isLongContentFor:(MZLModelShortArticle *)article {
    NSString *content = [self contentFromModel:article];
    if (isEmptyString(content)) {
        return NO;
    }
    NSInteger lineCount = [content co_numberOfLinesConstrainedToWidth:CONTENT_WIDTH withFont:MZL_FONT(CONTENT_FONT_SIZE)];
    return lineCount > CONTENT_MAX_LINES;
}

+ (NSMutableDictionary *)prototypeCellsForTableView:(UITableView *)tableView {
    NSMutableDictionary *cells = [tableView getProperty:KEY_SA_PROTOTYPE_CELLS];
    if (! cells) {
        cells = [NSMutableDictionary dictionary];
        [tableView setProperty:KEY_SA_PROTOTYPE_CELLS value:cells];
    }
    return cells;
}

- (BOOL)needsGetUpStatusForCurrentUser {
    return [self isModeDisplay] && self.shortArticle.needsGetUpStatusForCurrentUser;
}

- (BOOL)isMultiPhotoLayout {
    return [self.reuseIdentifier isEqualToString:ReuseId_MultiPhotosShortContent] || [self.reuseIdentifier isEqualToString:ReuseId_MultiPhotosLongContent];
}

- (BOOL)isLongContentLayout {
    return [self.reuseIdentifier isEqualToString:ReuseId_MultiPhotosLongContent] || [self.reuseIdentifier isEqualToString:ReuseId_SinglePhotoLongContent];
}

@end
