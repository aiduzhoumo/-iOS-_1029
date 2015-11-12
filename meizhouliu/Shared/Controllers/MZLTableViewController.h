//
//  MZLTableViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLBaseViewController.h"
#import "UITableView+MZLAdditions.h"
#import "UITableView+MZLHeaderFooterView.h"

@class MZLPagingSvcParam, MZLModelLocation; // , RKObjectManager;

@interface MZLTableViewController : MZLBaseViewController <UITableViewDataSource, UITableViewDelegate> {
    @protected
    UITableView *_tv;
    BOOL _hasMore; // flag indicating whehter it has more models to load
    BOOL _loading; // flag indicating whether it is in the state of "loading"
    BOOL _loadingMore; // flag indicating whether it is in the state of "loading more"
    NSMutableArray *_models;
    BOOL _isMultiSections; // 标识是否有多个sections
    __weak NSOperation *_loadOp;
    __weak NSOperation *_loadMoreOp;
}

@end

@interface MZLTableViewController (Protected)

- (void)reset;
- (NSInteger)pageFetchCount; // 分页每页记录数
- (void)adjustTableViewInsets;
- (void)adjustTableViewBottomInset:(CGFloat)tvBottom scrollIndicatorBottomInset:(CGFloat)scrollBottomInset;

@end

@interface MZLTableViewController (ProtectedForTableViewCell)

- (id)modelObjectForIndexPath:(NSIndexPath *)indexPath;

@end

@interface MZLTableViewController (ProtectedForArticleItemCell)

- (MZLArticleItemTableViewCell *)articleItemCellAtIndexPath:(NSIndexPath *)indexPath;
- (MZLArticleItemTableViewCell *)articleItemCellAtIndexPath:(NSIndexPath *)indexPath article:(MZLModelArticle *)article;
- (MZLArticleItemTableViewCell *)articleItemCellAtIndexPath:(NSIndexPath *)indexPath article:(MZLModelArticle *)article hideAuthorFlag:(BOOL)hideAuthorFlag;
- (CGFloat)articleItemCellHeight:(NSIndexPath *)indexPath;

@end

@interface MZLTableViewController (ProtectedForLocationItemCell)

- (MZLLocationItemCell *)locationItemCellAtIndexPath:(NSIndexPath *)indexPath;
- (MZLLocationItemCell *)locationItemCellAtIndexPath:(NSIndexPath *)indexPath location:(MZLModelLocation *)location;

- (MZLLocationItemCell *)relatedLocationItemCellAtIndexPath:(NSIndexPath *)indexPath;
- (MZLLocationItemCell *)relatedLocationItemCellAtIndexPath:(NSIndexPath *)indexPath location:(MZLModelLocation *)location;

@end

//@interface MZLTableViewController (ProtectedForNoticeItemCell)
//
//- (MZLNotificationItemTableViewCell *)noticeItemCellAtIndexPath:(NSIndexPath *)indexPath;
//- (MZLNotificationItemTableViewCell *)noticeItemCellAtIndexPath:(NSIndexPath *)indexPath notice:(MZLModelNotice *)notice;
//
//@end

@interface MZLTableViewController (ProtectedForFooterView)

- (CGFloat)footerSpacingViewHeight;
- (UIView *)footerSpacingView;

@end

@interface MZLTableViewController (ProtectedForNoRecordView)

/** return nil to not have no record view */
- (UIView *)noRecordView;
/** 默认为tv的superView */
- (UIView *)noRecordViewSuperView;
- (NSArray *)noRecordTexts;
- (UIImageView *)noRecordImageView:(UIView *)superView;

- (UIImageView *)imageViewWithImageNamed:(NSString *)imageName size:(CGSize)size superView:(UIView *)superView;

@end

@interface MZLTableViewController (ProtectedForLoad)

- (void)invokeService:(SEL)selector params:(NSArray *)parameters;

- (void)loadModels:(SEL)selector params:(NSArray *)parameters;
- (void)loadModels;
- (void)loadModelsWhenViewIsVisible;
/** override point, to actually invoke service to load models */
- (void)_loadModels;

/** override point, map models on returned models */
- (NSMutableArray *)mapModelsOnLoad:(NSArray *)modelsFromSvc;
- (void)_onLoadSuccBlock:(NSArray *)modelsFromSvc;
/** return NO to stop super from further processing */
- (BOOL)_onLoadErrorBlock:(NSError *)error;

@end

// load more 暂时只支持单section
@interface MZLTableViewController (ProtectedForLoadMore)

- (void)invokeLoadMoreService:(SEL)selector params:(NSArray *)parameters;

- (MZLPagingSvcParam *)pagingParamFromModels;

- (BOOL)_canLoadMore;
- (void)_loadMore;
/** override point */
- (void)_onLoadMoreSuccBlock:(NSArray *)mappedModels;
- (NSArray *)mapModelsOnLoadMore:(NSArray *)modelsFromSvc;

@end

// 只支持单section
@interface MZLTableViewController (ProtctedForDelete)

- (void)deleteModelOnIndexPath:(NSIndexPath *)indexPath selector:(SEL)selector params:(NSArray *)parameters ;
/** 如果删除后数据不足一页，重新刷新 */
- (void)refreshOnDelete;
- (void)_onDeleteSuccBlock:(NSArray *)modelsFromSvc indexPath:(NSIndexPath *)indexPath;

@end