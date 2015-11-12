//
//  MZLSelectedRouteCell.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-21.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLSelectedRouteCell.h"
#import "MZLModelUserLocationPref.h"
#import "MZLServices.h"
#import "MZLModelLocationBase.h"
#import "UIViewController+MZLAdditions.h"
#import "MZLUserLocPrefResponse.h"
#import "MZLArticleDetailNavVwController.h"
#import "MobClick.h"
#import "MZLLoginViewController.h"

#define MAX_LINES_LBL_LOCATION 2
#define MAX_WIDTH_LBL_LOCATION 142.0
#define MAX_WIDTH_LBL_ADDRESS 146.0

#define HEIGHT_LOCATION_SINGLELINE 24.0
#define HEIGHT_ADDRESS_SINGLELINE 14.0

#define HEIGHT_DEFAULT_IMGDOTTOP 15.0

@interface MZLSelectedRouteCell() {
    BOOL _isInterested;
}

@end

@implementation MZLSelectedRouteCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    
    [self.vwInterest addTapGestureRecognizer:self action:@selector(toggleWant)];
    [self.vwPlay addTapGestureRecognizer:self action:@selector(onVwPlayClicked)];
    [self.lblLocation addTapGestureRecognizer:self action:@selector(clickSelectedRouterCellInnerUpLabel)];
    [self.lblAddress addTapGestureRecognizer:self action:@selector(clickSelectedRouterCellInnerUpLabel)];
}

- (void)initCellColors{
    self.lblLocation.textColor = MZL_COLOR_BLACK_555555();
    self.lblAddress.textColor = MZL_COLOR_BLACK_999999();
    self.lblPlayTip1.textColor = MZL_COLOR_GREEN_61BAB3();
    self.lblPlayTip2.textColor = MZL_COLOR_GREEN_61BAB3();
    self.lblPlay.textColor = colorWithHexString(@"de8585");
}

- (void)toggleWant {
    // 当为不想去->想去的时候才弹框，避免登录以后的数据不一致
    if (shouldPopupLogin()) {
        self.ownerController.targetLocationRouteInfo = [self.ownerController getSelectedLocation];
        [self.ownerController.parentViewController popupLoginFrom:MZLLoginPopupFromInterestedLocation executionBlockWhenDismissed:nil];
        return;
    }
    [self _toggleWant];
}

- (void)_toggleWant {
    [self.ownerController showWorkInProgressIndicator];
    if (_userLocPref) {
        [MZLServices removeFavoredLocation:_userLocPref succBlock:^(NSArray *models) {
            [self onServiceSucceed:nil];
        } errorBlock:^(NSError *error) {
            [self onServiceFailed:error];
        }];
    } else {
        [MZLServices addLocationAsFavored:self.location.identifier succBlock:^(NSArray *models) {
            [self onServiceSucceed:models[0]];
        } errorBlock:^(NSError *error) {
            [self onServiceFailed:error];
        }];
    }
    [MobClick event:@"clickArticleDetailWant"];
}

- (void)onServiceSucceed:(MZLUserLocPrefResponse *)response {
    [self onSeriveFinished];
    if (response.userLocationPref) {
        [self.ownerController addArticleFavoredLocation:response.userLocationPref];
    } else {
        [self.ownerController removeArticleFavoredLocation:self.userLocPref];
    }
    [self.ownerController showNotiTipOnFavoredLocStatusChanged:response.userLocationPref];
    [self setUserLocPref:response.userLocationPref];
}

- (void)onServiceFailed:(NSError *)error {
    [self.ownerController onPostError:error];
}

- (void)onSeriveFinished {
    [self.ownerController hideProgressIndicator];
}

- (void)toggleImage {
    self.imgInterest.image = [self.ownerController imageForFavoredLocation:_userLocPref];
}

- (void)setUserLocPref:(MZLModelUserLocationPref *)userLocPref {
    _userLocPref = userLocPref;
    [self toggleImage];
}

- (void)clickSelectedRouterCellInnerUpLabel {
    [MobClick event:@"clickArticleDetailSidebarPOIUh"];
    [self toLocationDetail];
}

- (void)onVwPlayClicked {
    [MobClick event:@"clickArticleDetailSidebarPOIDh"];
    [self toLocationDetail];
}

- (void)toLocationDetail {
    if (self.ownerController && self.location) {
        MZLArticleDetailNavVwController *controller = (MZLArticleDetailNavVwController *)self.ownerController;
        [controller toLocationDetail:self.location];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)fitHeightForLabel:(UILabel *)lbl maxWidth:(CGFloat)maxWidth {
    CGSize size = [lbl sizeThatFits:CGSizeMake(maxWidth, 0.0)];
    return size.height;
}

- (void)adjustLayout {
    self.lblLocation.numberOfLines = 0;
    self.lblLocation.font = MZL_BOLD_FONT(20.0);
    CGFloat locationHeight = [self fitHeightForLabel:self.lblLocation maxWidth:MAX_WIDTH_LBL_LOCATION];
    if (locationHeight > HEIGHT_LOCATION_SINGLELINE) {
        self.lblLocation.numberOfLines = MAX_LINES_LBL_LOCATION;
        if (locationHeight > MAX_LINES_LBL_LOCATION * HEIGHT_LOCATION_SINGLELINE) { // 超过两行，缩小字体
            self.lblLocation.font = MZL_BOLD_FONT(16.0);
        }
    } else {
        self.lblLocation.numberOfLines = 1;
    }
    CGFloat addressHeight = [self fitHeightForLabel:self.lblAddress maxWidth:MAX_WIDTH_LBL_ADDRESS];
    if (self.lblLocation.numberOfLines == MAX_LINES_LBL_LOCATION || addressHeight > HEIGHT_ADDRESS_SINGLELINE) {
        self.cImgDotTop.constant = 8.0;
    } else {
        self.cImgDotTop.constant = HEIGHT_DEFAULT_IMGDOTTOP;
    }
}

- (CGFloat)fitHeight {
    [self adjustLayout];
    CGFloat result = HEIGHT_SELECTED_ROUTE_CELL;
    result = result - HEIGHT_DEFAULT_IMGDOTTOP + self.cImgDotTop.constant;
    if (self.lblLocation.numberOfLines == MAX_LINES_LBL_LOCATION) {
        result += HEIGHT_LOCATION_SINGLELINE;
    }
    result = result - HEIGHT_ADDRESS_SINGLELINE;
    CGFloat addressHeight = [self fitHeightForLabel:self.lblAddress maxWidth:MAX_WIDTH_LBL_ADDRESS];
    result += addressHeight;
    return result;
}

@end
