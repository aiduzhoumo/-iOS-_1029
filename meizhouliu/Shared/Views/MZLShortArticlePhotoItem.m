//
//  MZLShortArticlePhotoItem.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-8.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLShortArticlePhotoItem.h"
#import "UIView+MZLAdditions.h"
#import "MZLPhotoItem.h"
#import "COAssets.h"
#import <IBMessageCenter.h>
#import "MZLShortArticleContentVC.h"
#import "UIImage+COAdditions.h"

#define PHOTO_SIZE CGSizeMake(64, 64)

@interface MZLShortArticlePhotoItem () {
    __weak UIView *_coverView;
    __weak UIView *_cameraView;
    __weak UIImageView *_photo;
    __weak UIImageView *_statusImage;
    __weak UIView *_bg;
}

@property (nonatomic, weak) MZLPhotoItem *photoItem;
@property (nonatomic, assign) BOOL isEditMode;

@end

@implementation MZLShortArticlePhotoItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        [self initInternal];
//    }
//    return self;
//}

// init内部会调用initWithFrame(CGRectZero)
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initInternal];
    }
    return self;
}

- (void)initInternal {
    self.layer.cornerRadius = 3.0;
    self.clipsToBounds = YES;
    UIView *bg = [self createSubView];
    _bg = bg;
//    bg.backgroundColor = [UIColor blackColor];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(bg.superview);
    }];
    UIImageView *photo = [bg createSubViewImageView];
    _photo = photo;
    [photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(photo.superview);
    }];
    [photo addTapGestureRecognizer:self action:@selector(onPhotoImageClicked:)];
    
    UIView *statusView = [bg createSubView];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(statusView.superview);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [statusView addTapGestureRecognizer:self action:@selector(onStatusViewClicked:)];
    UIImageView *statusImage = [statusView createSubViewImageView];
    _statusImage = statusImage;
    [statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(statusImage.superview);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    UIView *cameraView = [bg createSubView];
    [cameraView addTapGestureRecognizer:self action:@selector(takePhoto)];
    _cameraView = cameraView;
    cameraView.backgroundColor = colorWithHexString(@"#4d5c69");
    [cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(cameraView.superview);
    }];
    UIImageView *image = [cameraView createSubViewImageViewWithImageNamed:@"Short_Article_Camera"];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(image.superview);
        make.size.mas_equalTo(PHOTO_SIZE);
    }];
    _cameraView.hidden = YES;
    
    UIView *coverView = [bg createSubView];
    _coverView = coverView;
    coverView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(coverView.superview);
    }];
    coverView.hidden = YES;
}

- (void)initEditView {
    UIView *editView = [_bg createSubView];
    editView.userInteractionEnabled = NO;
    [editView co_insetsParent:UIEdgeInsetsMake(COInvalidCons, COInvalidCons, 0, 0) width:30.0 height:30.0];
    UIImageView *editImage = [editView createSubViewImageViewWithImageNamed:@"Short_Article_Edit"];
    [[editImage co_centerParent] co_width:24.0 height:24.0];
}

+ (instancetype)editInstanceWithPhoto:(MZLPhotoItem *)photoItem {
    MZLShortArticlePhotoItem *result = [[MZLShortArticlePhotoItem alloc] init];
    result.isEditMode = YES;
    [result initEditView];
    [result updateInEditModeWithPhotoItem:photoItem];
    return result;
}

- (void)updateInEditModeWithPhotoItem:(MZLPhotoItem *)photoItem {
    self.photoItem = photoItem;
    _statusImage.image = [UIImage imageNamed:@"Short_Article_Delete"];
    UIImage *image = [COAssets co_thumbnailImageFromAsset:photoItem.asset];
    // 加入滤镜
//    image = [image co_applyChromeFilter];
    _photo.image = image;
}

- (void)showTuSDKEditedPhoto:(UIImage *)editedImage {
    UIImage *scaledImage = [editedImage scaledToSize:PHOTO_SIZE];
    _photo.image = scaledImage;
//    _photo.image = editedImage;
}

- (void)updateWithPhoto:(MZLPhotoItem *)photoItem isDisabled:(BOOL)isDisabled {
    self.photoItem = photoItem;
    _cameraView.hidden = YES;
    if (! photoItem) {
        _cameraView.hidden = NO;
    } else {
        UIImage *image = [COAssets co_thumbnailImageFromAsset:photoItem.asset];
        _photo.image = image;
    }
    [self updateWithDisabledFlag:isDisabled];
    [self updateStatusDisplay];
}

- (void)updateWithDisabledFlag:(BOOL)isDisabled {
    if (isDisabled && ! self.photoItem.isSelected) {
        _coverView.hidden = NO;
    } else {
        _coverView.hidden = YES;
    }
}

- (void)updateStatusDisplay {
    if (self.photoItem.isSelected) {
        _statusImage.image = [UIImage imageNamed:@"Short_Article_Photo_Selected"];
    } else {
        _statusImage.image = [UIImage imageNamed:@"Short_Article_Photo_Unselected"];
    }
}

#pragma mark - take new photos 

- (void)takePhoto {
    // forward message to controller
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_SA_TAKE_PHOTO];
}

#pragma mark - photo image related

- (void)onPhotoImageClicked:(UITapGestureRecognizer *)tap {
//    if (! self.isEditMode) {
//        [self toggleStatus];
//    }
    if (self.isEditMode) {
        NSDictionary *userInfo = @{
                                   MZL_SA_KEY_PHOTO_ITEM_VIEW : self
                                   };
        [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_SA_TUSDK_EDIT_PHOTO withUserInfo:userInfo];
    } else {
        [self toggleStatus];
    }
}

#pragma mark - status view related

- (void)onStatusViewClicked:(UITapGestureRecognizer *)tap {
    if (self.isEditMode) {
        [self onEdit];
    } else {
        [self toggleStatus];
    }
}

- (void)onEdit {
    self.photoItem.state = UNSELECTED;
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_SA_PHOTO_REMOVED withUserInfo:@{MZL_SA_KEY_PHOTO_ITEM : self.photoItem}];
}

- (void)toggleStatus {
    if (self.photoItem.isSelected) {
        self.photoItem.state = UNSELECTED;
    } else {
        self.photoItem.state = SELECTED;
    }
//    [self updateStatusDisplay];
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_SA_PHOTO_STATUS_MODIFIED withUserInfo:@{MZL_SA_KEY_PHOTO_ITEM : self.photoItem}];
}


#pragma mark - misc

- (MZLPhotoItem *)associatedPhotoItem {
    return self.photoItem;
}

@end
