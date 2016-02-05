//
//  MZLShortArticleTagsVC.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLShortArticleTagsVC.h"

#import "UIView+MZLAdditions.h"
#import "UILabel+COAdditions.h"
#import "UIImage+COAdditions.h"
#import "UIButton+COAddition.h"
#import "MZLShortArticleTagItem.h"
#import "MZLShortArticleCustomTagItem.h"
#import "UIViewController+COAdditions.h"
#import "UIImage+ImageEffects.h"
#import "MZLAlertView.h"
#import "MZLSharedData.h"
#import "MZLModelImage.h"
#import "MZLModelFilterType.h"
#import "MZLModelFilterItem.h"
#import "IBMessageCenter.h"
#import "MZLServices.h"
#import "MZLShortArticleResponse.h"
#import "IBAlertView.h"
#import "MZLTabBarViewController.h"
#import "MZLShortArticleProgressView.h"
#import "MZLPhotoUploadingQueue.h"
#import "MZLMyFavoriteViewController.h"
#import "NSString+COValidation.h"
#import "MZLModelTagType.h"
#import "MZLModelTag.h"
#import "UIViewController+MZLShortArticle.h"

#define MZL_TAGS_VIEW_WIDTH CO_SCREEN_WIDTH - 30
#define MZL_CUSTOM_TAGS_VIEW_WIDTH CO_SCREEN_WIDTH - 52
#define MZL_CUSTOM_TAG_WIDTH_MIN 60.5

#define TAG_COST_TEXTFIELD 101
#define TAG_RMB_LABEL 102

#define TAG_TYPE_CROWD @"TAG_TYPE_CROWD"
#define TAG_TYPE_FEATURE @"TAG_TYPE_FEATURE"

#define KEY_TAG_CROWD @"KEY_TAG_CROWD"
#define KEY_TAG_FEATURE @"KEY_TAG_FEATURE"
#define KEY_TAG_CUSTOM @"KEY_TAG_CUSTOM"

#define TEXT_UPLOADING_SHORT_ARTICLE @"短文发布中，请稍候..."

#define IMAGE_FOR_COMMON_ERROR @"Short_Article_Failed_Image"

//#define MZL_NOTIFICATION_PHOTO_QUEUE_FINISH_UPLOADING @"MZL_NOTIFICATION_PHOTO_QUEUE_FINISH_UPLOADING"
//#define MZL_NOTIFICATION_PHOTO_UPLOAD_FAILED @"MZL_NOTIFICATION_PHOTO_UPLOAD_FAILED"

static double const kAnimationDuration = 0.3;

@interface MZLShortArticleTagsVC () <MZLShortArticleProgressViewDelegate> {
    NSInteger lastTagId;
    BOOL isPosting;
}

@property (nonatomic, weak)UIScrollView *contentScrollView;
@property (nonatomic, weak)UIView *vwCrowd;
@property (nonatomic, weak)UIView *vwFeature;
@property (nonatomic, weak)UITextField *tagTextField;
@property (nonatomic, weak)UIView *vwCustomTag;
@property (nonatomic, weak)UIImageView *imgTag;
@property (nonatomic, weak)MZLShortArticleCustomTagItem *preTag;
@property (nonatomic, weak)UIImage *blurImage;
@property (nonatomic, weak)UIView *vwIndicator;
@property (nonatomic, weak)UIView *progressBg;
@property (nonatomic, weak)UITextField *costTextField;

@property (nonatomic,strong)NSMutableArray *crowdTags;
@property (nonatomic,strong)NSMutableArray *featureTags;
@property (nonatomic,strong)NSMutableArray *customTags;

@property (nonatomic, assign) CGPoint contentOffset;

@property (nonatomic, strong)MZLShortArticleProgressView *progressView;

@end

@implementation MZLShortArticleTagsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerCustomEvents];
    [self initInternal];
    [self co_registerKeyboardNotification];
    // 每创建一个新的tag，该值递增，删除一个则递减
    lastTagId = 200;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if (self.model.photos.count == 0) {
//        //如果model中的照片数为0 延迟1秒返回第二步
//        double delayInSeconds = 1.0;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self back];
//        });
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideNavigationBar:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideNavigationBar:NO];
}

- (void)dealloc {
    [self co_removeFromNotificationCenter];
    [IBMessageCenter removeMessageListenersForTarget:self];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - service related

- (void)invokeShortArticleService {
    [MZLServices postShortArticleService:self.model succBlock:^(NSArray *models) {
        self.model.identifier = ((MZLShortArticleResponse *)models[0]).article.identifier;
        [self onPostShortArticleSucceed];
    } errorBlock:^(NSError *error) {
        [self onPostShortArticleFailed];
    }];
}

- (void)onPostShortArticleSucceed {
    isPosting = NO;
    [self.progressView hide:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _onPostShortArticleSucceed];
    });
}

- (void)onPostShortArticleFailed {
    [self onPostFailed];
    // 统一错误界面，稍作延时
    dispatch_async(dispatch_get_main_queue(), ^{
        [MZLAlertView showWithImage:[UIImage imageNamed:@"Short_Article_Post_Error"] text:@"发布失败，请稍后再试" viewForBlur:self.view];
    });
}

- (void)onPostFailed {
    isPosting = NO;
    [self.progressView hide:NO];
}

- (void )_onPostShortArticleSucceed {
    UIImage *toImage = [UIImage windowScreenshot];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *blurredSnapshot = [self blurWithImageEffects:toImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.blurImage = blurredSnapshot;
            [self createSucceedView];
        });
    });
}

#pragma mark - custom events

- (void)registerCustomEvents {
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_PHOTO_UPLOAD_SUCC target:self action:@selector(onSinglePhotoUploadSucc)];
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_PHOTO_QUEUE_FINISH_UPLOADING target:self action:@selector(onPhotoUploadSucc)];
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_PHOTO_UPLOAD_FAILED target:self action:@selector(onPhotoUploadFailed)];
}

- (void)onSinglePhotoUploadSucc {
    if (isPosting && self.progressView) {
        self.progressView.displayText = [self textForUploadingPhoto];
    }
}

- (void)_postShortArticle {
    self.progressView.displayText = TEXT_UPLOADING_SHORT_ARTICLE;
    [self.progressView setCancellable:NO];
    [self invokeShortArticleService];
}

- (void)onPhotoUploadSucc {
    // 收到照片上传完成的消息后马上执行发布短文的service
    if (isPosting) {
        [self _postShortArticle];
    }
}

- (void)alertOnPhotoUploadFailure {
    [MZLAlertView showWithImage:[UIImage imageNamed:IMAGE_FOR_COMMON_ERROR] text:@"图片上传失败，请返回上一步重新选择！" viewForBlur:self.view];
}

- (void)onPhotoUploadFailed {
    //照片上传失败 清除model中的photos 如果正在请求显示错误消息
    self.model.photos = [NSArray array];
    if (isPosting) {
        [self onPostFailed];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self alertOnPhotoUploadFailure];
        });
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)postShortArticle {
    [self dismissKeyboard];
    //检测每类标签至少选择一个
    NSString *errorTip = @"每类标签至少选择一个";
    if (((NSArray *)[self.selectedTags objectForKey:KEY_TAG_CROWD]).count == 0
        ) {
        [MZLAlertView showWithImage:[UIImage imageNamed:@"Short_Article_Faild_Croud"] text:errorTip viewForBlur:self.view];
        return;
    }
    if (((NSArray *)[self.selectedTags objectForKey:KEY_TAG_FEATURE]).count == 0
        ) {
        [MZLAlertView showWithImage:[UIImage imageNamed:@"Short_Article_Faild_Feature"] text:errorTip viewForBlur:self.view];
        return;
    }
    // cost是否为数字
    if (! isEmptyString(self.costTextField.text)) {
        if (! [self.costTextField.text co_isAllDigits]) {
            [MZLAlertView showWithImage:[UIImage imageNamed:IMAGE_FOR_COMMON_ERROR] text:errorTip viewForBlur:self.view];
            return;
        }
    }
    //检测照片数量
    if (self.model.photos.count  == 0) {
        [self alertOnPhotoUploadFailure];
        return;
    }
    [self addCustomTag];
    [IBAlertView showAlertWithTitle:MZL_MSG_ALERT_VIEW_TITLE message:@"确定发布短文？" dismissTitle:MZL_MSG_CANCLE okTitle:MZL_MSG_OK dismissBlock:^{
    } okBlock:^{
        [self toPost];
    }];
}

- (void)toPost {
    NSMutableArray *tags = [NSMutableArray array];
    [[self selectedTags] eachValue:^(id value) {
        if (((NSArray *)value).count > 0) {
            [tags addObject:[(NSArray *)value join:@","]];
        }
    }];
    self.model.tags = [tags join:@","];
    if (! isEmptyString(self.costTextField.text)) {
        self.model.consumption = [self.costTextField.text integerValue];
    }
    isPosting = YES;
    if (! self.progressView) {
        self.progressView = [MZLShortArticleProgressView instance];
    }
    self.progressView.viewToBlur = self.view;
    if (! [self.model arePhotosUploaded]) {//如果所有照片上传完成，请求服务器，否则需要等待照片上传完成的通知
        [self.progressView setCancellable:YES];
        self.progressView.displayText = [self textForUploadingPhoto];
    } else {
        [self _postShortArticle];
    }
    [self.progressView showWithDelegate:self];
}

#pragma mark - progress view delegate

- (void)onProgressViewHide {
    isPosting = NO;
}

#pragma  mark - initInternal

- (void)initInternal {
    self.crowdTags = [[NSMutableArray alloc] init];
    self.featureTags = [[NSMutableArray alloc] init];
    self.customTags = [[NSMutableArray alloc] init];
    
    [self initUI];
}

- (void)initUI {
    
    NSMutableArray *sysTagsCrowd = [[NSMutableArray alloc] init];
    NSMutableArray *sysTagsFeature = [[NSMutableArray alloc] init];
    
    NSArray *tagTypesArray = [MZLSharedData allTagTypes];
    for (MZLModelTagType *type in tagTypesArray) {
        if (type.identifier == MZL_TAG_TYPE_CROWD) {
            for (MZLModelTag *tag in type.tagsArray) {
                [sysTagsCrowd addObject:tag.name];
            }
        } else if (type.identifier == MZL_TAG_TYPE_FEATURE) {
            for (MZLModelTag *tag in type.tagsArray) {
                [sysTagsFeature addObject:tag.name];
            }
        }
    }
    
    self.contentScrollView = [self.view createSubview:[UIScrollView class]];
    [self.contentScrollView addTapGestureRecognizerToDismissKeyboard];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *vwCrowdTitle = [self sectionTitleViewWithImageNamed:@"Short_Article_Croud" title:@"跟谁玩"];
    [vwCrowdTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vwCrowdTitle.superview.mas_top).offset(84);
        make.left.equalTo(vwCrowdTitle.superview.mas_left).offset(15);
    }];
    
    self.vwCrowd = [self sectionContentViewWithTags:[self sortedArrayWithLength:sysTagsCrowd] type:TAG_TYPE_CROWD];
    
    [self.vwCrowd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vwCrowd.superview.mas_left).offset(15);
        make.top.equalTo(vwCrowdTitle.mas_bottom).offset(20);
        make.right.equalTo(self.vwCrowd.superview.mas_right).offset(-15);
    }];
    
    UIView *vwFeatureTitle = [self sectionTitleViewWithImageNamed:@"Short_Article_Feature" title:@"玩什么"];
    [vwFeatureTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vwFeatureTitle.superview.mas_left).offset(15);
        make.top.equalTo(self.vwCrowd.mas_bottom).offset(32);
    }];
    
    self.vwFeature = [self sectionContentViewWithTags:[self sortedArrayWithLength:sysTagsFeature] type:TAG_TYPE_FEATURE];
    [self.vwFeature mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vwFeature.superview.mas_left).offset(15);
        make.top.equalTo(vwFeatureTitle.mas_bottom).offset(20);
        make.right.equalTo(self.vwFeature.superview.mas_right).offset(-15);
    }];
    
    //分割线 ---   1
    UIView *_sepratorLine1 = [self sepratorLine];
    [_sepratorLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sepratorLine1.superview.mas_left);
        make.top.equalTo(self.vwFeature.mas_bottom).offset(32);
    }];
    
    self.vwCustomTag = [self customTagItemCell];
    [self.vwCustomTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vwCustomTag.superview.mas_left);
        make.top.equalTo(_sepratorLine1.mas_bottom);
    }];
    
    //分割线 ---   2
    UIView *_sepratorLine2 = [self sepratorLine];
    [_sepratorLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sepratorLine2.superview.mas_left);
        make.top.equalTo(self.vwCustomTag.mas_bottom);
    }];
    
    UIView *_vwCost = [self costItemCell];
    [_vwCost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vwCustomTag.superview.mas_left);
        make.top.equalTo(_sepratorLine2.mas_bottom);
    }];
    
    //分割线 ---   3
    UIView *_sepratorLine3 = [self sepratorLine];
    [_sepratorLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sepratorLine3.superview.mas_left);
        make.top.equalTo(_vwCost.mas_bottom);
    }];
    
    UIView *_blankView = [self.contentScrollView createSubView];
    [_blankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sepratorLine3.mas_bottom);
        make.left.equalTo(_blankView.superview.mas_left);
        make.height.equalTo(@228);
        make.bottom.equalTo(self.contentScrollView.mas_bottom);
    }];
    
    [self createNavgitionView];
}

#pragma mark - nav

- (void)createNavgitionView {
    UIView *vwNav = [self.view createSubView];
    [vwNav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(vwNav.superview);
        make.height.equalTo(@64);
    }];
    
    //返回按钮
    UIView *vwBackBtn = [vwNav createSubView];
    [vwBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.left.equalTo(vwBackBtn.superview.mas_left);
        make.top.equalTo(vwBackBtn.superview.mas_top).offset(20);
    }];
    [vwBackBtn addTapGestureRecognizer:self action:@selector(back)];
    UIButton *navLeftItemButton = [vwBackBtn createSubBtnWithImageNamed:@"BackArrow" imageSize:CGSizeMake(24, 24)];
    [navLeftItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navLeftItemButton.superview.mas_left).offset(15);
        make.centerY.equalTo(navLeftItemButton.superview.mas_centerY);
    }];
    [navLeftItemButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //发布按钮
    UIButton *btnPost = [self postButton];
    [vwNav addSubview:btnPost];
    [btnPost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnPost.superview.mas_right).offset(-8);
        make.centerY.equalTo(btnPost.superview.mas_centerY).offset(10);
    }];
    
    vwNav.backgroundColor = [UIColor whiteColor];
    UIView *_sepratorLineNav = [self sepratorLine];
    [_sepratorLineNav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sepratorLineNav.superview.mas_left);
        make.top.equalTo(vwNav.mas_bottom);
        make.right.equalTo(_sepratorLineNav.superview.mas_right);
    }];
    
    self.vwIndicator = [vwNav createSubView];
    self.vwIndicator.hidden = YES;
    [self.vwIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@64);
        make.height.equalTo(@28);
        make.right.equalTo(vwNav.mas_right).offset(-8);
        make.centerY.equalTo(vwNav.mas_centerY).offset(10);
    }];
    self.vwIndicator.backgroundColor = colorWithHexString(@"#ffd521");
    self.vwIndicator.clipsToBounds = YES;
    self.vwIndicator.layer.cornerRadius = 4.0;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.vwIndicator addSubview:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(indicator.superview);
    }];
    [indicator startAnimating];
}

#pragma mark - tags view

- (UIView *)sectionContentViewWithTags:(NSArray *)tags type:(NSString *)type{
    UIView *vwtags = [self.contentScrollView createSubView];
    UIView *lastView;
    MZLShortArticleTagItem *itemView;
    __block CGFloat widthOfTags = 0.0;
    for (NSString *tag in tags) {
        itemView = [vwtags createSubview:[MZLShortArticleTagItem class]];
        [itemView setTagText:tag];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            widthOfTags = widthOfTags + itemView.width + (widthOfTags == 0.0 ? 0 : 10);
            if (lastView) {
                
                if (widthOfTags <= MZL_TAGS_VIEW_WIDTH) { //如果标签放不下一个屏幕的宽度，则将标签下一行显示
                    make.left.equalTo(lastView.mas_right).offset(10);
                    make.top.equalTo(lastView.mas_top);
                }else{
                    make.left.equalTo(itemView.superview.mas_left);
                    make.top.equalTo(lastView.mas_bottom).offset(12);
                    widthOfTags = itemView.width;
                }
            }else {
                make.left.equalTo(itemView.superview.mas_left);
                make.top.equalTo(itemView.superview.mas_top);
            }
        }];
        lastView = itemView;
        if ([type isEqualToString:TAG_TYPE_CROWD]) {
            [self.crowdTags addObject:itemView];
        }else {
            [self.featureTags addObject:itemView];
        }
        
    }
    
    [vwtags mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MZL_TAGS_VIEW_WIDTH);
        if (lastView) {
            make.bottom.equalTo(lastView.mas_bottom);
        }else {
            make.bottom.equalTo(itemView.mas_bottom);
        }
    }];
    
    return vwtags;
}

#pragma mark - section title

- (UIView *)sectionTitleViewWithImageNamed:(NSString *)imageNamed title:(NSString *)title {
    UIView *contentView = [self.contentScrollView createSubView];
    
    UIImageView *titleImage = [contentView createSubViewImageViewWithImageNamed:imageNamed];
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleImage.superview.mas_left);
        make.top.equalTo(titleImage.superview.mas_top);
        make.bottom.equalTo(titleImage.superview.mas_bottom);
    }];
    
    UILabel *titleLabel = [contentView createSubViewLabelWithFontSize:16 textColor:colorWithHexString(@"b0b0b0")];
    titleLabel.text = title;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleImage.mas_right).offset(10);
        make.right.equalTo(contentView.mas_right);
        make.centerY.equalTo(titleImage.mas_centerY);
    }];
    
    return contentView;
}

- (UIView *)sepratorLine {
    UIView *sepratorLine = [self.contentScrollView createSubView];
    [sepratorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(CO_SCREEN_WIDTH);
        make.height.mas_equalTo(0.5);
    }];
    sepratorLine.backgroundColor = colorWithHexString(@"#d8d8d8");
    return sepratorLine;
}

#pragma mark - add custom tag

- (UIView *)customTagItemCell {
    UIView *_customTagItemCell = [self.contentScrollView createSubView];
    [_customTagItemCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(CO_SCREEN_WIDTH);
    }];
    
    self.imgTag = [_customTagItemCell createSubViewImageViewWithImageNamed:@"Short_Article_Tag"];
    [self.imgTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(12, 12));
        make.left.equalTo(self.imgTag.superview.mas_left).offset(15);
        make.top.equalTo(self.imgTag.superview.mas_top).offset(28);
    }];
    
    self.tagTextField = [_customTagItemCell createSubview:[UITextField class]];
    self.tagTextField.delegate = self;
    self.tagTextField.placeholder = @"新增标签，空格或换行分隔";
    [self.tagTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgTag.mas_right).offset(10);
        make.top.equalTo(_tagTextField.superview.mas_top);
        make.height.equalTo(@66);
        make.bottom.equalTo(self.tagTextField.superview.mas_bottom);
        make.right.equalTo(self.tagTextField.superview.mas_right).offset(-15);
    }];
    
    return _customTagItemCell;
}

#pragma mark - cost cell

- (UIView *)costItemCell {
    UIView *costItemCell = [self.contentScrollView createSubView];
    [costItemCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(CO_SCREEN_WIDTH);
        make.height.mas_equalTo(66);
    }];
    
    UIImageView *_costImage = [costItemCell createSubViewImageViewWithImageNamed:@"Short_Article_Cost"];
    [_costImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(12, 12));
        make.left.equalTo(_costImage.superview.mas_left).offset(15);
        make.centerY.equalTo(_costImage.superview.mas_centerY);
    }];
    
    //元
    UILabel *lblRMB = [costItemCell createSubViewLabelWithFontSize:24 textColor:colorWithHexString(@"#434343")];
    lblRMB.hidden = YES;
    lblRMB.text = @"元";
    lblRMB.tag = TAG_RMB_LABEL;
    
    [lblRMB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lblRMB.superview.mas_right).offset(-15);
        make.centerY.equalTo(costItemCell.mas_centerY);
    }];
    
    UITextField *costTextField = [costItemCell createSubview:[UITextField class]];
    self.costTextField = costTextField;
    costTextField.tag = TAG_COST_TEXTFIELD;
    costTextField.delegate = self;
    costTextField.placeholder = @"花费";
    costTextField.textColor = colorWithHexString(@"#434343");
    costTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [costTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_costImage.mas_right).offset(10);
        make.top.equalTo(costTextField.superview.mas_top);
        make.bottom.equalTo(costTextField.superview.mas_bottom);
        make.right.equalTo(lblRMB.mas_left);
    }];
    
    return costItemCell;
}

#pragma mark - addCustomTag

- (void)_addCustomTag {
    NSString *strippedText = [self.tagTextField.text co_strip];
    if (isEmptyString(strippedText)) {
        return;
    }
    
    MZLShortArticleCustomTagItem *tagView ;
    tagView = [self.tagTextField.superview createSubview:[MZLShortArticleCustomTagItem class]];
    [tagView setTagText:strippedText];
    lastTagId++;
    [tagView setTag:lastTagId];
    
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        //添加tag之前需要知道当前tagsview的宽度（最后一个tag的origin.x + tag.width），用来判断是否一行能显示下新添加的tag
        CGFloat widthOfCustomTagView = [self.view convertPoint:self.preTag.frame.origin toView:self.vwCustomTag].x + self.preTag.width;
        if (self.preTag) {
            if ((widthOfCustomTagView + tagView.width) <= MZL_CUSTOM_TAGS_VIEW_WIDTH) { //如果标签放不下，则下一行显示
                make.left.equalTo(self.preTag.mas_right).offset(8);
                make.centerY.equalTo(self.preTag.mas_centerY);
            }else {
                make.left.equalTo(self.imgTag.mas_right).offset(10);
                make.top.equalTo(self.preTag.mas_bottom).offset(6);
            }
        }else{
            make.left.equalTo(self.imgTag.mas_right).offset(10);
            make.centerY.equalTo(self.imgTag.mas_centerY);
        }
    }];
    [self.vwCustomTag layoutIfNeeded]; //told view to update constraints immediately
    [self.tagTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(68);
        make.width.mas_equalTo(MZL_CUSTOM_TAGS_VIEW_WIDTH);
        make.bottom.equalTo(self.vwCustomTag.mas_bottom);
        CGFloat widthOfCustomTagView = [self.view convertPoint:tagView.frame.origin toView:self.vwCustomTag].x + tagView.width;
        if ((widthOfCustomTagView + MZL_CUSTOM_TAG_WIDTH_MIN + 8) <= MZL_CUSTOM_TAGS_VIEW_WIDTH) { //光标放不下，需要换行
            make.left.equalTo(tagView.mas_right).offset(6);
            make.centerY.equalTo(tagView.mas_centerY);
        }else {
            make.left.equalTo(self.imgTag.mas_right).offset(6);
            make.top.equalTo(tagView.mas_bottom).offset(-12);
        }
    }];
    self.tagTextField.text = CO_CHAR_ZERO_WIDTH_SPACE;
    self.preTag = tagView;
    [self.customTags addObject:tagView];
}

- (void)addCustomTag {
    [self _addCustomTag];
    if (self.customTags.count == 0) {
        self.tagTextField.text = nil; //如果没有自定义标签 显示placeholder
    } else {
        self.tagTextField.text = CO_CHAR_ZERO_WIDTH_SPACE;

    }}

#pragma mark - delete custom tag

- (void)deleteCustomTag {
    lastTagId--;
    UIView *lastTag;
    [self.preTag removeFromSuperview];
    [self.customTags removeObject:self.preTag];
    
    if (lastTagId > 200) { //将倒数第二个标签变为最后一个标签
        self.preTag = (MZLShortArticleCustomTagItem *)[self.vwCustomTag viewWithTag:lastTagId];
        lastTag = [self.vwCustomTag viewWithTag:lastTagId];
    }else {
        /* lastTagId = 200 表示已经是删除所有标签 */
        self.preTag = nil;
        self.tagTextField.text = nil;
        lastTagId = 200;//防止多余删除触发 lastTag-- 操作，保护lastTagId最小为200
    }
    
    [self.tagTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(68);
        make.width.mas_equalTo(MZL_CUSTOM_TAGS_VIEW_WIDTH);
        make.bottom.equalTo(self.vwCustomTag.mas_bottom);
        if (self.preTag) { //判断是否是前面有tag
            CGFloat widthOfCustomTagView = [self.view convertPoint:self.preTag.frame.origin toView:self.vwCustomTag].x + self.preTag.width;
            if (widthOfCustomTagView + MZL_CUSTOM_TAG_WIDTH_MIN + 6 <= MZL_CUSTOM_TAGS_VIEW_WIDTH) {
                make.left.equalTo(self.preTag.mas_right).offset(6);
                make.centerY.equalTo(self.preTag.mas_centerY);
            }else {
                make.left.equalTo(self.imgTag.mas_right).offset(6);
                make.top.equalTo(self.preTag.mas_bottom).offset(-12);
            }
        }else {
            make.left.equalTo(self.imgTag.mas_right).offset(10);
            make.centerY.equalTo(self.imgTag.mas_centerY);
        }
    }];
    self.tagTextField.text = CO_CHAR_ZERO_WIDTH_SPACE;
}

-  (void)createSucceedView {
    
    UIView *vwSucceed = [self.view createSubView];
    [vwSucceed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(vwSucceed.superview);
    }];
    
    UIImageView *bg = [vwSucceed createSubViewImageView];
    bg.image = self.blurImage;
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bg.superview);
    }];
    
    UIView *contentView = [vwSucceed createSubView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(contentView.superview.mas_width);
        make.centerX.and.centerY.equalTo(contentView.superview);
    }];
    
    UILabel *lblSucceed = [contentView createSubViewLabelWithFontSize:24 textColor:colorWithHexString(@"434343")];
    lblSucceed.text = @"恭喜你发布成功!";
    [lblSucceed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lblSucceed.superview.mas_centerX);
        make.top.equalTo(lblSucceed.superview.mas_top);
    }];
    
    UIButton *btnShare = [contentView createSubview:[UIButton class]];
    [btnShare co_setNormalBgColor:colorWithHexString(@"#50d049") highlightBgColor:colorWithHexString(@"#2bc722")];
    [btnShare co_setCornerRadius:5.0];
    [btnShare setTitle:@"马上分享至微信" forState:UIControlStateNormal];
    [btnShare setTitleFont:MZL_FONT(16)];
    [btnShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.equalTo(btnShare.superview.mas_left).offset(45);
        make.right.equalTo(btnShare.superview.mas_right).offset(-45);
        make.top.equalTo(lblSucceed.mas_bottom).offset(120);
        make.centerX.equalTo(lblSucceed.mas_centerX);
    }];
    [btnShare setHidden:![UIViewController mzl_shouldShowShareShortArticleModuleWithWeixin]];
    [btnShare addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnBack = [contentView createSubview:[UIButton class]];
    [btnBack co_setNormalBgColor:colorWithHexString(@"#ffffff") highlightBgColor:colorWithHexString(@"#434343")];
    [btnBack co_setCornerRadius:5.0];
    [btnBack setTitle:@"返回" forState:UIControlStateNormal];
    [btnBack setTitleFont:MZL_FONT(16)];
    [btnBack setTitleColor:colorWithHexString(@"#434343") forState:UIControlStateNormal];
    [btnBack setTitleColor:colorWithHexString(@"#ffffff") forState:UIControlStateHighlighted];
    [btnBack.layer setBorderWidth:1.0];
    [btnBack.layer setBorderColor:colorWithHexString(@"#434343").CGColor];
    [btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.equalTo(btnShare.superview.mas_left).offset(45);
        make.right.equalTo(btnShare.superview.mas_right).offset(-45);
        make.top.equalTo(btnShare.mas_bottom).offset(36);
        make.centerX.equalTo(lblSucceed.mas_centerX);
        make.bottom.equalTo(btnShare.superview.mas_bottom);
    }];
    [btnBack addTarget:self action:@selector(backToMyShortArticle) forControlEvents:UIControlEventTouchUpInside];
    
    [vwSucceed setAlpha:0.0];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [vwSucceed setAlpha:1.0];
    }];
}

- (void)backToMyShortArticle {
    UIViewController *presentingCtrl = self.presentingViewController;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if ([presentingCtrl isKindOfClass:[MZLTabBarViewController class]]) {
            [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_MY_TO_ARTICLE];
            MZLTabBarViewController *tabBarCtrl = (MZLTabBarViewController *)presentingCtrl;
            [tabBarCtrl toMyTab];
        }
    }];
}


#pragma mark - textFiled Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == TAG_COST_TEXTFIELD) {
        [self.view viewWithTag:TAG_RMB_LABEL].hidden = NO;
    } else if (textField == self.tagTextField) {
        self.tagTextField.text = CO_CHAR_ZERO_WIDTH_SPACE;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.tagTextField) {
        [self addCustomTag];
    } else if (textField.tag == TAG_COST_TEXTFIELD && textField.text.length == 0) {
        [self.view viewWithTag:TAG_RMB_LABEL].hidden = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.tagTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.tagTextField) {
        NSString *tagText = [textField.text co_strip];
        
        /* 如果输入的为空格准备创建一个tag */
        if ([string isEqualToString:@" "]) {
            if (isEmptyString(tagText)) {
                textField.text = CO_CHAR_ZERO_WIDTH_SPACE;
                return NO;
            }
            textField.text = tagText;
            [self _addCustomTag];
            return NO;
        }
        
        /* 如果输入的为delete准备删除一个tag */
        if (string.length == 0 && range.length > 0) {
            if (isEmptyString(tagText)) {
                [self deleteCustomTag];
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - keyboard notification

- (void)co_onWillShowKeyboard:(NSNotification *)noti keyboardBounds:(CGRect)keyboardBounds {
    //获取当前scroll view 的 contentOffset
    self.contentOffset =  self.contentScrollView.contentOffset;
    self.contentScrollView.contentOffset = CGPointMake(0, self.contentScrollView.contentSize.height - CO_SCREEN_HEIGHT + 45);
}

- (void)co_onWillHideKeyboard:(NSNotification *)noti {
    //重置scroll view 的 contentOffset
    self.contentScrollView.contentOffset = self.contentOffset;
}

- (NSDictionary *)selectedTags {
    NSMutableArray *crowdTags = [[NSMutableArray alloc] init];
    NSMutableArray *featureTags = [[NSMutableArray alloc] init];
    NSMutableArray *customTags = [[NSMutableArray alloc] init];
    for (MZLShortArticleTagItem *tag in self.crowdTags) {
        if (tag.selected) {
            [crowdTags addObject:[tag.lblTag.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        }
    }
    for (MZLShortArticleTagItem *tag in self.featureTags) {
        if (tag.selected) {
            [featureTags addObject:[tag.lblTag.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        }
    }
    for (MZLShortArticleCustomTagItem *tag in self.customTags) {
        [crowdTags addObject:[tag.lblTag.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }
    
    NSDictionary *tagsDic = @{KEY_TAG_CROWD:crowdTags , KEY_TAG_FEATURE:featureTags , KEY_TAG_CUSTOM:customTags};
    return tagsDic;
}

#pragma mark - help methods

- (NSString *)textForUploadingPhoto {
    NSString *format = @"图片上传中(%d/%d)，请稍候...";
    NSString *result = [NSString stringWithFormat:format, [self.model countOfUploadedPhotos], self.model.photos.count];
    return result;
}

- (void)hideNavigationBar:(BOOL)hidden {
    [self.navigationController.navigationBar setHidden:hidden];
}

- (void)showPostingIndicator:(BOOL)hidden {
    [self.vwIndicator setHidden:!hidden];
}

- (NSArray *)sortedArrayWithLength:(NSArray *)arr {
    NSArray *temp = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger len0 = [(NSString *)obj1 length];
        NSUInteger len1 = [(NSString *)obj2 length];
        return len0 > len1 ? NSOrderedDescending : NSOrderedAscending;
    }];
    return temp;
}

- (UIButton *)postButton {
    UIButton *postButton = [[UIButton alloc] init];
    [postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@64);
        make.height.equalTo(@28);
    }];
    postButton.titleLabel.font = MZL_FONT(14.0);
    [postButton co_setCornerRadius:4.0];
    [postButton setTitle:@"发  布" forState:UIControlStateNormal];
    [postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [postButton co_setNormalBgColor:colorWithHexString(@"#ffd521") highlightBgColor:colorWithHexString(@"#ffc321")];
    [postButton addTarget:self action:@selector(postShortArticle) forControlEvents:UIControlEventTouchUpInside];
    return postButton;
}

- (UIImage *)blurWithImageEffects:(UIImage *)image
{
    return [image applyBlurWithRadius:10 tintColor:[UIColor colorWithWhite:1 alpha:0.5] saturationDeltaFactor:1.5 maskImage:nil];
}

#pragma mark - share

- (void)share {
    MZLModelUser *user = [[MZLModelUser alloc] init];
    user.identifier = [MZLSharedData appUserId];
    self.model.author = user;
    [self mzl_shareToWeixinWithShortArticle:self.model];
}

- (void)mzl_onShareShortArticleSuccess {
    [self backToMyShortArticle];
}

- (void)mzl_onShareShortArticleFailure {
    [self backToMyShortArticle];
}

@end
