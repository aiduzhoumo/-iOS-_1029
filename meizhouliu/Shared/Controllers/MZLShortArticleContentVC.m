//
//  MZLShortArticleContentVC.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLShortArticleContentVC.h"
#import "UIView+MZLAdditions.h"
#import "UIButton+COAddition.h"
#import "UILabel+COAdditions.h"
#import "UITextView+COAddition.h"
#import "COKeyboardToolbar.h"
#import "MZLAlertView.h"
#import "UIImage+BlurredFrame.h"
#import "UIImage+COAdditions.h"
#import "MZLShortArticlePhotoViewCell.h"
#import "MZLPhotoItem.h"
#import "MZLShortArticlePhotoItem.h"
#import <IBMessageCenter.h>
#import <IBDispatchMessage.h>
#import "MZLShortArticlePhotoScrollEditView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MZLServices.h"
#import "MZLImageUploadResponse.h"
#import "MZLPhotoUploadingQueue.h"
#import "MZLModelShortArticle.h"
#import <IBAlertView.h>
#import "MZLShortArticleTagsVC.h"
#import <TuSDK/TuSDK.h>

#define PHOTO_VIEW_MIN_TOP_OFFSET 120
//#define KEYBOARD_HEIGHT 293
#define PHOTO_VIEW_PROP_FRAME_Y @"PHOTO_VIEW_PROP_FRAME_Y"
#define PHOTO_VIEW_POS_TOP 1
#define PHOTO_VIEW_POS_MIDDLE 2
#define PHOTO_VIEW_POS_BOTTOM 3

#define ADD_PHOTO_FROM_INPUT_TOOLBAR 1001
#define ADD_PHOTO_FROM_BOTTOM_TOOLBAR 1002

@interface MZLShortArticleContentVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, TuSDKFilterManagerDelegate, TuSDKPFEditTurnAndCutDelegate> {
    __weak UIView *_topView;
    __weak UIScrollView *_contentScroll;
    __weak UITextView *_textView;
    __weak UIView *_photoView;
    __weak UITableView *_photoScroll;
    __weak UIView *_topBlurBg;
    __weak UIView *_topBlurView;
    __weak UIImageView *_topBlurImage;
    __weak UIView *_noPhotoView;
    __weak UIView *_photoTipView;
    __weak COKeyboardToolbar *_photoBottomToolbar;
    
    __weak MZLShortArticlePhotoScrollEditView *_photoEditView;
    
    NSMutableArray *_photos;
    NSMutableArray *_selectedPhotos;
    MZLPhotoUploadingQueue *_photoUploadQueue;
    
    BOOL _shouldShowPhotoView;
    BOOL _shouldShowPhotoBottomToolbar;
    
    BOOL _takeNewPhotoFlag;
    
    // 需要过滤的内容关键字
    NSString *_contentKeywords;
    // 用于TuSDK图片编辑后刷新图片
    __weak MZLShortArticlePhotoItem *_activeEditedPhotoItem;
}

/** current keyboard bounds */
@property (nonatomic, assign) CGRect curKbBounds;

@end

@implementation MZLShortArticleContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self internalInit];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 如果没有显示toolbar，则显示photoView
    if (! [self isBottomToolbarVisible]) {
        [self movePhotoViewToMiddle];
    }
    if (! _topBlurImage.image) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIImage *toImage = [UIImage co_screenshotFromLayer:self.view.layer];
            toImage = [toImage co_cropInRect:_topBlurImage.frame];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *blurredSnapshot = [toImage co_blurredImage:5.0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self onTopBlurImageGenerated:blurredSnapshot];
                });
            });
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self co_removeFromNotificationCenter];
    [IBMessageCenter removeMessageListenersForTarget:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toNextStep"]) {
        MZLShortArticleTagsVC *destVc = (MZLShortArticleTagsVC *)segue.destinationViewController;
        destVc.model = self.model;
    }
    
}

#pragma mark - init

- (void)internalInit {
    [self initTuSDK];
    _photoUploadQueue = [[MZLPhotoUploadingQueue alloc] init];
    _contentKeywords = [COPreferences getUserPreference:MZL_KEY_CACHED_KEYWORDS];
    [self initUI];
    [self initEvents];
    [self loadPhotosFromSystem];
    [self co_registerKeyboardNotification];
    [self registerAssetsChangedNoti];
    [self registerCustomEvents];
}

- (void)initTuSDK {
    [self showNetworkProgressIndicator:@"图片控件初始化..."];
    [TuSDK checkManagerWithDelegate:self];
}

- (void)initEvents {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hidePhotoView)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
}

- (void)hidePhotoView {
    // 照片浏览状态，不hide
    if (_photoView.frame.origin.y <= [self photoViewTopY]) {
        return;
    }
    [self movePhotoViewToBottom];
    [self showBottomToolbar];
}

#pragma mark - photo handling

- (void)loadPhotosFromSystem {
    [COAssets co_loadAssetsFromSystem:self];
}

- (void)onFailedToLoadAssets:(NSError *)error {
    UILabel *lbl = _photoTipView.subviews[0];
    lbl.text = @"照片加载失败";
    [UIAlertView showAlertMessage:@"请开启照片访问权限！"];
}

- (void)onAssetsLoaded:(NSArray *)assets {
    NSArray *photos = [assets map:^id(ALAsset *asset) {
        return [MZLPhotoItem instanceWithAsset:asset];
    }];
    photos = [MZLPhotoItem sortWithAssetDate:photos];
    _photoTipView.hidden = YES;
    if (photos.count == 0) {
        _noPhotoView.hidden = NO;
    } else {
        _noPhotoView.hidden = YES;
        MZLPhotoItem *addedPhoto;
        if (_photos.count > 0) { // 已有照片，则是新拍照片的回调
            addedPhoto = photos[0];
            addedPhoto.state = SELECTED;
            [_photos insertObject:addedPhoto atIndex:0];
        } else {
            _photos = [NSMutableArray arrayWithArray:photos];
        }
        if (addedPhoto) {
            [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_SA_PHOTO_STATUS_MODIFIED withUserInfo:@{MZL_SA_KEY_PHOTO_ITEM : addedPhoto}];
        }
        [_photoScroll reloadData];
    }
}

- (void)checkPhotoStatus {
    NSMutableArray *invalidPhotoItems = co_emptyMutableArray();
    for (MZLPhotoItem *photoItem in _photos) {
        if (! [photoItem isValid]) {
            [invalidPhotoItems addObject:photoItem];
        }
    }
    if (invalidPhotoItems.count == 0) {
        return;
    }
    [self removeInvalidPhotoItems:invalidPhotoItems];
}

- (void)removeInvalidPhotoItems:(NSArray *)itemsToDelete {
    for (MZLPhotoItem *itemToDelete in itemsToDelete) {
        [_photos removeObject:itemToDelete];
        [self removeSelectedPhotoItem:itemToDelete];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_photoScroll reloadData];
        [_photoEditView reloadWithPhotoItems:_selectedPhotos];
    });
}

- (void)removePhotoItemsNotUploaded {
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    for (NSUInteger i = 0; i < _selectedPhotos.count; i ++) {
        MZLPhotoItem *photo = _selectedPhotos[i];
        if (! [photo isPhotoUploaded]) {
            photo.state = UNSELECTED;
            [indexSet addIndex:i];
        }
    }
    [_selectedPhotos removeObjectsAtIndexes:indexSet];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_photoScroll reloadData];
        [_photoEditView reloadWithPhotoItems:_selectedPhotos];
    });
}

- (void)removeSelectedPhotoItem:(MZLPhotoItem *)photoItem {
    photoItem.tuSDKEditedImage = nil;
    [_selectedPhotos removeObject:photoItem];
    [_photoUploadQueue cancelUpload:photoItem];
}

- (BOOL)canAddMorePhotos {
    return _selectedPhotos.count < 9;
}


#pragma mark - assets notification

- (void)registerAssetsChangedNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetsChanged:) name:ALAssetsLibraryChangedNotification object:nil];
}

- (void)assetsChanged:(NSNotification *)noti {
    if (_takeNewPhotoFlag) {
        return;
    }
    [self checkPhotoStatus];
}


#pragma mark - custom events

- (void)registerCustomEvents {
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_SA_PHOTO_STATUS_MODIFIED target:self action:@selector(onPhotoItemStatusModified:)];
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_SA_TAKE_PHOTO target:self action:@selector(takePhoto)];
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_SA_PHOTO_REMOVED target:self action:@selector(onPhotoItemStatusModified:)];
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_PHOTO_UPLOAD_FAILED target:self action:@selector(onPhotoUploadFailed)];
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_SA_TUSDK_EDIT_PHOTO target:self action:@selector(onEditPhotoItemWithTuSDK:)];
}

- (void)onEditPhotoItemWithTuSDK:(IBDispatchMessage *)message {
    NSDictionary *userInfo = message.userInfo;
    if (userInfo) {
        MZLShortArticlePhotoItem *photoItemView = userInfo[MZL_SA_KEY_PHOTO_ITEM_VIEW];
        _activeEditedPhotoItem = photoItemView;
        MZLPhotoItem *photoItem = [photoItemView associatedPhotoItem];
        TuSDKPFEditTurnAndCutOptions *opt = [TuSDKPFEditTurnAndCutOptions build];
        // 是否开启滤镜支持 (默认: 关闭)
        opt.enableFilters = YES;
        TuSDKPFEditTurnAndCutViewController *controller = opt.viewController;
        // 添加委托
        controller.delegate = self;
        // 处理图片对象 (处理优先级: inputImage > inputTempFilePath > inputAsset)
        controller.inputImage = [COAssets co_fullScreenImageFromAsset:photoItem.asset];
        [self presentModalNavigationController:controller animated:YES];
    }
}

- (void)onPhotoUploadFailed {
    [self removePhotoItemsNotUploaded];
    if (self == self.navigationController.topViewController) {
        [MZLAlertView showWithImage:[UIImage imageNamed:@"Short_Article_Failed_Image"] text:@"图片上传失败！" viewForBlur:self.view];
    }
}

- (void)onPhotoItemStatusModified:(IBDispatchMessage *)message {
    NSDictionary *userInfo = message.userInfo;
    if (userInfo) {
        MZLPhotoItem *photoItem = userInfo[MZL_SA_KEY_PHOTO_ITEM];
        [self handlePhotoItem:photoItem];
        [self modifyToolbarCameraImage];
        [self handlePhotosInViewMode:photoItem];
        [self handlePhotosInEditMode:photoItem];
    }
}

- (void)handlePhotoItem:(MZLPhotoItem *)photoItem {
    if (! _selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    if (photoItem.isSelected) {
        [_selectedPhotos addObject:photoItem];
        [_photoUploadQueue uploadPhoto:photoItem];
    } else {
        [self removeSelectedPhotoItem:photoItem];
    }
}

- (void)modifyToolbarCameraImage {
    UIButton *btnInputAddPhoto = (UIButton *)[_textView.inputAccessoryView viewWithTag:ADD_PHOTO_FROM_INPUT_TOOLBAR];
    UIButton *btnBottomAddPhoto = (UIButton *)[_photoBottomToolbar viewWithTag:ADD_PHOTO_FROM_BOTTOM_TOOLBAR];
    NSString *imageName = @"Short_Article_Photo_Add";
    if (_selectedPhotos.count == 0) {
        imageName = @"Short_Article_Photo";
    }
    UIImage *image = [UIImage imageNamed:imageName];
    [btnInputAddPhoto setImage:image forState:UIControlStateNormal];
    [btnBottomAddPhoto setImage:image forState:UIControlStateNormal];
}

- (void)handlePhotosInViewMode:(MZLPhotoItem *)photoItem {
    for (MZLShortArticlePhotoViewCell *cell in _photoScroll.visibleCells) {
        [cell updateCellStatus];
        [cell updateCellWithDisabledFlag:! [self canAddMorePhotos]];
    }
}

- (void)handlePhotosInEditMode:(MZLPhotoItem *)photoItem {
    [_photoEditView handlePhotoItem:photoItem];
}

#pragma mark - keyboard notification

- (void)co_onWillShowKeyboard:(NSNotification *)noti keyboardBounds:(CGRect)keyboardBounds {
    self.curKbBounds = keyboardBounds;
    [self togglePhotoViewPosition:PHOTO_VIEW_POS_BOTTOM];
    [self hideBottomToolbar];
}

- (void)co_onDidHideKeyboard:(NSNotification *)noti {
    if (_shouldShowPhotoView) {
        _shouldShowPhotoView = NO;
        [self togglePhotoViewPosition:PHOTO_VIEW_POS_MIDDLE];
    } else if (_shouldShowPhotoBottomToolbar) {
        _shouldShowPhotoBottomToolbar = NO;
        [self showBottomToolbar];
    }
}

- (CGFloat)bottomToolbarVisibleY {
    return self.view.height - _photoBottomToolbar.height;
}

- (BOOL)isBottomToolbarVisible {
    return _photoBottomToolbar.frame.origin.y <= [self bottomToolbarVisibleY];
}

- (void)showBottomToolbar {
    [_photoBottomToolbar co_animateToY:[self bottomToolbarVisibleY] completionBlock:nil];
}

- (void)hideBottomToolbar {
    [_photoBottomToolbar co_animateToY:self.view.height completionBlock:nil];
}

#pragma mark - UI

- (void)initUI {
    [self initTopView];
    [self initContentView];
    [self initPhotoView];
}

- (void)initTopView {
    UIView *topView = [self.view createSubView];
    _topView = topView;
//    topView.backgroundColor = [UIColor blueColor];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_equalTo(topView.superview);
        make.height.mas_equalTo(MZL_TOP_BAR_HEIGHT);
    }];
    
    UIView *navView = [topView createSubView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(navView.superview);
        make.height.mas_equalTo(MZL_NAV_BAR_HEIGHT);
    }];
    
    UIView *navLeftView = [navView createSubView];
    [navLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.and.left.mas_equalTo(navLeftView.superview);
        make.width.mas_equalTo(50);
    }];
    UIButton *closeBtn = [navLeftView createSubBtnWithImageNamed:@"Short_Article_Close" imageSize:CGSizeMake(24.0, 24.0)];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(closeBtn.superview);
    }];
    [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    UIView *navRightView = [navView createSubView];
    [navRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.and.right.mas_equalTo(navRightView.superview);
        make.width.mas_equalTo(72);
    }];
    UIButton *nextBtn = [[UIButton alloc] init];
    [navRightView addSubview:nextBtn];
    nextBtn.titleLabel.font = MZL_FONT(14.0);
    [nextBtn co_setCornerRadius:4.0];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn co_setNormalBgColor:colorWithHexString(@"#ffd521") highlightBgColor:colorWithHexString(@"#ffc321")];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nextBtn.superview);
        make.left.mas_equalTo(nextBtn.superview);
        make.size.mas_equalTo(CGSizeMake(64.0, 28.0));
    }];
    [nextBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
}

#define MIN_TEXTVIEWHEIGHT_HEIGHT 38.0

- (void)initContentView {
    UIScrollView *contentScroll = [[UIScrollView alloc] init];
    _contentScroll = contentScroll;
    [self.view addSubview:contentScroll];
//    contentScroll.backgroundColor = [UIColor blueColor];
    [contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom).offset(10);
        make.left.right.and.bottom.mas_equalTo(contentScroll.superview);
    }];
    
    UIView *contentView = [contentScroll createSubView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(contentView.superview);
        make.left.right.mas_equalTo(contentView.superview);
        make.width.mas_equalTo(self.view.width);
    }];
    
    UIView *contentViewTop = [contentView createSubView];
//    contentViewTop.backgroundColor = [UIColor grayColor];
    CGFloat margin = 15.0;
    [contentViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentViewTop.superview);
        make.left.mas_equalTo(contentViewTop.superview).offset(margin);
        make.right.mas_equalTo(contentViewTop.superview).offset(-margin);
    }];
    
    UILabel *lbl = [contentViewTop createSubViewLabelWithFontSize:12.0 textColor:colorWithHexString(@"#b0b0b0")];
    lbl.text = self.model.location.locationName;
    lbl.numberOfLines = 0;
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.mas_equalTo(lbl.superview);
        make.left.right.mas_equalTo(lbl.superview);
    }];
//    [lbl co_addLeadingImage:[UIImage imageNamed:@"Short_Article_Location"] imageSize:CGSizeMake(12, 12) spaceWidth:4];
    [lbl co_addLeadingImage:[UIImage imageNamed:@"Short_Article_Location"] imageFrame:CGRectMake(0, 2, 12, 12) spaceWidthBetweenImageAndTexts:4];
    
    UIView *sep = [contentViewTop createSepView];
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl.mas_bottom).offset(10);
    }];
   
    UITextView *textView = [[UITextView alloc] init];
    CGFloat textFontSize = 18.0;
    _textView = textView;
    textView.inputAccessoryView = [COKeyboardToolbar instance];
    [self initInputAccessoryView];
    textView.delegate = self;
    [contentViewTop addSubview:textView];
    textView.backgroundColor = [UIColor clearColor];
    textView.font = MZL_FONT(textFontSize);
    textView.textColor = colorWithHexString(@"#434343");
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sep.mas_bottom).offset(20);
        make.left.right.mas_equalTo(textView.superview);
        make.height.mas_equalTo(MIN_TEXTVIEWHEIGHT_HEIGHT);
//        make.bottom.mas_equalTo(textView.superview);
    }];
    UILabel *placeHolderLbl = [contentView createSubViewLabelWithFontSize:textFontSize textColor:colorWithHexString(@"#d8d8d8")];
    placeHolderLbl.text = @"写点什么吧？";
    [placeHolderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(textView).offset(6);
    }];
    [textView co_addPlaceholderLabel:placeHolderLbl];
    [contentViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(textView);
    }];
    
    MZLShortArticlePhotoScrollEditView *photoEditView = [[MZLShortArticlePhotoScrollEditView alloc] init];
//    photoEditView.backgroundColor = [UIColor greenColor];
    photoEditView.photoItemSize = [self photoCellSize];
    [contentView addSubview:photoEditView];
    _photoEditView = photoEditView;
    [photoEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentViewTop.mas_bottom).offset(20.0);
        make.left.mas_equalTo(photoEditView.superview).offset(MZL_SA_PHOTO_CELL_H_MARGIN);
        make.right.mas_equalTo(photoEditView.superview).offset(-MZL_SA_PHOTO_CELL_H_MARGIN);
        make.height.mas_equalTo(0);
        // 空出toolbar的高度
        make.bottom.mas_equalTo(photoEditView.superview).offset(- 1 * CO_KB_TOOLBAR_HEIGHT);
    }];
}

- (void)initInputAccessoryView {
    UIView *inputAccessory = _textView.inputAccessoryView;
    UIButton *addPhoto = [inputAccessory createSubBtnWithImageNamed:@"Short_Article_Photo" imageSize:CGSizeMake(36.0, 36.0)];
    [addPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.bottom.mas_equalTo(addPhoto.superview);
        make.width.mas_equalTo(70);
    }];
    addPhoto.tag = ADD_PHOTO_FROM_INPUT_TOOLBAR;
    [addPhoto addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeKeyboard = [inputAccessory createSubBtnWithImageNamed:@"Short_Article_CloseKb" imageSize:CGSizeMake(36.0, 36.0)];
    [closeKeyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.bottom.mas_equalTo(closeKeyboard.superview);
        make.width.mas_equalTo(70);
    }];
    [closeKeyboard addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - photo swipe gesture

- (void)onPhotoViewSwipe:(UISwipeGestureRecognizer *)swipe {
    [self togglePhotoViewPosition:YES];
}

#pragma mark - photo view UI

- (void)initTopBlurView {
    CGRect frame = CGRectMake(0, 0, self.view.width, PHOTO_VIEW_MIN_TOP_OFFSET);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor clearColor];
    view.hidden = YES;
    _topBlurView = view;
    UIView *blurBg = [[UIView alloc] initWithFrame:frame];
    blurBg.backgroundColor = [UIColor grayColor];
    blurBg.alpha = 0.95;
    [view addSubview:blurBg];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(movePhotoViewToMiddle)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [blurBg addGestureRecognizer:swipe];
    [blurBg addTapGestureRecognizer:self action:@selector(movePhotoViewToMiddle)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:frame];
    [view addSubview:image];
//    image.alpha = 0.9;
    _topBlurImage = image;
}

- (void)onTopBlurImageGenerated:(UIImage *)blurImage {
    _topBlurImage.image = blurImage;
    UIView *blurBg = [_topBlurView.subviews objectAtIndex:0];
    blurBg.alpha = 1.0;
    blurBg.backgroundColor = [UIColor clearColor];
}

- (void)initNoPhotoView {
    UIView *noPhotoView = [_photoView createSubView];
    noPhotoView.hidden = YES;
    [noPhotoView addTapGestureRecognizer:self action:@selector(takePhoto)];
    _noPhotoView = noPhotoView;
    [noPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_equalTo(noPhotoView.superview);
        make.height.mas_equalTo(self.view.height - [self photoViewMiddleY]);
    }];
    
    UIView *noPhotoViewCenter = [noPhotoView createSubView];
    [noPhotoViewCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(noPhotoViewCenter.superview);
    }];
    
    UIView *cameraView = [noPhotoViewCenter createSubView];
    cameraView.backgroundColor = [self photoCellBgColor];
    [cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cameraView.superview);
        make.centerX.mas_equalTo(cameraView.superview);
        make.size.mas_equalTo([self photoCellSize]);
    }];
    cameraView.layer.cornerRadius = 3.0;
    UIImageView *image = [cameraView createSubViewImageViewWithImageNamed:@"Short_Article_Camera"];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(image.superview);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    UILabel *lbl = [noPhotoViewCenter createSubViewLabelWithFontSize:18 textColor:[self photoCellBgColor]];
    lbl.text = @"拍摄一张照片吧";
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cameraView.mas_bottom).offset(16);
        make.left.right.and.bottom.mas_equalTo(lbl.superview);
    }];
    
}

- (void)initPhotoTipView {
    UIView *photoTipView = [_photoView createSubView];
    _photoTipView = photoTipView;
    [photoTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_equalTo(photoTipView.superview);
        make.height.mas_equalTo(self.view.height - [self photoViewMiddleY]);
    }];
    UILabel *lbl = [photoTipView createSubViewLabelWithFontSize:18 textColor:[self photoCellBgColor]];
    lbl.text = @"照片加载中...";
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(lbl.superview);
    }];
    
}

- (void)initPhotoScroll {
    UITableView *photoScroll = [[UITableView alloc] initWithFrame:CGRectMake(MZL_SA_PHOTO_CELL_H_MARGIN, MZL_SA_PHOTO_CELL_V_MARGIN, _photoView.width - 2 * MZL_SA_PHOTO_CELL_H_MARGIN, _photoView.height - MZL_SA_PHOTO_CELL_V_MARGIN)];
    photoScroll.backgroundColor = [UIColor clearColor];
    photoScroll.separatorStyle = UITableViewCellSeparatorStyleNone;
    photoScroll.scrollsToTop = NO;
    photoScroll.bounces = NO;
    photoScroll.showsVerticalScrollIndicator = NO;
    _photoScroll = photoScroll;
    [_photoView addSubview:photoScroll];
    photoScroll.scrollEnabled = NO;
    photoScroll.dataSource = self;
    photoScroll.delegate = self;
}

- (void)initPhotoBottomToolbar {
    COKeyboardToolbar *toolbar = [COKeyboardToolbar instance];
    toolbar.bottomBorder.hidden = YES;
    CGRect frame = toolbar.frame;
    frame.origin.y = self.view.height;
    toolbar.frame = frame;
    [self.view addSubview:toolbar];
    _photoBottomToolbar = toolbar;
    UIButton *addPhoto = [toolbar createSubBtnWithImageNamed:@"Short_Article_Photo" imageSize:CGSizeMake(36.0, 36.0)];
    addPhoto.tag = ADD_PHOTO_FROM_BOTTOM_TOOLBAR;
    [addPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.bottom.mas_equalTo(addPhoto.superview);
        make.width.mas_equalTo(70);
    }];
    [addPhoto addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initPhotoView {
    [self initTopBlurView];
    
    UIView *photoView = [self.view createSubView];
    _photoView = photoView;
    photoView.backgroundColor = colorWithHexString(@"#3d4953");
    CGFloat photoViewHeight = self.view.height - PHOTO_VIEW_MIN_TOP_OFFSET;
    photoView.frame = CGRectMake(0, self.view.height, self.view.width, photoViewHeight);
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPhotoViewPan:)];
//    [photoView addGestureRecognizer:pan];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onPhotoViewSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [photoView addGestureRecognizer:swipe];
    
    [self initPhotoScroll];
    
    [self initNoPhotoView];
    
    [self initPhotoTipView];
    
    [self initPhotoBottomToolbar];
}

#pragma mark - photo scroll data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_photos.count == 0) {
        return 0;
    }
    // 包含一个拍照的cell
    CGFloat result = ceilf((_photos.count + 1) / 3.0);
    return (NSInteger)result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    MZLShortArticlePhotoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (! cell) {
        cell = [[MZLShortArticlePhotoViewCell alloc] initWithPhotoItemSize:[self photoCellSize]];
    }
    [cell updateCellOnIndexPath:indexPath photos:_photos isDisabled:! [self canAddMorePhotos]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self photoCellSize].height + MZL_SA_PHOTO_CELL_V_MARGIN;
}

#pragma mark - photo scroll delegate

- (void)setBounceStatusIfNecessary:(UIScrollView *)scroll {
    if (scroll.contentOffset.y <= 0) {
        scroll.bounces = NO;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (! scrollView.bounces && velocity.y < 0) {
        [self togglePhotoViewPosition:PHOTO_VIEW_POS_MIDDLE];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (! decelerate) {
        [self setBounceStatusIfNecessary:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setBounceStatusIfNecessary:scrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        scrollView.bounces = YES;
    }
}

#pragma mark - photo view helper methods

- (UIColor *)photoCellBgColor {
    return colorWithHexString(@"#4d5c69");
}

- (CGSize)photoCellSize {
    CGFloat sideLength = floorf((self.view.width - 4 * MZL_SA_PHOTO_CELL_H_MARGIN) / 3.0);
    return CGSizeMake(sideLength, sideLength);
}

- (CGFloat)photoViewMiddleY {
    return self.view.height / 2.0;
}

- (CGFloat)photoViewTopY {
    return PHOTO_VIEW_MIN_TOP_OFFSET;
}

- (CGFloat)photoViewVisibleHeightInScreen {
    return self.view.height - [self photoViewMiddleY];
}

- (UIGestureRecognizer *)photoViewGesture {
    return [_photoView.gestureRecognizers objectAtIndex:0];
}

- (void)onPhotoViewReachTop {
    [self photoViewGesture].enabled = NO;
    _photoScroll.scrollEnabled = YES;
    _topBlurView.alpha = 1.0;
    _topBlurView.hidden = NO;
}

- (void)onPhotoViewReachMiddle {
    [self photoViewGesture].enabled = YES;
    _photoScroll.scrollEnabled = NO;
    [_photoScroll setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)movePhotoViewToMiddle {
    [self togglePhotoViewPosition:PHOTO_VIEW_POS_MIDDLE];
}

- (void)movePhotoViewToBottom {
    [self togglePhotoViewPosition:PHOTO_VIEW_POS_BOTTOM];
}

- (void)togglePhotoViewPosition:(NSInteger)posFlag {
    if (posFlag == PHOTO_VIEW_POS_TOP) {
        // 没有滚动则不移动到顶部
        if (_photoScroll.contentSize.height < [self photoViewVisibleHeightInScreen]) {
            return;
        }
        [_photoView co_animateToY:[self photoViewTopY] completionBlock:^{
            [self onPhotoViewReachTop];
        }];
    } else if (posFlag == PHOTO_VIEW_POS_MIDDLE) {
        _topBlurView.hidden = YES;
        [_photoView co_animateToY:[self photoViewMiddleY] completionBlock:^{
            [self onPhotoViewReachMiddle];
        }];
    } else {
        [_photoView co_animateToY:self.view.height completionBlock:nil];
    }
}

//#pragma mark - photo pan gesture
//
//- (void)onPhotoViewPan:(UIPanGestureRecognizer *)pan {
//    UIView *photoView = (UIView *)pan.view;
//    if (pan.state == UIGestureRecognizerStateBegan) {
//        [photoView setProperty:PHOTO_VIEW_PROP_FRAME_Y value:@(photoView.frame.origin.y)];
//    }
//    if ([photoView getProperty:PHOTO_VIEW_PROP_FRAME_Y]) {
//        CGFloat y = [[photoView getProperty:PHOTO_VIEW_PROP_FRAME_Y] floatValue];
//        CGPoint translation = [pan translationInView:self.view];
//        CGFloat destY = y + translation.y;
//        /** 限制移动距离 */
//        if (destY <= PHOTO_VIEW_MIN_TOP_OFFSET) {
//            destY = PHOTO_VIEW_MIN_TOP_OFFSET;
//            [self onPhotoViewReachTop];
//        } else if (destY >= [self photoViewOriginY]) {
//            destY = [self photoViewOriginY];
//            [self onPhotoViewReachBottom];
//        } else {
//            [self onPhotoViewWillMoveTo:destY];
//        }
//        CGRect frame = photoView.frame;
//        frame.origin.y = destY;
//        _photoView.frame = frame;
//    }
//    if (pan.state == UIGestureRecognizerStateEnded) {
//        [photoView removeProperty:PHOTO_VIEW_PROP_FRAME_Y];
//    }
//}

#pragma mark - text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView co_hidePlaceholderLabel];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView co_checkPlaceholder];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fittingHeight = [textView co_getFittingHeight];
    CGFloat height = MAX(fittingHeight, MIN_TEXTVIEWHEIGHT_HEIGHT);
    // 限制最大高度
    height = MIN(height, [self textViewMaxHeight]);
    if (height != textView.height) {
        [textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        [UIView animateWithDuration:0.3
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction|
                                     UIViewAnimationOptionBeginFromCurrentState)
                         animations:^(void) {
                             [textView layoutIfNeeded];
                             [textView setContentOffset:CGPointMake(0, 0) animated:NO];
                         }
                         completion:^(BOOL finished) {
//                             [self onTextViewHeightDidChange];
                         }];
    }
    
}

- (CGFloat)textViewMaxHeight {
    CGPoint kbOriginInScroll = [_contentScroll convertPoint:self.curKbBounds.origin fromView:globalWindow()];
    CGFloat maxY = kbOriginInScroll.y - MIN_TEXTVIEWHEIGHT_HEIGHT;
    return (maxY - _textView.frame.origin.y);
}

//- (void)onTextViewHeightDidChange {
//    CGPoint kbOriginInScroll = [_contentScroll convertPoint:self.curKbBounds.origin fromView:globalWindow()];
//    CGFloat textViewMaxY = CGRectGetMaxY(_textView.frame);
//    CGFloat gap = kbOriginInScroll.y - textViewMaxY;
//    if (gap < 0) {
//        CGPoint newContentOffset = _contentScroll.contentOffset;
//        newContentOffset.y += MIN_TEXTVIEWHEIGHT_HEIGHT;
//        [_contentScroll setContentOffset:newContentOffset animated:NO];
//    }
//}

#pragma mark - take photos 

- (void)takePhoto {
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)) {
        return;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:nil];
}

#pragma mark - image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = (UIImage *) [info objectForKey:
                                  UIImagePickerControllerOriginalImage];
    _takeNewPhotoFlag = YES;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);//保存图片到照片库
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [self dismissViewControllerAnimated:YES completion:^{
        _takeNewPhotoFlag = NO;
        [self loadPhotosFromSystem];
    }];
}

#pragma mark - events handler

- (void)close:(UIButton *)sender {
    if (! isEmptyString(_textView.text) || _selectedPhotos.count > 0) {
        [IBAlertView showAlertWithTitle:MZL_MSG_ALERT_VIEW_TITLE message:@"确认退出玩法编辑？" dismissTitle:MZL_MSG_CANCLE okTitle:MZL_MSG_OK dismissBlock:^{
            
        } okBlock:^{
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)addPhoto:(UIButton *)sender {
    if (sender.tag == ADD_PHOTO_FROM_INPUT_TOOLBAR) {
        _shouldShowPhotoView = YES;
        [self closeKeyboardForTextView];
    } else {
        [_photoBottomToolbar co_animateToY:self.view.height completionBlock:^{
            [self togglePhotoViewPosition:PHOTO_VIEW_POS_MIDDLE];
        }];
    }
}

- (void)closeKeyboard {
    _shouldShowPhotoBottomToolbar = YES;
    [self closeKeyboardForTextView];
}

- (void)closeKeyboardForTextView {
    [_textView resignFirstResponder];
}

- (void)nextStep {
    
    [self closeKeyboardForTextView];
    if (! isEmptyString(_textView.text)) {
        NSInteger maxInputLength = 2000;
        NSString *failedTextImageName = @"Short_Article_Faild_Label";
        if (_textView.text.length > maxInputLength) {
            NSString *errorTip = [NSString stringWithFormat:@"字数过多，最多只能输入%@个汉字", @(maxInputLength)];
            [MZLAlertView showWithImage:[UIImage imageNamed:failedTextImageName] text:errorTip viewForBlur:self.view];
            return;
        }
        NSArray *invalidKeywords = [_textView.text co_matchWithRegularPattern:_contentKeywords];
        if (invalidKeywords.count > 0) {
            COStringRegularPatternMatchResult *result = invalidKeywords[0];
            NSString *errorTip = [NSString stringWithFormat:@"发现违禁词“%@”，请修改", result.matchedSubstring];
            [MZLAlertView showWithImage:[UIImage imageNamed:failedTextImageName] text:errorTip viewForBlur:self.view];
            return;
        }
    }
    if (_selectedPhotos.count == 0) {
        [MZLAlertView showWithImage:[UIImage imageNamed:@"Short_Article_Failed_Image"] text:@"请至少上传一张图片" viewForBlur:self.view];
        return;
    }
    
    // to next step
    self.model.content = _textView.text;
    self.model.photos = [NSArray arrayWithArray:_selectedPhotos];
    [self performSegueWithIdentifier:@"toNextStep" sender:nil];
}

#pragma mark - TuSDK related

- (void)onTuSDKFilterManagerInited:(TuSDKFilterManager *)manager {
    [self hideProgressIndicator];
}

/**
 *  图片编辑完成
 *
 *  @param controller 旋转和裁剪视图控制器
 *  @param result 旋转和裁剪视图控制器处理结果
 */
- (void)onTuSDKPFEditTurnAndCut:(TuSDKPFEditTurnAndCutViewController *)controller result:(TuSDKResult *)result;
{
    UIImage *image = result.image;
    [_activeEditedPhotoItem showTuSDKEditedPhoto:image];
    MZLPhotoItem *editedPhoto = _activeEditedPhotoItem.associatedPhotoItem;
    editedPhoto.tuSDKEditedImage = image;
    // 重新上传
    [_photoUploadQueue cancelUpload:editedPhoto];
    [editedPhoto resetUpload];
    [_photoUploadQueue uploadPhoto:editedPhoto];
    [controller dismissModalViewControllerAnimated];
}

- (void)onComponent:(TuSDKCPViewController *)controller result:(TuSDKResult *)result error:(NSError *)error {
    [UIAlertView showAlertMessage:@"图像处理失败"];
}

@end
