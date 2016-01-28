//
//  MZLShortArticleDetailVC.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLShortArticleDetailVC.h"
#import "MZLModelShortArticle.h"
#import "UIView+MZLAdditions.h"
#import "UIImageView+MZLNetwork.h"
#import "UILabel+COAdditions.h"
#import "MZLShortArticleCommentCell.h"
#import "UITableView+COAddition.h"
#import "MZLServices.h"
#import "COKeyboardToolbar.h"
#import <IBAlertView.h>
#import "MZLModelLocationBase.h"
#import "UIButton+COAddition.h"
#import "UITextView+COAddition.h"
#import "MZLPagingSvcParam.h"
#import <IBMessageCenter.h>
#import "UIViewController+MZLShortArticle.h"
#import "MZLModelShortArticleComment.h"
#import "MZLLoginViewController.h"
#import "MZLAuthorDetailViewController.h"
#import "MZLHighlightedControl.h"

#define H_MARGIN 15.0
#define MAX_DISPLAY_PHOTO 9

#define POS_BOTTOM 1
#define POS_OFF_SCREEN 2

#define ADD_COMMENT 1
#define REMOVE_COMMENT 2

//#define OBSERVE_KEY_FRAME @"frame"

@interface MZLShortArticleDetailVC () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate> {
    __weak COKeyboardToolbar *_toolbar;
    UIView *_commentBarBg;
    COKeyboardToolbar *_commentBar;
    __weak UITextView *_commentTextView;
    __weak UIButton *_sendBtn;
    __weak UIWebView *_adWebView;
    //    __weak COKeyboardToolbar *_placeholderBar;
}

@property (nonatomic, weak) UILabel *commentLbl;
@property (nonatomic, weak) UILabel *upsLbl;
@property (nonatomic, weak) UILabel *buyLbl;
@property (nonatomic, weak) UIImageView *upsImage;

@property (nonatomic, assign) BOOL scrollToTheFirstComment;

@property (weak, nonatomic) IBOutlet UIImageView *authorImage;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UITableView *tvComments;

@property (nonatomic, weak) UIButton *attentionBtn;
@property (nonatomic, weak) UIAlertView *alert;

@end

@implementation MZLShortArticleDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 以短文有没有图片判断是否需要取详细
    if (self.shortArticle.photos.count == 0) {
        self.authorName.text = @"";
        [self.tvComments removeUnnecessarySeparators];
        [self showNetworkProgressIndicator];
        [MZLServices shortArticleDetailServiceWithId:self.shortArticle.identifier succBlock:^(NSArray *models) {
            [self hideProgressIndicator];
            if (models.count > 0) {
                self.shortArticle = models[0];
                [self initInternal];
            }
        } errorBlock:^(NSError *error) {
            [self onNetworkError];
        }];
    } else {
        [self initInternal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //刷新关注按钮的状态
    [self getAttentionStatus];
}

- (void)getAttentionStatus {
    
    if (![MZLSharedData isAppUserLogined]) {
        return;
    }
    
    MZLModelShortArticle *shortArticle = self.shortArticle;
    __weak MZLShortArticleDetailVC *weaSelf = self;
    [MZLServices attentionStatesForCurrentUser:shortArticle.author succBlock:^(NSArray *models) {
        if (models && models.count > 0) {
            shortArticle.author.isAttentionForCurrentUser = 1;
            if (shortArticle.author.identifier == weaSelf.shortArticle.author.identifier) {
                [weaSelf toggleAttention:shortArticle.author.isAttentionForCurrentUser];
            }
        }else {
            shortArticle.author.isAttentionForCurrentUser = 0;
            if (shortArticle.author.identifier == weaSelf.shortArticle.author.identifier) {
                [weaSelf toggleAttention:shortArticle.author.isAttentionForCurrentUser];
            }
        }
        
    } errorBlock:^(NSError *error) {
        MZLLog(@"erroe = %@",error);
    }];
}

- (void)toggleAttention:(BOOL)flag {
    UIImage *upImage = flag ? [UIImage imageNamed:@"attention_xiangqingye_cancel"] : [UIImage imageNamed:@"attention_xiangqingye"];
    [self.attentionBtn setImage:upImage forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self toggleToolbarPosition:POS_BOTTOM];
    if (self.popupCommentOnViewAppear) {
        self.popupCommentOnViewAppear = NO;
        [self onCommentClicked:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self toggleToolbarPosition:POS_OFF_SCREEN];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [_commentBar removeFromSuperview];
    [_commentBarBg removeFromSuperview];
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

- (void)initInternal {
    [self co_registerKeyboardNotification];
    [self initUI];
    [self initData];
    [self initAdWebView];
}

#pragma mark - override

- (void)_loadModels {
    [self hideProgressIndicator:NO];
    MZLPagingSvcParam *pagingParam = [self pagingParamFromModels];
    [self invokeService:@selector(commentsForShortArticle:pagingParam:succBlock:errorBlock:) params:@[self.shortArticle, pagingParam]];
}

- (void)_loadMore {
    MZLPagingSvcParam *pagingParam = [self pagingParamFromModels];
    [self invokeLoadMoreService:@selector(commentsForShortArticle:pagingParam:succBlock:errorBlock:) params:@[self.shortArticle, pagingParam]];
}

- (void)_onLoadSuccBlock:(NSArray *)modelsFromSvc {
    if (self.scrollToTheFirstComment) {
        self.scrollToTheFirstComment = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_models.count > 0) {
                [_tv scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        });
    }
}

- (BOOL)_canLoadMore {
    return YES;
}

- (UIView *)noRecordView {
    return nil;
}

- (void)_onDeleteSuccBlock:(NSArray *)modelsFromSvc indexPath:(NSIndexPath *)indexPath {
    [self onCommentStatusModified:REMOVE_COMMENT];
    dispatch_async(dispatch_get_main_queue(), ^{
        // fix 没有记录时有时不能正常显示section header的bug
        if (_models.count == 0) {
            [_tv reloadData];
        }
    });
}

#pragma mark - ad web view

- (void)initAdWebView {
    if ([self shouldShowAdView]) {
        UIWebView *adWebView = [[UIWebView alloc] init];
        [self.view addSubview:adWebView];
        [adWebView co_insetsParent:UIEdgeInsetsMake(MZL_TOP_BAR_HEIGHT, 0, COInvalidCons, 0) width:COInvalidCons height:40];
        adWebView.scrollView.scrollsToTop = NO;
        _adWebView = adWebView;
        [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(dismissAdView:) userInfo:nil repeats:NO];
        NSString *strUrl = [MZLSharedData youmengAdUrl];
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        [adWebView loadRequest:request];
    }
}

- (BOOL)shouldShowAdView {
    return ! isEmptyString([MZLSharedData youmengAdUrl]);
}

- (void)dismissAdView:(NSTimer *)timer{
    _adWebView.hidden = YES;
}

#pragma mark - service related

- (void)initData {
    [self loadModels];
}

- (void)addAttention {
    [MZLServices addAttentionForShortArticleUser:self.shortArticle.author succBlock:^(NSArray *models) {
        //
    } errorBlock:^(NSError *error) {
        //
    }];
}

- (void)removeAttention {
    MZLModelShortArticle *shortArticle = self.shortArticle;
    [MZLServices removeAttentionForShortArticleUser:shortArticle.author succBlock:^(NSArray *models) {
        //
    } errorBlock:^(NSError *error) {
        //
    }];
}

- (void)addUp {
    [MZLServices addUpForShortArticle:self.shortArticle succBlock:^(NSArray *models) {
        // ignore
        [IBMessageCenter sendMessageNamed:MZL_NOTIFICATION_SINGLE_SHORT_ARTICLE_UP_STATUS_MODIFIED forSource:self.shortArticle];
    } errorBlock:^(NSError *error) {
        // ignore
    }];
}

- (void)removeUp {
    MZLModelShortArticle *shortArticle = self.shortArticle;
    [MZLServices removeUpForShortArticle:shortArticle succBlock:^(NSArray *models) {
        // ignore
        [IBMessageCenter sendMessageNamed:MZL_NOTIFICATION_SINGLE_SHORT_ARTICLE_UP_STATUS_MODIFIED forSource:self.shortArticle];
    } errorBlock:^(NSError *error) {
        // ignore
    }];
}

- (void)_postComment:(NSString *)content {
    MZLModelShortArticleComment *comment = [[MZLModelShortArticleComment alloc] init];
    comment.content = content;
    
    [self toggleSendBtnState:NO];
    
    [MZLServices addComment:comment forShortArticle:self.shortArticle succBlock:^(NSArray *models) {
        [self onCommentStatusModified:ADD_COMMENT];
        [self toggleSendBtnState:YES];
        [self clearAndhideCommentBar];
        self.scrollToTheFirstComment = YES;
        [self loadModels];
    } errorBlock:^(NSError *error) {
        [self toggleSendBtnState:YES];
        [UIAlertView showAlertMessage:@"发送评论失败，请稍候再试！"];
    }];
}

- (void)deleteComment:(MZLModelShortArticleComment *)comment {
    NSInteger index = [_models indexOfObject:comment];
    if (index != NSNotFound) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self deleteCommentAtIndexPath:indexPath];
    }
}

- (void)onCommentStatusModified:(NSInteger)flag {
    if (flag == ADD_COMMENT) {
        self.shortArticle.commentsCount += 1;
    } else {
        self.shortArticle.commentsCount -= 1;
    }
    if (self.shortArticle.commentsCount <= 0) {
        self.shortArticle.commentsCount = 0;
    }
    [self updateLbl:_commentLbl withCount:self.shortArticle.commentsCount];
    [IBMessageCenter sendMessageNamed:MZL_NOTIFICATION_SINGLE_SHORT_ARTICLE_COMMENT_STATUS_MODIFIED forSource:self.shortArticle];
}

#pragma mark - init UI

- (void)initUI {
    
    UIButton *attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
    [attentionBtn setImage:[UIImage imageNamed:@"attention_xiangqingye"] forState:UIControlStateNormal];
    [attentionBtn addTarget:self action:@selector(onAttentionClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.attentionBtn = attentionBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:attentionBtn];
    if ([MZLSharedData appUserId] == self.shortArticle.author.identifier) {
        self.attentionBtn.hidden = YES;
    }
    [self toggleAttentionStatus];
    
    [self initAuthor];
    [self initTableView];
    [self initToolbar];
    [self initCommentBar];
}

- (void)initAuthor {
    if (self.shortArticle.author) {
        [self.authorImage co_toRoundShapeWithDiameter:24.0];
        [self.authorImage loadAuthorImageFromURL:self.shortArticle.author.headerImage.fileUrl];
        self.authorName.textColor = @"434343".co_toHexColor;
        self.authorName.text = self.shortArticle.author.nickName;
        [self.authorImage addTapGestureRecognizer:self action:@selector(onAuthorClicked:)];
        [self.authorName addTapGestureRecognizer:self action:@selector(onAuthorClicked:)];
    }
}

- (void)initTableView {
    _tv = self.tvComments;
    [self.tvComments removeUnnecessarySeparators];
    self.tvComments.separatorColor = @"D8D8D8".co_toHexColor;
    [self adjustTableViewBottomInset:CO_KB_TOOLBAR_HEIGHT scrollIndicatorBottomInset:CO_KB_TOOLBAR_HEIGHT];
    [self initShortArticleDetailAsTableHeader];
}

#pragma mark - comment bar

#define SEND_BTN_NO_TEXT_COLOR [[UIColor whiteColor] colorWithAlphaComponent:0.5]
#define SEND_BTN_TEXT_COLOR [UIColor whiteColor]
#define COMMENT_BAR_INITIAL_HEIGHT 57
// 最大5行高度，行高17
#define COMMENT_BAR_MAX_HEIGHT (57 + 17 * 4)
#define COMMENT_OUT_MARGIN 7.0
#define COMMENT_INNER_MARGIN 5.0
#define COMMENT_TOTAL_MARGIN (2 * COMMENT_OUT_MARGIN + 2 * COMMENT_INNER_MARGIN)

- (void)initCommentBar {
    UIView *commentBarBg = [[UIView alloc] initWithFrame:globalWindow().frame];
    _commentBarBg = commentBarBg;
    commentBarBg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    commentBarBg.alpha = 0;
    [commentBarBg addTapGestureRecognizer:self action:@selector(onCommentBgClicked:)];
    [globalWindow() addSubview:commentBarBg];
    
    COKeyboardToolbar *commentBar = [COKeyboardToolbar instanceWithHeight:COMMENT_BAR_INITIAL_HEIGHT];
    commentBar.topBorder.hidden = YES;
    commentBar.bottomBorder.hidden = YES;
    commentBar.backgroundColor = @"F5F5F5".co_toHexColor;
    _commentBar = commentBar;
    CGRect frame = commentBar.frame;
    frame.origin.y = self.view.height;
    commentBar.frame = frame;
    [globalWindow() addSubview:commentBar];
    
    CGFloat margin = COMMENT_OUT_MARGIN;
    UIButton *sendBtn = [commentBar createSubViewBtn];
    _sendBtn = sendBtn;
    [sendBtn setTitleColor:SEND_BTN_NO_TEXT_COLOR forState:UIControlStateNormal];
    sendBtn.titleLabel.font = MZL_FONT(14.0);
    [sendBtn co_setCornerRadius:3.0];
    [sendBtn co_setNormalBgColor:@"37BF4B".co_toHexColor highlightBgColor:@"30AD42".co_toHexColor];
    [sendBtn co_insetsParent:UIEdgeInsetsMake(margin, COInvalidCons, COInvalidCons, margin)];
    [sendBtn co_rightParentWithOffset:margin];
    [sendBtn co_width:56 height:42];
    [sendBtn addTarget:self action:@selector(postComment:) forControlEvents:UIControlEventTouchUpInside];
    [self toggleSendBtnState:YES];
    
    UIView *textViewContainer = [[commentBar createSubView] co_insetsParent:UIEdgeInsetsMake(margin, margin, margin, COInvalidCons)];
    [textViewContainer co_rightFromLeftOfView:sendBtn offset:12];
    textViewContainer.layer.borderColor = [@"D8D8D8".co_toHexColor CGColor];
    textViewContainer.layer.cornerRadius = 4.0;
    textViewContainer.layer.borderWidth = 1.0;
    textViewContainer.clipsToBounds = YES;
    textViewContainer.backgroundColor = [UIColor whiteColor];
    UITextView *textView = [[UITextView alloc] init];
    _commentTextView = textView;
    [textViewContainer addSubview:textView];
    [textView co_offsetParent:COMMENT_INNER_MARGIN];
    CGFloat fontSize = 14.0;
    textView.font = MZL_FONT(fontSize);
    textView.textColor = @"434343".co_toHexColor;
    textView.delegate = self;
    //    textView.scrollEnabled = NO;
    UILabel *placeHolderLbl = [textViewContainer createSubViewLabelWithFontSize:fontSize textColor:@"D8D8D8".co_toHexColor];
    placeHolderLbl.text = @"添加评论";
    [placeHolderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(textView).offset(6);
    }];
    [textView co_addPlaceholderLabel:placeHolderLbl];
}

- (void)toggleSendBtnState:(BOOL)flag {
    NSString *keyIndicator = @"keyIndicator";
    if (flag) {
        UIActivityIndicatorView *indicator = [_sendBtn getProperty:keyIndicator];
        if (indicator) {
            [indicator removeFromSuperview];
        }
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    } else {
        [_sendBtn setTitle:@"" forState:UIControlStateNormal];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_sendBtn addSubview:indicator];
        [_sendBtn setProperty:keyIndicator value:indicator];
        [indicator co_centerParent];
        [indicator startAnimating];
    }
    _sendBtn.enabled = flag;
    if (isEmptyString(_commentTextView.text)) {
        _sendBtn.enabled = NO;
    }
}

- (void)clearAndhideCommentBar {
    [_commentTextView resignFirstResponder];
    _commentTextView.text = @"";
    [self textViewDidChange:_commentTextView];
}

- (void)toggleCommentBarBg:(BOOL)flag {
    CGFloat toAlpha = 0.0;
    if (flag) {
        toAlpha = 1.0;
    }
    if (_commentBarBg.alpha == toAlpha) {
        return;
    }
    [UIView animateWithDuration:0.8 animations:^{
        _commentBarBg.alpha = toAlpha;
    }];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {}

#pragma mark - text view delegate (comment bar)

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView co_hidePlaceholderLabel];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView co_checkPlaceholder];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (isEmptyString(textView.text)) {
        _sendBtn.enabled = NO;
        [_sendBtn setTitleColor:SEND_BTN_NO_TEXT_COLOR forState:UIControlStateNormal];
    } else {
        _sendBtn.enabled = YES;
        [_sendBtn setTitleColor:SEND_BTN_TEXT_COLOR forState:UIControlStateNormal];
    }
    CGFloat textViewFittingHeight = [textView co_getFittingHeight];
    CGFloat commentBarFittingHeight = textViewFittingHeight + COMMENT_TOTAL_MARGIN;
    if (commentBarFittingHeight > COMMENT_BAR_MAX_HEIGHT) {
        //        textView.scrollEnabled = YES;
    } else {
        //        textView.scrollEnabled = NO;
        if (commentBarFittingHeight != _commentBar.height) {
            CGRect frame = _commentBar.frame;
            CGFloat deltaY = commentBarFittingHeight - frame.size.height;
            frame.size.height = commentBarFittingHeight;
            frame.origin.y -= deltaY;
            _commentBar.frame = frame;
        }
    }
}

#pragma mark - toolbar

- (void)initToolbar {
    COKeyboardToolbar *toolbar = [COKeyboardToolbar instance];
    toolbar.bottomBorder.hidden = YES;
    CGRect frame = toolbar.frame;
    frame.origin.y = self.view.height;
    toolbar.frame = frame;
    [self.view addSubview:toolbar];
    _toolbar = toolbar;
    
    UIView *upView = [self createImageLblView:_toolbar imageName:@"Short_Article_Up"];
    [upView co_centerYParent];
    [upView co_leftParentWithOffset:24];
    [upView addTapGestureRecognizer:self action:@selector(onUpViewClicked:)];
    self.upsImage = upView.subviews[0];
    self.upsLbl = upView.subviews[1];
    [self toggleUpStatus];
    
    UIView *commentView = [self createImageLblView:_toolbar imageName:@"Short_Article_Comment"];
    [commentView co_centerYParent];
    [commentView co_leftFromRightOfView:upView offset:25];
    [commentView addTapGestureRecognizer:self action:@selector(onCommentClicked:)];
    self.commentLbl = commentView.subviews[1];
    [self updateLbl:self.commentLbl withCount:self.shortArticle.commentsCount];
    
    //    if (self.shortArticle.goodsCount > 0) {
    UIView *lblGoodsImage = [self createImageLblView:_toolbar imageName:@"short_article_gouwu"];
    [lblGoodsImage co_centerYParent];
    [lblGoodsImage co_leftFromRightOfView:commentView offset:25];
    [lblGoodsImage addTapGestureRecognizer:self action:@selector(onGoodsViewClicked:)];
    self.buyLbl = lblGoodsImage.subviews[1];
    [self updateLbl:self.buyLbl withCount:self.shortArticle.goodsCount];
    //    }
    
    UIImageView *report = [_toolbar createSubViewImageViewWithImageNamed:@"Short_Article_Report"];
    [report co_centerYParent];
    [report co_rightParentWithOffset:24];
    [report addTapGestureRecognizer:self action:@selector(onReportBtnClicked:)];
    
#pragma mark - 点赞评论转发的按钮的位置修复
    if ([UIViewController mzl_shouldShowShareShortArticleModule]) {
        UIView *shareIcon = [_toolbar createSubViewImageViewWithImageNamed:@"Short_Article_Share"];
        [shareIcon co_centerYParent];
        //         [shareIcon co_rightParentWithOffset:24];
        [shareIcon co_rightFromLeftOfView:report offset:25];
        [shareIcon addTapGestureRecognizer:self action:@selector(share)];
    }
}

- (UIView *)createImageLblView:(UIView *)superview imageName:(NSString *)imageName {
    UIView *view = [superview createSubView];
    CGFloat height = 24;
    [view co_height:height];
    UIImageView *image = [view createSubViewImageViewWithImageNamed:imageName];
    [image co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, COInvalidCons)];
    [image co_centerYParent];
    [image co_width:height height:height];
    UILabel *lbl = [view createSubViewLabelWithFontSize:14 textColor:@"999999".co_toHexColor];
    [lbl co_centerYParent];
    [lbl co_insetsParent:UIEdgeInsetsMake(COInvalidCons, COInvalidCons, COInvalidCons, 0)];
    [lbl co_leftFromRightOfView:image offset:6];
    //    view.backgroundColor = [UIColor blueColor];
    //    image.backgroundColor = [UIColor orangeColor];
    //    lbl.backgroundColor = [UIColor greenColor];
    return view;
}

- (void)toggleToolbarPosition:(NSInteger)posFlag {
    [self bottomBar:_toolbar toPos:posFlag completionBlock:nil];
}

- (void)toggleUpImage:(BOOL)flag {
    if (flag) {
        self.upsImage.image = [UIImage imageNamed:@"Short_Article_Up_Hi"];
        self.upsLbl.textColor = @"439CFF".co_toHexColor;
    } else {
        self.upsImage.image = [UIImage imageNamed:@"Short_Article_Up"];
        self.upsLbl.textColor = @"B9B9B9".co_toHexColor;
    }
}

- (void)toggleUpStatus {
    [self toggleUpImage:self.shortArticle.isUpForCurrentUser];
    [self updateLbl:self.upsLbl withCount:self.shortArticle.upsCount];
}

- (void)toggleAttentionStatus {
    [self toggleAttentionImage:self.shortArticle.author.isAttentionForCurrentUser];
}

- (void)toggleAttentionImage:(BOOL)flag {
    if (flag) {
        [self.attentionBtn setImage:[UIImage imageNamed:@"attention_xiangqingye_cancel"] forState:UIControlStateNormal];
    }else {
        [self.attentionBtn setImage:[UIImage imageNamed:@"attention_xiangqingye"] forState:UIControlStateNormal];
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

#pragma mark - short article detail as table header

- (void)initShortArticleDetailAsTableHeader {
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tvComments.width, 0)];
    
    UIView *wrapper = [[tableHeader createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0)];
    
    UIView *content = [[wrapper createSubView] co_insetsParent:UIEdgeInsetsMake(24.0, H_MARGIN, COInvalidCons, H_MARGIN)];
    [self initAddress:content];
    [self initContent:content];
    [self initPhotos:content];
    [self initTags:content];
    [self initDateAndConsumption:content];
    [content co_encloseSubviews];
    
    UIView *sep = [wrapper createSepViewWithColor:@"D8D8D8".co_toHexColor];
    [sep co_topFromBottomOfPreSiblingWithOffset:15];
    [wrapper co_encloseSubviews];
    tableHeader.height = wrapper.co_fittingHeight;
    
    self.tvComments.tableHeaderView = tableHeader;
    
    //    tableHeader.backgroundColor = [UIColor blackColor];
    //    wrapper.backgroundColor = [UIColor lightGrayColor];
    //    content.backgroundColor = [UIColor greenColor];
}

- (void)initAddress:(UIView *)superview {
    CGFloat maxWidth = CO_SCREEN_WIDTH - 2 * H_MARGIN;
    
    MZLHighlightedControl *addressView = [[MZLHighlightedControl alloc] init];
    addressView.highlightedColor = @"F0F4FC".co_toHexColor;
    [addressView.layer setCornerRadius:3.0];
    [superview addSubview:addressView];
    [addressView co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, COInvalidCons)];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.lessThanOrEqualTo(@(maxWidth));
    }];
    [addressView addTapGestureRecognizer:self action:@selector(onAddressClicked:)];
    
    UILabel *lbl = [addressView createSubViewLabelWithFontSize:16.0 textColor:@"439CFF".co_toHexColor];
    lbl.text = self.shortArticle.location.locationName;
    lbl.numberOfLines = 0;
    lbl.preferredMaxLayoutWidth = maxWidth;
    [lbl co_offsetParent:4.0];
    [lbl co_addLeadingImage:[UIImage imageNamed:@"Short_Article_Location_Blue"] imageFrame:CGRectMake(0, 1, 12.0, 12.0) spaceWidthBetweenImageAndTexts:4];
}

- (void)initContent:(UIView *)superview {
    UILabel *lbl = [superview createSubViewLabelWithFontSize:18 textColor:@"434343".co_toHexColor];
    lbl.text = self.shortArticle.content;
    lbl.numberOfLines = 0;
    [lbl co_topFromBottomOfPreSiblingWithOffset:15];
    [[lbl co_leftParent] co_rightParent];
    lbl.preferredMaxLayoutWidth = CO_SCREEN_WIDTH - 2 * H_MARGIN;
}

- (void)initPhotos:(UIView *)superview {
    UIView *photoView = [superview createSubView];
    [photoView co_hOffsetParent:0];
    [photoView co_topFromBottomOfPreSiblingWithOffset:15];
    
    CGFloat photoViewHeight = 0;
    NSArray *photos = self.shortArticle.sortedPhotos;
    if (photos.count > 1) {
        NSInteger photoCount = MIN(photos.count, MAX_DISPLAY_PHOTO);
        NSInteger itemsPerRow = 3;
        CGFloat photoMargin = 5.0;
        CGFloat photoSize = floorf((self.view.width - 2 * H_MARGIN - photoMargin * (itemsPerRow - 1)) / itemsPerRow);
        NSInteger rowCount = (photoCount - 1) / itemsPerRow + 1;
        photoViewHeight = rowCount * photoSize + (rowCount - 1) * photoMargin;
        
        for (int i = 0; i < photoCount; i++) {
            CGFloat x = (i % 3) * (photoSize + photoMargin);
            CGFloat y = (i / 3) * (photoSize + photoMargin);
            UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, photoSize, photoSize)];
            [photoView addSubview:photo];
            MZLModelImage *image = photos[i];
            [photo loadSmallLocationImageFromURL:image.fileUrl];
        }
    } else if (photos.count == 1) {
        photoViewHeight = 230;
        UIImageView *photo = [photoView createSubViewImageView];
        [photo co_withinParent];
        MZLModelImage *image = photos[0];
        //        [photo loadArticleImageFromURL:image.fileUrl callbackOnImageLoaded:nil];
        [self mzl_loadSingleImageWithImageView:photo fileUrl:image.fileUrl];
    }
    
    [photoView co_height:photoViewHeight];
    [photoView addTapGestureRecognizer:self action:@selector(onPhotoClicked:)];
    
    //    photoView.backgroundColor = [UIColor greenColor];
}

- (void)initTags:(UIView *)superview {
    UIView *tagsView = [superview createSubView];
    [tagsView co_hOffsetParent:0];
    [tagsView co_topFromBottomOfPreSiblingWithOffset:15];
    
    NSArray *tags = [self.shortArticle.tags split:@" "];
    if (tags.count > 0) {
        CGFloat top = 0;
        CGFloat left = 0;
        // 所有lblViewHeight均相等，只需设置一次即可
        CGFloat lblViewHeight = 0;
        CGFloat margin = 5.0;
        CGFloat maxWidth = CO_SCREEN_WIDTH - 2 * H_MARGIN;
        for (NSString *tag in tags) {
            UIView *lblView = [tagsView createSubView];
            lblView.backgroundColor = @"D8D8D8".co_toHexColor;
            lblView.layer.cornerRadius = 3.0;
            lblView.clipsToBounds = YES;
            UILabel *lbl = [lblView createSubViewLabelWithFontSize:14.0 textColor:[UIColor whiteColor]];
            lbl.text = tag;
            [lbl co_offsetParent:3.0];
            CGSize lblViewSize = [lblView co_fittingSize];
            if (lblViewHeight == 0) {
                lblViewHeight = lblViewSize.height;
            }
            CGFloat lblViewWidth = lblViewSize.width;
            if (lblViewWidth > maxWidth - margin) {
                [lblView co_width:(maxWidth - margin)];
                if (left > 0) {
                    // 换行
                    left = 0;
                    top += lblViewHeight + margin;
                }
            } else if (left + lblViewWidth > maxWidth) {
                left = 0;
                top += lblViewHeight + margin;
            }
            [lblView co_insetsParent:UIEdgeInsetsMake(top, left, COInvalidCons, COInvalidCons)];
            left += lblViewSize.width + margin;
        }
        UIView *lastSubview = tagsView.subviews.lastObject;
        [lastSubview co_bottomParent];
    } else {
        [tagsView co_height:0];
    }
    
    //    tagsView.backgroundColor = [UIColor orangeColor];
}

- (void)initDateAndConsumption:(UIView *)superview {
    UIView *view = [superview createSubView];
    [view co_hOffsetParent:0];
    [view co_topFromBottomOfPreSiblingWithOffset:26];
    [view co_height:20];
    
    //    UIImageView *dateIcon = [view createSubViewImageView];
    //    [[[dateIcon co_leftParent] co_bottomParent] co_width:12.0 height:12.0];
    UILabel *dateLbl = [view createSubViewLabelWithFontSize:10 textColor:@"CCCCCC".co_toHexColor];
    //    [dateLbl co_leftFromRightOfView:dateIcon offset:4.0];
    [dateLbl co_leftParent];
    [dateLbl co_bottomParent];
    dateLbl.text = self.shortArticle.publishedAtStr;
    
    if (self.shortArticle.consumption > 0) {
        UILabel *consumptionLbl1 = [view createSubViewLabelWithFontSize:12.0 textColor:@"999999".co_toHexColor];
        consumptionLbl1.text = @"/人";
        [[consumptionLbl1 co_bottomParent] co_rightParent];
        UILabel *consumptionLbl = [view createSubViewLabelWithFont:MZL_BOLD_FONT(18.0) textColor:@"999999".co_toHexColor];
        consumptionLbl.text = INT_TO_STR(self.shortArticle.consumption);
        [[consumptionLbl co_topParent] co_rightFromLeftOfView:consumptionLbl1 offset:0];
        UILabel *consumptionLbl2 = [view createSubViewLabelWithFontSize:12.0 textColor:@"999999".co_toHexColor];
        consumptionLbl2.text = @"RMB";
        [[consumptionLbl2 co_bottomParent] co_rightFromLeftOfView:consumptionLbl offset:2];
    }
    
    //    view.backgroundColor = [UIColor purpleColor];
    
}

#pragma mark - table data source and delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    MZLModelShortArticleComment *comment = [MZLMockData mockShortArticleComment];
    MZLModelShortArticleComment *comment = _models[indexPath.row];
    MZLShortArticleCommentCell *cell = [MZLShortArticleCommentCell cellFromModel:comment tableView:tableView];
    cell.ownerController = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    MZLModelShortArticleComment *comment = [MZLMockData mockShortArticleComment];
    MZLModelShortArticleComment *comment = _models[indexPath.row];
    return [MZLShortArticleCommentCell heightFromModel:comment tableView:tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (! _models) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForHeaderInSection:section])];
            UIView *content = [[view createSubView] co_centerParent];
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [content addSubview:indicator];
            [indicator co_insetsParent:UIEdgeInsetsMake(0, 0, 0, COInvalidCons)];
            UILabel *lbl = [content createSubViewLabelWithFontSize:12 textColor:@"999999".co_toHexColor];
            lbl.text = @"评论加载中，请稍候...";
            [lbl co_leftFromRightOfView:indicator offset:6];
            [[lbl co_centerYParent] co_rightParent];
            [indicator startAnimating];
            return view;
        } else if (_models.count == 0) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForHeaderInSection:section])];
            UILabel *lbl = [view createSubViewLabelWithFontSize:12 textColor:@"999999".co_toHexColor];
            lbl.text = @"暂无评论";
            [lbl co_centerParent];
            return view;
        } else {
            return nil;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (! _models || _models.count == 0) {
            return 80;
        } else {
            return 0;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deleteCommentAtIndexPath:indexPath];
}

- (void)deleteCommentAtIndexPath:(NSIndexPath *)indexPath {
    MZLModelNotice *commentToDelete = _models[indexPath.row];
    [self deleteModelOnIndexPath:indexPath selector:@selector(removeComment:forShortArticle:succBlock:errorBlock:) params:@[commentToDelete, self.shortArticle]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLModelShortArticleComment *comment = _models[indexPath.row];
    return comment.canEdit;
}

#pragma mark - keyboard events

- (void)co_onKeyboardWillChangeFrame:(NSNotification *)noti kbBeginFrame:(CGRect)kbBeginFrame kbEndFrame:(CGRect)kbEndFrame {
    CGFloat kbHeight = kbEndFrame.size.height;
    [_commentBar co_animateToY:(self.view.height - kbHeight - _commentBar.height) completionBlock:nil];
}

- (void)co_onWillHideKeyboard:(NSNotification *)noti {
    [self toggleCommentBarBg:NO];
    [self bottomBar:_commentBar toPos:POS_OFF_SCREEN completionBlock:nil];
}

- (void)co_onWillShowKeyboard:(NSNotification *)noti keyboardBounds:(CGRect)keyboardBounds {
    [self toggleCommentBarBg:YES];
}

//- (void)co_onKeyboardDidChangeFrame:(NSNotification *)noti kbBeginFrame:(CGRect)kbBeginFrame kbEndFrame:(CGRect)kbEndFrame {}

#pragma mark - events handler

- (MZLModelLocationBase *)locationBaseFromSurroudingLocation {
    MZLModelLocationBase *loc = [[MZLModelLocationBase alloc] init];
    loc.name = self.shortArticle.location.locationName;
    loc.identifier = self.shortArticle.location.identifier;
    return loc;
}

- (void)onAttentionClicked:(UITapGestureRecognizer *)tap {
    if (![MZLSharedData isAppUserLogined]) {
        [UIAlertView showAlertMessage:@"请先登入"];
        return;
    }
    
    if (self.shortArticle.author.isAttentionForCurrentUser) {
        self.shortArticle.author.isAttentionForCurrentUser = NO;
        [self.attentionBtn setImage:[UIImage imageNamed:@"attention_xiangqingye"] forState:UIControlStateNormal];
        [self removeAttention];
    }else{
        self.shortArticle.author.isAttentionForCurrentUser = YES;
        [self.attentionBtn setImage:[UIImage imageNamed:@"attention_xiangqingye_cancel"] forState:UIControlStateNormal];
        [self addAttention];
    }
}

- (void)onGoodsViewClicked:(UITapGestureRecognizer *)tap {
    [self toLocationDetailGoods:[self locationBaseFromSurroudingLocation]];
}

- (void)onAuthorClicked:(UITapGestureRecognizer *)tap {
    [self toAuthorDetailWithAuthor:self.shortArticle.author];
}

- (void)onPhotoClicked:(UITapGestureRecognizer *)tap {
    [self mzl_toShortArticlePhotoGallery:self.shortArticle];
}

- (void)onUpViewClicked:(UITapGestureRecognizer *)tap {
    if (self.shortArticle.isUpForCurrentUser) {
        self.shortArticle.upsCount = self.shortArticle.upsCount - 1;
        self.shortArticle.isUpForCurrentUser = NO;
        [self removeUp];
        [tap.view co_animation_layerScale:1.1 delegate:self];
    } else {
        self.shortArticle.upsCount = self.shortArticle.upsCount + 1;
        self.shortArticle.isUpForCurrentUser = YES;
        [self addUp];
        [tap.view co_animation_layerScale:1.1 delegate:self];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self toggleUpStatus];
    }
}

- (void)onAddressClicked:(UITapGestureRecognizer *)tap {
    [self toLocationDetailWithLocation:[self locationBaseFromSurroudingLocation]];
}

- (void)onCommentClicked:(UITapGestureRecognizer *)tap {
    if (shouldPopupLogin()) {
        [self popupLoginFrom:MZLLoginPopupFromComment executionBlockWhenDismissed:nil];
        return;
    }
    [_commentTextView becomeFirstResponder];
}

- (void)onCommentBgClicked:(UITapGestureRecognizer *)tap {
    [_commentTextView resignFirstResponder];
}

- (void)postComment:(id)sender {
    NSString *comment = [_commentTextView.text co_strip];
    if (isEmptyString(comment)) {
        [UIAlertView showAlertMessage:@"评论没有内容哟！"];
        return;
    }
    if (comment.length > 200) {
        [UIAlertView showAlertMessage:@"评论内容太长了哟(最多200个字符)！"];
        return;
    }
    [IBAlertView showAlertWithTitle:MZL_MSG_ALERT_VIEW_TITLE message:@"确定发送该评论吗？" dismissTitle:MZL_MSG_CANCLE okTitle:MZL_MSG_OK dismissBlock:^{
    } okBlock:^{
        [self _postComment:comment];
    }];
}

#pragma mark - helper methods

- (void)onReportBtnClicked:(id)sender
{
    UIActionSheet *reportSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报", nil];
    reportSheet.delegate=self;
    [reportSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"确定举报这篇玩法？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"举报", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==1)
    {
        [self report];
    }
}

- (void)report
{
    [MZLServices reportForShortArticle:self.shortArticle succBlock:^(NSArray *models) {
        [self alertMessage:@"举报成功"];
    } errorBlock:^(NSError *error) {
        [self alertMessage:@"举报失败"];
    }];
}

- (void)alertMessage:(NSString *)message
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    self.alert=alert;
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(dismissAlertView:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)dismissAlertView:(NSTimer*)timer
{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
}

/*
 * 分享
 */
- (void)share {
    [self mzl_shareShortArticle:self.shortArticle];
}

- (void)bottomBar:(UIView *)bottomBar toPos:(NSInteger)posFlag completionBlock:(void (^)(void))completionBlock {
    if (posFlag == POS_BOTTOM) {
        [bottomBar co_animateToY:self.view.height - bottomBar.height completionBlock:completionBlock];
    } else if (posFlag == POS_OFF_SCREEN) {
        [bottomBar co_animateToY:self.view.height completionBlock:completionBlock];
    }
}

@end
