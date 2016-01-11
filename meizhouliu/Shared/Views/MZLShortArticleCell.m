//
//  MZLShortArticleCell.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-20.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLShortArticleCell.h"
#import "MZLModelShortArticle.h"
#import "UITableView+COAddition.h"
#import "UITableViewCell+COAddition.h"
#import "UIView+MZLAdditions.h"
#import "UIView+COAdditions.h"
#import "UILabel+COAdditions.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLServices.h"
#import "MZLShortArticleUpResponse.h"
#import <IBAlertView.h>
#import "UIViewController+MZLShortArticle.h"
#import "MZLBaseViewController.h"
#import <IBMessageCenter.h>
#import "UIImage+COAdditions.h"
#import "MZLModelLocationBase.h"
#import "MZLLoginViewController.h"
#import "MZLHighlightedControl.h"
#import "UIButton+COAddition.h"

#define CELL_MARGIN 15
#define LEFT_VIEW_WIDTH 51

#define CONTENT_MAX_LINES 4
#define CONTENT_READ_ALL_TEXT @"展开阅读"
#define CONTENT_WIDTH (CO_SCREEN_WIDTH - 2 * CELL_MARGIN - LEFT_VIEW_WIDTH)
#define CONTENT_FONT_SIZE 16
//#define CONTENT_MAX_HEIGHT 96.0

#define FUNC_LBL_TEXTCOLOR_NORMAL @"B9B9B9"
#define UP_LBL_TEXTCOLOR_HI @"439CFF"
#define UP_LBL_IMAG_NORMAL @"Short_Article_List_Up"
#define UP_LBL_IMAG_HI @"Short_Article_List_Up_Hi"

#define MAX_DISPLAY_PHOTO_COUNT MZL_SHORT_ARTICLE_MAX_DISPLAY_PHOTO
#define PHOTO_MARGIN_9_PHOTO_MODE 4
#define PHOTO_WIDTH_9_PHOTO_MODE floorf((CONTENT_WIDTH - 2 * PHOTO_MARGIN_9_PHOTO_MODE) / 3.0)

#define KEY_SA_PROTOTYPE_CELLS @"KEY_SA_PROTOTYPE_CELLS"

typedef enum : NSInteger {
    MZLShortArticleCellModeDisplay,
    MZLShortArticleCellModeCalcHeight
} MZLShortArticleCellMode;

@interface MZLShortArticleCell () {
    MZLModelShortArticle *_model;
}

@property (nonatomic, assign) MZLShortArticleCellMode mode;

@property (nonatomic, weak) IBOutlet UIView *bg;
@property (nonatomic, weak) IBOutlet UIView *leftView;
@property (nonatomic, weak) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, weak) UIView *photoView;

@property (nonatomic, weak) UIImageView *authorImage;
@property (nonatomic, weak) UILabel *nameLbl;

@property (nonatomic, weak) UILabel *dateLbl;
@property (nonatomic, weak) UIButton *addressBtn;
@property (nonatomic, weak) UILabel *distanceLbl;

@property (nonatomic, weak) UILabel *contentLbl;
@property (nonatomic, weak) UIButton *contentBtn;

@property (nonatomic, weak) UILabel *tagsLbl;
@property (nonatomic, weak) UILabel *priceLbl;

@property (nonatomic, weak) UIView *functionView;
@property (nonatomic, weak) UILabel *commentLbl;
@property (nonatomic, weak) UILabel *upsLbl;
@property (nonatomic, weak) UIImageView *upsImage;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) MZLModelShortArticle *model;

@property (nonatomic, weak) UITableView *ownerTable;

- (void)initLeftView;
- (void)initNameDateView;
- (void)initAddressView;

- (void)initFunctionViewModules;
- (void)initFunctionViewLayout;
- (CGFloat)functionViewHeight;

- (void)updateAuthor;
- (void)updateAddress;

@end

@interface MZLShortArticleCellAuthor : MZLShortArticleCell

@end

@interface MZLShortArticleCellLocation : MZLShortArticleCell

@end

@interface MZLShortArticleCellMy : MZLShortArticleCell

@end

@implementation MZLShortArticleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commontInit];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [self commontInit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [IBMessageCenter removeMessageListenersForTarget:self];
}

- (void)commontInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.mode = MZLShortArticleCellModeDisplay;
}

- (void)initInternal {
    UIView *bg = [[self.contentView createSubView] co_offsetParent:CELL_MARGIN];
    [bg addTapGestureRecognizer:self action:@selector(toShortArticleDetail)];
    UIView *leftView = [[bg createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, 0, COInvalidCons) width:LEFT_VIEW_WIDTH height:COInvalidCons];
    self.leftView = leftView;
    
//    UIView *topView = [[bg createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0) width:COInvalidCons height:26.0];
//    self.topView = topView;
//    topView.backgroundColor = [UIColor redColor];
    
    UIView *rightView = [[bg createSubView] co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, 0, 0)];
    self.rightView = rightView;
    [rightView co_leftFromRightOfView:leftView offset:0];
//    [rightView co_bottomFromTopOfView:topView offset:0];
    
    [self initLeftView];
    [self initRightView];
    
//    self.backgroundColor = [UIColor greenColor];
//    self.contentView.backgroundColor = [UIColor redColor];
//    bg.backgroundColor = [UIColor blueColor];
//    leftView.backgroundColor = [UIColor purpleColor];
//    rightView.backgroundColor = [UIColor darkGrayColor];
}

- (void)initInternalFromNib {
    [self initLeftView];
    [self initRightView];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    for (int i = 0; i <= self.rightView.subviews.count - 1; i ++) {
//        UIView *subview = self.rightView.subviews[i];
//        NSLog(@"%d, width %f, height %f", (i + 1), subview.width, subview.height);
//    }
//}

#pragma mark - static methods

+ (NSString *)reuseIdFromModel:(MZLModelShortArticle *)model {
    BOOL flag = [self isLongContentFor:model];
    if (model.photos.count == 1) {
        if (flag) {
            return MZLSAC_ReuseId1PhotoLongContent;
        } else {
            return MZLSAC_ReuseId1PhotoShortContent;
        }
    } else {
        if (flag) {
            return MZLSAC_ReuseId9PhotoLongContent;
        } else {
            return MZLSAC_ReuseId9PhotoShortContent;
        }
    }
}

+ (instancetype)instanceFromType:(MZLShortArticleCellType)type reuseId:(NSString *)reuseId {
    Class targetClass = [MZLShortArticleCell class];
    if (type == MZLShortArticleCellTypeAuthor) {
        targetClass = [MZLShortArticleCellAuthor class];
    } else if (type == MZLShortArticleCellTypeLocation) {
        targetClass = [MZLShortArticleCellLocation class];
    } else if (type == MZLShortArticleCellTypeMy) {
        targetClass = [MZLShortArticleCellMy class];
    }
    return [[targetClass alloc] co_initWithReuseIdentifier:reuseId];
}

+ (instancetype)cellWithTableview:(UITableView *)tableView type:(MZLShortArticleCellType)type model:(MZLModelShortArticle *)model {
    NSString *reuseId = [self reuseIdFromModel:model];
    MZLShortArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (! cell) {
        cell = [self instanceFromType:type reuseId:reuseId];
        cell.type = type;
        [cell initInternal];
//        cell = [UIView viewFromNib:NSStringFromClass(self)];
//        cell.type = type;
//        [cell initInternalFromNib];
    }
    if (tableView.dataSource && [tableView.dataSource isKindOfClass:[UIViewController class]]) {
        cell.ownerController = (UIViewController *)tableView.dataSource;
    }
    [cell updateWithModel:model];
    [self setHeightIfNecessaryForModel:model withCell:cell];
    cell.ownerTable = tableView;
    return cell;
}

//+ (NSMutableDictionary *)prototypeCells {
//    static NSMutableDictionary *dict;
//    if (! dict) {
//        dict = [NSMutableDictionary dictionary];
//    }
//    return dict;
//}

+ (NSMutableDictionary *)prototypeCellsForTableView:(UITableView *)tableView {
    NSMutableDictionary *cells = [tableView getProperty:KEY_SA_PROTOTYPE_CELLS];
    if (! cells) {
        cells = [NSMutableDictionary dictionary];
        [tableView setProperty:KEY_SA_PROTOTYPE_CELLS value:cells];
    }
    return cells;
}

+ (CGFloat)heightForTableView:(UITableView *)tableView withType:(MZLShortArticleCellType)type withModel:(MZLModelShortArticle *)model {
    CGFloat height = [self heightFromModel:model];
    if (height > 0) {
        return height;
    }
    NSString *reuseId = [self reuseIdFromModel:model];
    NSMutableDictionary *cells = [self prototypeCellsForTableView:tableView];
    MZLShortArticleCell *cell = cells[reuseId];
    if (! cell) {
        cell = [self instanceFromType:type reuseId:reuseId];
        cells[reuseId] = cell;
        cell.type = type;
        cell.mode = MZLShortArticleCellModeCalcHeight;
        [cell initInternal];
    }
    [cell updateWithModel:model];
    [self setHeightIfNecessaryForModel:model withCell:cell];
    return [self heightFromModel:model];
}

//+ (CGFloat)heightFromType:(MZLShortArticleCellType)type model:(MZLModelShortArticle *)model {
//    CGFloat height = [self heightFromModel:model];
//    if (height > 0) {
//        return height;
//    }
//    NSString *reuseId = [self reuseIdFromModel:model];
//    MZLShortArticleCell *cell = [self prototypeCells][reuseId];
//    if (! cell) {
//        cell = [self instanceFromType:type reuseId:reuseId];
//        [self prototypeCells][reuseId] = cell;
//        cell.type = type;
//        cell.mode = MZLShortArticleCellModeCalcHeight;
//        [cell initInternal];
//    }
//    [cell updateWithModel:model];
//    [self setHeightIfNecessaryForModel:model withCell:cell];
//    return [self heightFromModel:model];
//}

+ (CGFloat)heightFromModel:(MZLModelShortArticle *)model {
    if (model.isViewAll) {
        return model.cellHeightUnderViewAll;
    }
    return model.cellHeight;
}

+ (void)setHeight:(CGFloat)height forModel:(MZLModelShortArticle *)model {
    if (model.isViewAll) {
        model.cellHeightUnderViewAll = height;
    } else {
        model.cellHeight = height;
    }
}

+ (void)setHeightIfNecessaryForModel:(MZLModelShortArticle *)model withCell:(MZLShortArticleCell *)cell {
    CGFloat height = [self heightFromModel:model];
    if (height > 0) {
        return;
    }
    // 预留高度1给cell separator
    height = (cell.contentView.co_fittingHeight + 1);
    [self setHeight:height forModel:model];
}

#pragma mark - navigation

- (MZLBaseViewController *)ownerBaseViewController {
    if (self.model && [self.ownerController isKindOfClass:[MZLBaseViewController class]]) {
        return (MZLBaseViewController *)self.ownerController;
    }
    return nil;
}

- (void)toShortArticleDetail {
    [[self ownerBaseViewController] toShortArticleDetailWithShortArticle:self.model];
}

- (void)toShortArticleDetailComment {
    [[self ownerBaseViewController] toShortArticleDetailWithShortArticle:self.model commentFlag:YES];
}

- (void)toAuthorDetail {
    [[self ownerBaseViewController] toAuthorDetailWithAuthor:self.model.author];
}

- (void)toLocationDetail {
    MZLModelLocationBase *loc = [[MZLModelLocationBase alloc] init];
    loc.identifier = self.model.location.identifier;
    loc.name = self.model.location.locationName;
    [[self ownerBaseViewController] toLocationDetailWithLocation:loc];
}

#pragma mark - init left view

- (void)initLeftView {
    UIView *imageWrapper = [[self.leftView createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, COInvalidCons) width:36 height:36];
    UIImageView *image = [imageWrapper createSubViewImageView];
    [image co_withinParent];
    [image co_toRoundShapeWithDiameter:36];
    self.authorImage = image;
    [image addTapGestureRecognizer:self action:@selector(toAuthorDetail)];
}

#pragma mark - init right view

- (void)initRightView {
    [self initNameDateView];
    [self initAddressView];
    [self initContentView];
    [self initPhotoView];
    [self initTagView];
    [self initPriceView];
    [self initFunctionView];
}

- (UIView *)createRightViewSubview {
    return [[self.rightView createSubView] co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, 0)];
}

- (UIView *)createRightViewSubview:(CGFloat)topOffsetFromPreSiblingView {
    UIView *view = [[self.rightView createSubView] co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, 0)];
    [view co_topFromBottomOfView:[view co_preSiblingView] offset:topOffsetFromPreSiblingView];
    return view;
}

- (void)initNameDateView {
//    UIView *nameDateView = [[self.rightView createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0) width:COInvalidCons height:18.0];
     UIView *nameDateView = [[self.rightView createSubView] co_insetsParent:UIEdgeInsetsMake(9, 0, COInvalidCons, 0) width:COInvalidCons height:18.0];
    if ([self isModeCalcHeight]) {
        return;
    }
    
    UILabel *dateLbl = [nameDateView createSubViewLabelWithFontSize:10 textColor:@"CCCCCC".co_toHexColor];
    dateLbl.textAlignment = NSTextAlignmentRight;
    [dateLbl co_insetsParent:UIEdgeInsetsMake(COInvalidCons, COInvalidCons, 0, 0) width:80 height:COInvalidCons];
    
    UILabel *nameLbl = [nameDateView createSubViewLabelWithFont:MZL_BOLD_FONT(15) textColor:@"434343".co_toHexColor];
    [[nameLbl co_leftParent] co_centerYParent];
    [nameLbl co_rightFromLeftOfView:dateLbl offset:10];
    [nameLbl addTapGestureRecognizer:self action:@selector(toAuthorDetail)];
    
    self.dateLbl = dateLbl;
    self.nameLbl = nameLbl;
}

- (void)initAddressView {
//    MZLHighlightedControl *addressView = [[MZLHighlightedControl alloc] init];
//    addressView.highlightedColor = @"F0F4FC".co_toHexColor;
//    [self.rightView addSubview:addressView];
//    [addressView co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, COInvalidCons)];
//    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.lessThanOrEqualTo(@(CONTENT_WIDTH));
//    }];
//    [addressView co_topFromBottomOfView:[addressView co_preSiblingView] offset:12];
//    CGFloat margin = 4.0;
//    [addressView co_height:17.0 + margin * 2];
//    if ([self isModeCalcHeight]) {
//        return;
//    }
//
//    CGFloat iconSize = 12.0;
//    CGFloat innerMargin = 4.0;
//    [addressView.layer setCornerRadius:3.0];
//    UIImageView *addressIcon = [addressView createSubViewImageViewWithImageNamed:@"Short_Article_Location_Blue"];
//    [addressIcon co_insetsParent:UIEdgeInsetsMake(COInvalidCons, margin, COInvalidCons, COInvalidCons) width:iconSize height:iconSize];
//    [addressIcon co_centerYParent];
//    UILabel *addressLbl = [addressView createSubViewLabelWithFontSize:14.0 textColor:@"439CFF".co_toHexColor];
//    [addressLbl co_insetsParent:UIEdgeInsetsMake(COInvalidCons, COInvalidCons, COInvalidCons, margin)];
//    [addressLbl co_centerYParent];
//    [addressLbl co_leftFromRightOfView:addressIcon offset:innerMargin];
//    self.addressLbl = addressLbl;
//    
//    [addressView addTapGestureRecognizer:self action:@selector(toLocationDetail)];
    
    UIView *addressView = [[self.rightView createSubView] co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, 0) width:COInvalidCons height:26.0];
    [addressView co_topFromBottomOfPreSiblingWithOffset:12.0];
    
    UIButton *addressBtn = [addressView createSubViewBtn];
    addressBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 0, 3, 0);
    [addressBtn co_centerButtonAndImageWithSpacing:6.0];
    [addressBtn co_setCornerRadius:4.0];
    addressBtn.titleLabel.font = MZL_FONT(14.0);
    [addressBtn setTitleColor:@"439CFF".co_toHexColor forState:UIControlStateNormal];
    [addressBtn setImage:[UIImage imageNamed:@"Short_Article_Location_Blue"] forState:UIControlStateNormal];
    [addressBtn co_setNormalBgColor:[UIColor whiteColor]];
    [addressBtn co_setHighlightBgColor: @"F0F4FC".co_toHexColor];
    [addressBtn co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, COInvalidCons)];
    [addressBtn co_centerYParent];
    [addressBtn addTarget:self action:@selector(toLocationDetail) forControlEvents:UIControlEventTouchUpInside];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_lessThanOrEqualTo(200.0);
    }];
    self.addressBtn = addressBtn;
    
    UILabel *distanceLbl = [addressView createSubViewLabelWithFontSize:12 textColor:@"B9B9B9".co_toHexColor];
    [[distanceLbl co_bottomParent:5.0] co_leftFromRightOfPreSiblingWithOffset:3.0];
    self.distanceLbl = distanceLbl;
}

- (void)initContentView {
    UIView *contentView = [self createRightViewSubview];
    [contentView co_topFromBottomOfView:[contentView co_preSiblingView] offset:9];
    
    UILabel *contentLbl = [contentView createSubViewLabelWithFontSize:CONTENT_FONT_SIZE textColor:@"434343".co_toHexColor];
    contentLbl.numberOfLines = CONTENT_MAX_LINES;
    contentLbl.preferredMaxLayoutWidth = CONTENT_WIDTH;
    if ([self isLongContentLayout]) {
        [contentLbl co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0)];
        UIButton *contentBtn = [contentView createSubViewBtn];
        [contentBtn setTitle:CONTENT_READ_ALL_TEXT forState:UIControlStateNormal];
        [contentBtn setTitleColor:@"7AA0C3".co_toHexColor forState:UIControlStateNormal];
        contentBtn.layer.cornerRadius = 4;
        contentBtn.layer.borderColor = [@"7AA0C3".co_toHexColor CGColor];
        contentBtn.layer.borderWidth = 1;
        contentBtn.titleLabel.font = MZL_FONT(11);
        [contentBtn co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, 0, COInvalidCons) width:54 height:21];
        [contentBtn co_topFromBottomOfView:contentLbl offset:9];
        [contentBtn addTarget:self action:@selector(toggleContentStatus:) forControlEvents:UIControlEventTouchUpInside];
        self.contentBtn = contentBtn;
    } else {
        [contentLbl co_withinParent];
    }
    self.contentLbl = contentLbl;
}

- (void)initPhotoView {
    UIView *photoView = [self createRightViewSubview];
    self.photoView = photoView;
    [photoView co_topFromBottomOfView:[photoView co_preSiblingView] offset:9];
    photoView.clipsToBounds = YES;
    [photoView co_height:[self photoViewHeight]];
    [photoView addTapGestureRecognizer:self action:@selector(onPhotoViewClicked:)];
    
    if ([self isModeCalcHeight]) {
        return;
    }
    self.photos = [NSMutableArray array];
    if ([self is9PhotoLayout]) {
        CGFloat photoWidth = PHOTO_WIDTH_9_PHOTO_MODE;
        CGFloat photoHeight = photoWidth;
        CGFloat photoMargin = PHOTO_MARGIN_9_PHOTO_MODE;
        for (int i = 0; i < MAX_DISPLAY_PHOTO_COUNT; i++) {
            CGFloat x = (i % 3) * (photoWidth + photoMargin);
            CGFloat y = (i / 3) * (photoHeight + photoMargin);
            UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, photoWidth, photoHeight)];
            [photoView addSubview:photo];
            [self.photos addObject:photo];
        }
    } else {
        UIImageView *photo = [photoView createSubViewImageView];
        photo.contentMode = UIViewContentModeCenter;
        [photo co_insetsParent:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.photos addObject:photo];
    }
}

- (void)initTagView {
    UIView *tagView = [self createRightViewSubview:0];
    CGFloat vMargin = 12.0;
    [tagView co_height:(2 * vMargin + 18)];
    if ([self isModeCalcHeight]) {
        return;
    }
    UILabel *tagsLbl = [tagView createSubViewLabelWithFontSize:12 textColor:@"999999".co_toHexColor];
    [[tagsLbl co_leftParent] co_centerYParent];
    [tagsLbl co_width:CONTENT_WIDTH];
    self.tagsLbl = tagsLbl;
}

- (void)initPriceView {
    UIView *priceView = [self createRightViewSubview:0];
    // 设置默认高度
    [priceView co_height:0];
    UILabel *priceLbl = [priceView createSubViewLabelWithFontSize:12 textColor:@"999999".co_toHexColor];
    [[priceLbl co_leftParent] co_topParent];
    self.priceLbl = priceLbl;
}

- (void)initFunctionView {
    UIView *functionView = [self createRightViewSubview:0];
    [functionView co_height:[self functionViewHeight]];
    self.functionView = functionView;
    if ([self isModeCalcHeight]) {
        // 加上底部约束这样parentView的高度才能确定(functionView是最后一个子view)
        [self.functionView co_bottomParent];
        return;
    }
    
    [self initFunctionViewModules];
    [self initFunctionViewLayout];
    
//    functionView.backgroundColor = [UIColor blueColor];
}

- (void)initFunctionViewModules {
    UIView *upView = [self createImageLblView:self.functionView imageName:UP_LBL_IMAG_NORMAL];
    self.upsImage = upView.subviews[0];
    self.upsLbl = upView.subviews[1];
    [upView addTapGestureRecognizer:self action:@selector(onUpViewClicked:)];
    
    UIView *commentView = [self createImageLblView:self.functionView imageName:@"Short_Article_List_Comment"];
    self.commentLbl = commentView.subviews[1];
    [commentView addTapGestureRecognizer:self action:@selector(onCommentViewClicked:)];
    
    if ([UIViewController mzl_shouldShowShareShortArticleModule]) {
        UIView *shareView = [self createImageLblView:self.functionView imageName:@"Short_Article_List_Share"];
        [shareView addTapGestureRecognizer:self action:@selector(onShareClicked:)];
    }
}

- (void)initFunctionViewLayout {
    
    NSInteger startIndex = self.functionView.subviews.count - 1;
    for (int i = startIndex; i >= 0; i --) {
        UIView *subview = self.functionView.subviews[i];
        if (i == startIndex) {
            [subview co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, 0, 0)];
        } else {
            UIView *nextView = self.functionView.subviews[i + 1];
            [subview co_centerYParent];
            [subview co_rightFromLeftOfView:nextView offset:20];
        }
    }
}

- (CGFloat)functionViewHeight {
    return 20.0;
}

- (UIView *)createImageLblView:(UIView *)superview imageName:(NSString *)imageName {
    UIView *view = [superview createSubView];
    CGFloat height = [self functionViewHeight];
    [view co_height:height];
    UIImageView *image = [view createSubViewImageViewWithImageNamed:imageName];
    [[image co_leftParent] co_centerYParent];
    [image co_width:height height:height];
    UILabel *lbl = [view createSubViewLabelWithFontSize:14 textColor:FUNC_LBL_TEXTCOLOR_NORMAL.co_toHexColor];
    [[lbl co_rightParent] co_centerYParent];
    [lbl co_leftFromRightOfView:image offset:6];
    
//    view.backgroundColor = [UIColor greenColor];
//    image.backgroundColor = [UIColor orangeColor];
    return view;
}

#pragma mark - update

- (void)updateWithModel:(MZLModelShortArticle *)model {
    self.model = model;
    [self updateAuthor];
    [self updateDate];
    [self updateAddress];
    [self updateContent];
    [self updatePhotos];
    [self updateTags];
    [self updatePrice];
    [self updateCommentAndUps];
}

- (void)updateAuthor {
    self.nameLbl.text = self.model.author.nickName;
    if ([self isModeDisplay]) {
        [self.authorImage loadAuthorImageFromURL:self.model.author.headerImage.fileUrl];
    }
}

- (void)updateDate {
    self.dateLbl.text = self.model.publishedAtStr;
}

- (void)updateAddress {
//    self.addressLbl.text = self.model.location.locationName;
    if ([self isModeDisplay]) {
        [self.addressBtn setTitle:self.model.location.locationName forState:UIControlStateNormal];
        self.distanceLbl.text = [self.model.location distanceInKm];
    }
}

- (void)updateContent {
    if ([self isLongContentLayout]) {
        if (self.model.isViewAll) {
            self.contentLbl.numberOfLines = 0;
            [self.contentBtn setTitle:@"收起全文" forState:UIControlStateNormal];
        } else {
            self.contentLbl.numberOfLines = CONTENT_MAX_LINES;
            [self.contentBtn setTitle:CONTENT_READ_ALL_TEXT forState:UIControlStateNormal];
        }
    }
    self.contentLbl.text = [MZLShortArticleCell contentFromModel:self.model];
}

- (void)updatePhotos {
    if ([self isModeDisplay]) {
        for (UIView *photoImage in self.photos) {
            photoImage.hidden = YES;
        }
        NSArray *photos = self.model.sortedPhotos;
        for (int i = 0; i < photos.count && i < self.photos.count; i ++) {
            MZLModelImage *image = photos[i];
            UIImageView *photoImage = self.photos[i];
            photoImage.hidden = NO;
            if ([self is9PhotoLayout]) {
                [photoImage loadSmallLocationImageFromURL:image.fileUrl];
            } else {
                [self.ownerController mzl_loadSingleImageWithImageView:photoImage fileUrl:image.fileUrl];
            }
        }
    }
    [self.photoView co_updateHeight:[self photoViewHeight]];
}

- (void)updateTags {
    self.tagsLbl.text = self.model.tags;
}

- (void)updatePrice {
    NSString *priceFormat = @"RMB %d/人";
    UIView *priceView = self.priceLbl.superview;
    CGFloat vMargin = 8.0;
    if (self.model.consumption > 0) {
        [priceView co_updateHeight:(15.0 + vMargin)];
        self.priceLbl.text = [NSString stringWithFormat:priceFormat, self.model.consumption];
    } else {
        [priceView co_updateHeight:0.0];
        self.priceLbl.text = @"";
    }
}

- (void)updateCommentAndUps {
    [self updateLbl:self.commentLbl withCount:self.model.commentsCount];
    [self toggleUpImage:self.model.isUpForCurrentUser];
    [self updateLbl:self.upsLbl withCount:self.model.upsCount];
    if ([self needsGetUpStatusForCurrentUser]) {
        [self getUpStatus];
    }
}

- (void)updateLbl:(UILabel *)label withCount:(NSInteger)count {
    label.hidden = NO;
    if (count > 0) {
        label.text = INT_TO_STR(count);
    } else {
        label.hidden = YES;
        label.text = @"0";
    }
}

#pragma mark - misc

- (BOOL)isModeCalcHeight {
    return self.mode == MZLShortArticleCellModeCalcHeight;
}

- (BOOL)isModeDisplay {
    return self.mode == MZLShortArticleCellModeDisplay;
}

- (CGFloat)photoViewHeight {
    CGFloat heightFor1PhotoMode = 230;
    if (self.model) {
        NSInteger photoCount = MIN(self.model.photos.count, MAX_DISPLAY_PHOTO_COUNT);
        if (photoCount == 1) {
            return heightFor1PhotoMode;
        } else {
            NSInteger temp = (photoCount - 1) / 3;
            return temp * PHOTO_MARGIN_9_PHOTO_MODE + (temp + 1) * PHOTO_WIDTH_9_PHOTO_MODE;
        }
    } else {
        if ([self is9PhotoLayout]) {
            return 3 * PHOTO_WIDTH_9_PHOTO_MODE + 2 * PHOTO_MARGIN_9_PHOTO_MODE;
        } else {
            return heightFor1PhotoMode;
        }
    }
}

+ (BOOL)isLongContentFor:(MZLModelShortArticle *)article {
    NSString *content = [self contentFromModel:article];
    if (isEmptyString(content)) {
        return NO;
    }
    NSInteger lineCount = [content co_numberOfLinesConstrainedToWidth:CONTENT_WIDTH withFont:MZL_FONT(CONTENT_FONT_SIZE)];
    return lineCount > CONTENT_MAX_LINES;
}

+ (NSString *)contentFromModel:(MZLModelShortArticle *)model {
    NSString *content = model.content;
    if (isEmptyString(content)) {
        return content;
    }
    content = [content co_strip];
    return content;
}

- (BOOL)is9PhotoLayout {
    return [self.reuseIdentifier isEqualToString:MZLSAC_ReuseId9PhotoLongContent] || [self.reuseIdentifier isEqualToString:MZLSAC_ReuseId9PhotoShortContent];
}

- (BOOL)isLongContentLayout {
    return [self.reuseIdentifier isEqualToString:MZLSAC_ReuseId1PhotoLongContent] || [self.reuseIdentifier isEqualToString:MZLSAC_ReuseId9PhotoLongContent];
}

- (void)toggleUpImage:(BOOL)flag {
    if (flag) {
        self.upsImage.image = [UIImage imageNamed:UP_LBL_IMAG_HI];
        self.upsLbl.textColor = UP_LBL_TEXTCOLOR_HI.co_toHexColor;
    } else {
        self.upsImage.image = [UIImage imageNamed:UP_LBL_IMAG_NORMAL];
        self.upsLbl.textColor = FUNC_LBL_TEXTCOLOR_NORMAL.co_toHexColor;
    }
}

- (void)toggleUpStatus {
    [self toggleUpImage:self.model.isUpForCurrentUser];
    [self updateLbl:self.upsLbl withCount:self.model.upsCount];
}

- (BOOL)needsGetUpStatusForCurrentUser {
    return [self isModeDisplay] && self.model.needsGetUpStatusForCurrentUser;
}

- (MZLModelShortArticle *)model {
    return _model;
}

- (void)setModel:(MZLModelShortArticle *)model {
    [IBMessageCenter removeMessageListenersForTarget:self];
    [IBMessageCenter addMessageListener:MZL_NOTIFICATION_SINGLE_SHORT_ARTICLE_UP_STATUS_MODIFIED source:model target:self action:@selector(onUpStatusModified)];
    [IBMessageCenter addMessageListener:MZL_NOTIFICATION_SINGLE_SHORT_ARTICLE_COMMENT_STATUS_MODIFIED source:model target:self action:@selector(onCommentStatusModified)];
    _model = model;
}

- (void)onUpStatusModified {
    [self updateCommentAndUps];
}

- (void)onCommentStatusModified {
    [self updateCommentAndUps];
}

#pragma mark - events handler 

- (void)toggleContentStatus:(UIButton *)sender {
    // 短文全文阅读和收起
    self.model.isViewAll = ! self.model.isViewAll;
    NSIndexPath *indexPath = [self.ownerTable indexPathForCell:self];
    if (indexPath) {
        [self.ownerTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
//    [self.ownerTable reloadData];
}

- (void)onCommentViewClicked:(UITapGestureRecognizer *)tap {
    if (shouldPopupLogin()) {
        [self.ownerController popupLoginFrom:MZLLoginPopupFromComment executionBlockWhenDismissed:^{
            [self toShortArticleDetailComment];
        }];
        return;
    }
    [self toShortArticleDetailComment];
}

- (void)onUpViewClicked:(UITapGestureRecognizer *)tap {
    if (self.model.isUpForCurrentUser) {
        self.model.upsCount = self.model.upsCount - 1;
        self.model.isUpForCurrentUser = NO;
        [self removeUp];
        [tap.view co_animation_layerScale:1.1 delegate:self];
//        [self toggleUpStatus];
    } else {
        self.model.upsCount = self.model.upsCount + 1;
        self.model.isUpForCurrentUser = YES;
        [self addUp];
        [tap.view co_animation_layerScale:1.1 delegate:self];
    }
}

- (void)onShareClicked:(UITapGestureRecognizer *)tap {
    [self.ownerController mzl_shareShortArticle:self.model];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self toggleUpStatus];
    }
}

- (void)onPhotoViewClicked:(UITapGestureRecognizer *)tap {
    [self.ownerController mzl_toShortArticlePhotoGallery:self.model];
}

#pragma mark - service related

- (void)addUp {
    [MZLServices addUpForShortArticle:self.model succBlock:^(NSArray *models) {
        // ignore
    } errorBlock:^(NSError *error) {
        // ignore
    }];
}

- (void)getUpStatus {
    MZLModelShortArticle *shortArticle = self.model;
    __weak MZLShortArticleCell *weakSelf = self;
    [MZLServices upStatusForShortArticle:shortArticle succBlock:^(NSArray *models) {
        if (models && models.count > 0) {
            MZLShortArticleUpResponse *response = models[0];
            shortArticle.isUpForCurrentUser = (response.up != nil);
            if (shortArticle.identifier == weakSelf.model.identifier) {
                [self toggleUpImage:shortArticle.isUpForCurrentUser];
            }
        }
    } errorBlock:^(NSError *error) {
        // ignore
    }];
}

- (void)removeUp {
    MZLModelShortArticle *shortArticle = self.model;
    [MZLServices removeUpForShortArticle:shortArticle succBlock:^(NSArray *models) {
        // ignore
    } errorBlock:^(NSError *error) {
        // ignore
    }];
}

@end


@implementation MZLShortArticleCellAuthor

- (void)initInternal {
    UIView *bg = [[self.contentView createSubView] co_offsetParent:CELL_MARGIN];
    [bg addTapGestureRecognizer:self action:@selector(toShortArticleDetail)];
    UIView *leftView = [[bg createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, 0, COInvalidCons) width:LEFT_VIEW_WIDTH height:COInvalidCons];
    
    UIView *topView = [[bg createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0) width:COInvalidCons height:26.0];
    self.topView = topView;
    
    UIView *rightView = [[bg createSubView] co_insetsParent:UIEdgeInsetsMake(26.0, COInvalidCons, 0, 0)];
    self.rightView = rightView;
    [rightView co_leftFromRightOfView:leftView offset:0];
    
    [self initRightView];
}

- (void)initRightView{
    [self initNameDateView];
    [self initAddressView];
    [self initContentView];
    [self initPhotoView];
    [self initTagView];
    [self initPriceView];
    [self initFunctionView];
}

- (void)initNameDateView {
    UIView *nameDateView = [[self.rightView createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0) width:COInvalidCons height:0.0];
    if ([self isModeCalcHeight]) {
        return;
    }
}
- (void)initAddressView{
    UIView *addressView = [[self.topView createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0) width:COInvalidCons height:26.0];
    [addressView co_topFromBottomOfPreSiblingWithOffset:12.0];
    
    UIButton *addressBtn = [addressView createSubViewBtn];
    addressBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 6, 3, 6);
    [addressBtn co_centerButtonAndImageWithSpacing:6.0];
    [addressBtn co_setCornerRadius:4.0];
    addressBtn.titleLabel.font = MZL_FONT(14.0);
    [addressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addressBtn setImage:[UIImage imageNamed:@"Short_Article_List_Style2_Location"] forState:UIControlStateNormal];
    [addressBtn co_setNormalBgColor:@"64A3DC".co_toHexColor];
    [addressBtn co_setHighlightBgColor: @"4993DB".co_toHexColor];

    [addressBtn co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, COInvalidCons)];
    [addressBtn co_centerYParent];
    [addressBtn addTarget:self action:@selector(toLocationDetail) forControlEvents:UIControlEventTouchUpInside];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_lessThanOrEqualTo(180.0);
    }];
    self.addressBtn = addressBtn;
    
    UILabel *distanceLbl = [addressView createSubViewLabelWithFontSize:12 textColor:@"B9B9B9".co_toHexColor];
    [[distanceLbl co_bottomParent:5.0] co_leftFromRightOfPreSiblingWithOffset:6.0];
    self.distanceLbl = distanceLbl;
    
    UILabel *dateLbl = [addressView createSubViewLabelWithFontSize:12 textColor:@"CCCCCC".co_toHexColor];
    dateLbl.textAlignment = NSTextAlignmentRight;
    [[dateLbl co_insetsParent:UIEdgeInsetsMake(COInvalidCons, COInvalidCons, 0, 0) width:80 height:COInvalidCons] co_bottomParent:5.0];
    self.dateLbl = dateLbl;
}

@end

@implementation MZLShortArticleCellLocation

// 主要是去掉Address
- (void)initAddressView {
}

- (void)updateAddress {
}

@end

@interface MZLShortArticleCellMy () {
    UIImageView *_deleteArticleIcon;
}

@end

@implementation MZLShortArticleCellMy

- (void)initInternal {
    UIView *bg = [[self.contentView createSubView] co_offsetParent:CELL_MARGIN];
    [bg addTapGestureRecognizer:self action:@selector(toShortArticleDetail)];
    UIView *leftView = [[bg createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, 0, COInvalidCons) width:LEFT_VIEW_WIDTH height:COInvalidCons];
    //    self.leftView = leftView;
    
    UIView *topView = [[bg createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0) width:COInvalidCons height:26.0];
    self.topView = topView;
    
    UIView *rightView = [[bg createSubView] co_insetsParent:UIEdgeInsetsMake(26.0, COInvalidCons, 0, 0)];
    self.rightView = rightView;
    [rightView co_leftFromRightOfView:leftView offset:0];
    
    [self initRightView];
}

- (void)initRightView{
    [self initNameDateView];
    [self initAddressView];
    [self initContentView];
    [self initPhotoView];
    [self initTagView];
    [self initPriceView];
    [self initFunctionView];
}

- (void)initNameDateView {
    UIView *nameDateView = [[self.rightView createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0) width:COInvalidCons height:0.0];
    if ([self isModeCalcHeight]) {
        return;
    }
}
- (void)initAddressView{
    UIView *addressView = [[self.topView createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0) width:COInvalidCons height:26.0];
    [addressView co_topFromBottomOfPreSiblingWithOffset:12.0];
    
    UIButton *addressBtn = [addressView createSubViewBtn];
    addressBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 6, 3, 6);
    [addressBtn co_centerButtonAndImageWithSpacing:6.0];
    [addressBtn co_setCornerRadius:4.0];
    addressBtn.titleLabel.font = MZL_FONT(14.0);
    [addressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addressBtn setImage:[UIImage imageNamed:@"Short_Article_List_Style2_Location"] forState:UIControlStateNormal];
    [addressBtn co_setNormalBgColor:@"64A3DC".co_toHexColor];
    [addressBtn co_setHighlightBgColor: @"4993DB".co_toHexColor];
    [addressBtn co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, COInvalidCons)];
    [addressBtn co_centerYParent];
    [addressBtn addTarget:self action:@selector(toLocationDetail) forControlEvents:UIControlEventTouchUpInside];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_lessThanOrEqualTo(150.0);
    }];
    self.addressBtn = addressBtn;
    
    UILabel *distanceLbl = [addressView createSubViewLabelWithFontSize:12 textColor:@"B9B9B9".co_toHexColor];
    [[distanceLbl co_bottomParent:5.0] co_leftFromRightOfPreSiblingWithOffset:6.0];
    self.distanceLbl = distanceLbl;
    
    UILabel *dateLbl = [addressView createSubViewLabelWithFontSize:12 textColor:@"CCCCCC".co_toHexColor];
    dateLbl.textAlignment = NSTextAlignmentRight;
    [[dateLbl co_insetsParent:UIEdgeInsetsMake(COInvalidCons, COInvalidCons, 0, 0) width:80 height:COInvalidCons] co_bottomParent:5.0];
    self.dateLbl = dateLbl;
}

- (void)initFunctionViewModules {
    [super initFunctionViewModules];
    UIView *deleteView = [self createImageLblView:self.functionView imageName:@"Short_Article_DeleteArticle"];
    [deleteView addTapGestureRecognizer:self action:@selector(onDeleteShortArticle:)];
}

- (void)onDeleteShortArticle:(UITapGestureRecognizer *)tap {
    [IBAlertView showAlertWithTitle:@"提示" message:@"确定删除？" dismissTitle:MZL_MSG_CANCLE okTitle:MZL_MSG_OK dismissBlock:^{
        
    } okBlock:^{
        [self deleteShortArticle];
    }];
}

- (void)deleteShortArticle {
    NSIndexPath *indexPath = [self.ownerTable indexPathForCell:self];
    if (indexPath) {
        [self.ownerController mzl_removeShortArticleAtIndexPath:indexPath];
    }
}

@end


