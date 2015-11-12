//
//  MZLArticleCommentViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-7-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLArticleCommentViewController.h"
#import "MZLCommentBar.h"
#import "MZLCommentItemCell.h"
#import "MZLServices.h"
#import "MZLModelArticle.h"
#import "MZLModelComment.h"
#import "MZLModelUser.h"
#import "MZLPagingSvcParam.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLSharedData.h"
#import "MZLLoginViewController.h"
#import "MZLCommentResponse.h"
#import "MZLArticleDetailViewController.h"
#import <IBAlertView.h>

#define PLACEHOLDER_TEXT @"添加评论"
#define COMMENT_LINE_HEIGHT 35

@interface MZLArticleCommentViewController (){
    CGFloat _heightOfKeyboard;
    MZLCommentBar *_commentBar;
    NSInteger _countOfAddedComment;
    NSInteger _countOfDeletedComment;
    NSIndexPath *_editingIndexPath;
    MZLCommentItemCell *_prototypeCell;
}

@end

@implementation MZLArticleCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [self.textComment setDelegate:self];
    [self initInternal];
    [self loadComments];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancelEditState:NO];
    [self.articleDetailViewController updateCommentCount:(_countOfAddedComment - _countOfDeletedComment)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - init

- (void)initInternal {
    // for calculating cell height
    _prototypeCell  = [self._tvComment dequeueReusableCellWithIdentifier:MZL_REUSEID_COMMENTCELL];
    
    _tv = self._tvComment;
    [_tv setSeparatorColor:MZL_SEPARATORS_BG_COLOR()];
    _tv.backgroundColor = MZL_BG_COLOR();
    self.consNoCommentTop.constant = 0;
    self.consNoCommentBottom.constant = MZL_HEIGHT_COMMENT_BAR;
    self.consTvBottom.constant = MZL_HEIGHT_COMMENT_BAR;
//    _tv.contentInset = UIEdgeInsetsMake(_tv.contentInset.top, _tv.contentInset.left, MZL_HEIGHT_COMMENT_BAR, _tv.contentInset.right);
    _commentBar = [MZLCommentBar commentBarInstance:self.view.frame.size];
    _commentBar.ownerController = self;
    [self.view addSubview:_commentBar];
    _tv.visible = NO;
//    self.vwNoComment.visible = NO;
    _commentBar.visible = NO;
    
    UITapGestureRecognizer *recognizer = [_tv addTapGestureRecognizer:self action:@selector(onTableViewTapped)];
    recognizer.cancelsTouchesInView = NO;
    
    [_commentBar addTapGestureRecognizer:self action:@selector(onCommentBarTapped)];
    [self registerForKeyboardNotifications];
}

- (void)createBarRightItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditState)];
}

- (void)cancelEditState {
    [self cancelEditState:YES];
}

- (void)cancelEditState:(BOOL)animated {
    _editingIndexPath = nil;
    self.navigationItem.rightBarButtonItem = nil;
    if ([_tv isEditing]) {
        [_tv setEditing:NO animated:animated];
    }
}

- (void)setEditState {
    [_tv setEditing:YES animated:YES];
    [self createBarRightItem];
}

- (void)onTableViewTapped {
    if ([_commentBar.textComment isFirstResponder]) {
        [_commentBar.textComment resignFirstResponder];
    }
}

- (void)onCommentBarTapped {
    [self cancelEditState];
}

#pragma mark - UI

- (void)toggleCommentView {
    _commentBar.visible = YES;
    if (_models.count > 0) {
        [self._tvComment setVisible:YES];
//        [self.vwNoComment setVisible:NO];
    } else {
        [self._tvComment setVisible:NO];
//        [self.vwNoComment setVisible:YES];
//        [self.lblNocomment setTextColor:colorWithHexString(@"#d4d6d9")];
    }
}

#pragma mark - service related

- (void)loadComments {
    MZLPagingSvcParam *svcParam = [self pagingParamFromModels];
    svcParam.lastId = 0;
    [self loadModels:@selector(commentForArticle:pagingParam:succBlock:errorBlock:) params:@[self.article, svcParam]];
}

- (void)addComment {
    [self cancelEditState];
    NSString *content = _commentBar.textComment.text;
    if (shouldPopupLogin()) {
        [self popupLoginFrom:MZLLoginPopupFromComment executionBlockWhenDismissed:nil];
        return;
    }
    MZLModelComment *comment = [[MZLModelComment alloc] init];
    comment.content = content;
    [self showNetworkProgressIndicator:@"评论发表中..."];
    MZL_SVC_ERR_BLOCK blockError = ^(NSError *error) {
        [self onNetworkError];
    };
    [MZLServices addComment:comment forArticle:self.article succBlock:^(NSArray *models) {
        MZLCommentResponse *commentResponse = models[0];
        if (commentResponse.error != MZL_SVC_RESPONSE_CODE_SUCCESS) {
            [self hideProgressIndicator];
            [UIAlertView showAlertMessage:commentResponse.errorMessage];
            return;
        }
        _countOfAddedComment ++;
        [_commentBar resetCommentBar];
        [self loadComments];
    } errorBlock:blockError];
}

- (void)deleteCommentOnIndexPath:(NSIndexPath *)indexPath {
    MZLModelComment *comment = _models[indexPath.row];
    [self deleteModelOnIndexPath:indexPath selector:@selector(removeComment:forArticle:succBlock:errorBlock:) params:@[comment, self.article]];
}

- (void)deleteCommentOnCell:(MZLCommentItemCell *)cell {
    _editingIndexPath = [_tv indexPathForCell:cell];
    [self setEditState];
//    [IBAlertView showAlertWithTitle:@"确认删除这条评论吗？" message:nil dismissTitle:MZL_MSG_CANCLE okTitle:MZL_MSG_OK dismissBlock:^{
//    } okBlock:^{
//        [self deleteCommentOnIndexPath:[_tv indexPathForCell:cell]];
//    }];
}

#pragma mark - protected

- (UIImageView *)noRecordImageView:(UIView *)superView {
    return [self imageViewWithImageNamed:@"NoComment" size:CGSizeMake(24, 24) superView:superView];
}

- (NSArray *)noRecordTexts {
    return @[@"暂无评论"];
}

#pragma mark - protected for load

- (void)_onLoadSuccBlock:(NSArray *)modelsFromSvc {
    [self toggleCommentView];
}

#pragma mark - protected for load more

- (BOOL)_canLoadMore {
    return YES;
}

- (void)_loadMore {
    [self cancelEditState];
    [self invokeLoadMoreService:@selector(commentForArticle:pagingParam:succBlock:errorBlock:) params:@[self.article, [self pagingParamFromModels]]];
}

#pragma mark - protected for delete

- (void)_onDeleteSuccBlock:(NSArray *)modelsFromSvc indexPath:(NSIndexPath *)indexPath {
    _countOfDeletedComment ++;
    [self cancelEditState:NO];
    [self toggleCommentView];
}

- (void)refreshOnDelete {
    [self loadComments];
}

#pragma mark - table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLCommentItemCell *cell = [self._tvComment dequeueReusableCommentItemCell];
    if (! cell.isVisted) {
        [cell updateOnFirstVisit:self];
    }
    
    [cell updateCellWithComment:_models[indexPath.row]];
//    MZLModelComment *comment = _models[indexPath.row];
//    [cell.imgUserHeader loadUserImageFromURL:comment.user.headerImage.fileUrl];
//    cell.lblComment.text = isEmptyString(comment.content) ? @"" : comment.content;
//    cell.lblNickName.text = comment.user? comment.user.nickName : @"匿名用户";
//    cell.btnDelete.visible = [self commentUserIsLoginedUser:comment];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 如果不是点击进入编辑状态，默认为可删
    if (! _editingIndexPath) {
        return UITableViewCellEditingStyleDelete;
    }
    if ([indexPath compare:_editingIndexPath] == NSOrderedSame) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deleteCommentOnIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLModelComment *comment = _models[indexPath.row];
    return [self commentUserIsLoginedUser:comment];
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLCommentItemCell *cell = _prototypeCell;
    
    [cell updateCellWithComment:_models[indexPath.row]];
    
    CGFloat height = [cell.lblComment systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += COMMENT_CELL_HEIGHT_EXCLUDING_CONTENT;
    height = MAX(height, MIN_COMMENT_CELL_HEIGHT);
    
    return height;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return MIN_COMMENT_CELL_HEIGHT;
//}

#pragma mark - keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification {
    [self cancelEditState];
    NSDictionary *info = [notification userInfo];
    //    CGRect beginFrame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _heightOfKeyboard = self.view.frame.size.height - endFrame.origin.y;
    CGRect newCommentViewFrame = _commentBar.frame;
    newCommentViewFrame.origin.y = self.view.frame.size.height - _commentBar.frame.size.height - _heightOfKeyboard ;
    
    // Note: rects are in screen coordinates.
    UIViewAnimationCurve animationCurve = [[ info objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
    if (animationCurve == UIViewAnimationCurveEaseIn) {
        animationOptions |= UIViewAnimationOptionCurveEaseIn;
    }
    else if (animationCurve == UIViewAnimationCurveEaseInOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseInOut;
    }
    else if (animationCurve == UIViewAnimationCurveEaseOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseOut;
    }
    else if (animationCurve == UIViewAnimationCurveLinear) {
        animationOptions |= UIViewAnimationOptionCurveLinear;
    }
    [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
        _commentBar.frame = newCommentViewFrame;
    } completion:nil];

}

#pragma mark - misc

- (BOOL)commentUserIsLoginedUser:(MZLModelComment *)comment {
    return comment.user && [MZLSharedData appUserId] > 0 && comment.user.identifier == [MZLSharedData appUserId];
}

@end
