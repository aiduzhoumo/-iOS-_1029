//
//  MZLLocationGoodsViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-19.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLLocationGoodsViewController.h"
#import "MZLLocationDetailGoodsCell.h"
#import "MZLModelGoods.h"
#import "MZLServices.h"
#import "UIView+MZLAdditions.h"

@interface MZLLocationGoodsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *goodsTable;

@end

@implementation MZLLocationGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tv = self.goodsTable;
    _tv.separatorColor = colorWithHexString(@"#D8D8D8");
    [_tv removeUnnecessarySeparators];
//    [self adjustTableViewBottomInset:MZL_TAB_BAR_HEIGHT scrollIndicatorBottomInset:MZL_TAB_BAR_HEIGHT];
    UIEdgeInsets insets = _tv.contentInset;
    _tv.contentInset = UIEdgeInsetsMake(MZL_TOP_BAR_HEIGHT, insets.left, MZL_TAB_BAR_HEIGHT, insets.right);
    _tv.scrollIndicatorInsets = _tv.contentInset;
    [self loadGoods];
<<<<<<< HEAD
    
}

- (void)setUpRefresh:(UITableView *)tableview {

    [tableview addFooterWithTarget:self action:@selector(footterRefreshingWithTable)];
}

- (void)footterRefreshingWithTable {
    _i ++;
    if (_i > _pageCount) {
        _tv.footerRefreshingText = @"没有更多数据了";
        [_tv footerEndRefreshing];
    }else {
    MZLPagingSvcParam *pageSvc = [[MZLPagingSvcParam alloc] init];
    pageSvc.pageIndex = _i;

    [MZLServices locationGoodsService:self.locationParam pagingParam:pageSvc succBlock:^(NSDictionary *models) {
        [self getModels:models];
    } errorBlock:^(NSError *error) {
        [self onNetworkError];
    }];
    //停止加载
    [_tv footerEndRefreshing];
    }
=======
    // Do any additional setup after loading the view.
>>>>>>> parent of d1afe84... Merge branch 'mzl_FJbranch'
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.backgroundColor = MZL_BG_COLOR();
    _tv.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)statsID {
    return @"目的地详情商品页";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - override

<<<<<<< HEAD
//- (BOOL)_canLoadMore {
//    return YES;
//}
//
//- (void)_loadMore {
//    [self invokeLoadMoreService:@selector(locationGoodsService:pagingParam:succBlock:errorBlock:) params:@[self.locationParam, [self pagingParamFromModels]]];
//    MZLLog(@"加载更多");
//}
//
//- (UIView *)footerSpacingView {
//    UIView *view = [super footerSpacingView];
//    [view createTopSepView];
//    return view;
//}
=======
- (BOOL)_canLoadMore {
    return YES;
}

- (void)_loadMore {
    [self invokeLoadMoreService:@selector(locationGoodsService:pagingParam:succBlock:errorBlock:) params:@[self.locationParam, [self pagingParamFromModels]]];
}

- (UIView *)footerSpacingView {
    UIView *view = [super footerSpacingView];
    [view createTopSepView];
    return view;
}
>>>>>>> parent of d1afe84... Merge branch 'mzl_FJbranch'

#pragma mark - service

- (void)loadGoods {
<<<<<<< HEAD
    [self showNetworkProgressIndicator];

    MZLPagingSvcParam *pageSvc = [[MZLPagingSvcParam alloc] init];
    pageSvc.pageIndex = 1;
    [MZLServices locationGoodsService:self.locationParam pagingParam:pageSvc succBlock:^(NSDictionary *models) {
        [self getModels:models];
    } errorBlock:^(NSError *error) {
        [self onNetworkError];
    }];
}

- (void)getModels:(NSDictionary *)responsDic {
    if([[responsDic objectForKey:@"IsSuccess"] intValue] == 1){
        NSString *count = [[responsDic objectForKey:@"Res"] objectForKey:@"pageCount"];
        self.pageCount = [count intValue];
        NSArray *goodsArr = [[responsDic objectForKey:@"Res"] objectForKey:@"list"];
        if (goodsArr.count == 0) {
            [_tv removeUnnecessarySeparators];
            [self noRecordView];
        }
        NSMutableArray *modelArr = [NSMutableArray array];
        for (NSDictionary *dict in goodsArr) {
            MZLModelGoods *goods = [[MZLModelGoods alloc] initWithDic:dict];
            [modelArr addObject:goods];
        }
        [_models addObjectsFromArray:modelArr];
        [_tv reloadData];
        
        if (_models.count > 0) {
            [self setUpRefresh:_tv];
        }
        
    }else if([[responsDic objectForKey:@"IsSuccess"] intValue] == 0){
        [_tv removeUnnecessarySeparators];
        [self noRecordView];
    }
    
    [self hideProgressIndicator];
}

#pragma mark - tableview dataSource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
=======
    [self loadModels:@selector(locationGoodsService:pagingParam:succBlock:errorBlock:) params:@[self.locationParam, [self pagingParamFromModels]]];
}

#pragma mark - table view data source
>>>>>>> parent of d1afe84... Merge branch 'mzl_FJbranch'

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLLocationDetailGoodsCell *cell = [tableView dequeueReusableTableViewCell:MZL_LD_GOODS_CELL_REUSE_ID];
    [cell updateWithModel:_models[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLModelGoods *goods = (MZLModelGoods *)(_models[indexPath.row]);
    [self.parentViewController performSegueWithIdentifier:MZL_SEGUE_TOGOODSDETAIL sender:goods.goodsUrl];
}

<<<<<<< HEAD

=======
>>>>>>> parent of d1afe84... Merge branch 'mzl_FJbranch'
#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MZL_LD_GOODS_CELL_HEIGHT;
}

<<<<<<< HEAD
- (void)dealloc {
    MZLLog(@"目的商品页面销毁，通知也要移除");
}

=======
>>>>>>> parent of d1afe84... Merge branch 'mzl_FJbranch'
@end
