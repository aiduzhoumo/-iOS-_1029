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
#import "MJRefresh.h"
#import "MZLPagingSvcParam.h"

@interface MZLLocationGoodsViewController ()
{
   NSMutableArray *_models;
}
@property (weak, nonatomic) IBOutlet UITableView *goodsTable;

@property (nonatomic, assign) NSInteger pageCount;

//记录当前是第几页
@property (nonatomic, assign) NSInteger i;

@property (nonatomic, assign) BOOL canLoadMore;
@end

@implementation MZLLocationGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _models = [[NSMutableArray alloc] init];
    _i = 1;
    _tv = self.goodsTable;
    _tv.separatorColor = colorWithHexString(@"#D8D8D8");
    [_tv removeUnnecessarySeparators];
//    [self adjustTableViewBottomInset:MZL_TAB_BAR_HEIGHT scrollIndicatorBottomInset:MZL_TAB_BAR_HEIGHT];
    UIEdgeInsets insets = _tv.contentInset;
    _tv.contentInset = UIEdgeInsetsMake(MZL_TOP_BAR_HEIGHT, insets.left, MZL_TAB_BAR_HEIGHT, insets.right);
    _tv.scrollIndicatorInsets = _tv.contentInset;
    [self loadGoods];
    // Do any additional setup after loading the view.
    
//    NSLog(@"%ld",_models.count);
//    [self setUpRefresh:_tv];
    
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
//    NSLog(@"%ld",pageSvc.pageIndex);
   [MZLServices locationGoodsService:self.locationParam pagingParam:pageSvc succBlock:nil errorBlock:nil];
    //停止加载
    [_tv footerEndRefreshing];
    }
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

- (BOOL)_canLoadMore {
    return YES;
}

- (void)_loadMore {
    [self invokeLoadMoreService:@selector(locationGoodsService:pagingParam:succBlock:errorBlock:) params:@[self.locationParam, [self pagingParamFromModels]]];
//    MZLLog(@"加载更多");
}

- (UIView *)footerSpacingView {
    UIView *view = [super footerSpacingView];
    [view createTopSepView];
    return view;
}

#pragma mark - service

- (void)loadGoods {
    [self showNetworkProgressIndicator];
//    [self loadModels:@selector(locationGoodsService:pagingParam:succBlock:errorBlock:) params:@[self.locationParam, [self pagingParamFromModels]]];
    MZLPagingSvcParam *pageSvc = [[MZLPagingSvcParam alloc] init];
    pageSvc.pageIndex = 1;
    [MZLServices locationGoodsService:self.locationParam pagingParam:pageSvc succBlock:nil errorBlock:nil];
//    [self hideProgressIndicator];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getModels:) name:@"goodsModel" object:nil];
}

- (void)getModels:(NSNotification *)notif {
    NSDictionary *responsDic = (NSDictionary *)notif.object;
    
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
        
//        MZLLog(@"%ld",_models.count);
        if (_models.count > 0) {
             [self setUpRefresh:_tv];
        }
       
    }else if([[responsDic objectForKey:@"IsSuccess"] intValue] == 0){
        [_tv removeUnnecessarySeparators];
        [self noRecordView];
    }
//    MZLLog(@"_model = %@",_models);
    
    [self hideProgressIndicator];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLLocationDetailGoodsCell *cell = [tableView dequeueReusableTableViewCell:MZL_LD_GOODS_CELL_REUSE_ID];
    [cell updateWithModel:_models[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLModelGoods *goods = (MZLModelGoods *)(_models[indexPath.row]);
    
    NSString *nstring = goods.goodsUrl;
    NSArray *array = [nstring componentsSeparatedByString:@"$"];
    NSString *url = [array objectAtIndex:0];
    NSString *token = [MZLSharedData appDuZhouMoToken];
    NSString *newGoodsUrl = [NSString stringWithFormat:@"%@%@",url,token];

//    MZLLog(@"newGoodsUrl == %@",newGoodsUrl);
    
    [self.parentViewController performSegueWithIdentifier:MZL_SEGUE_TOGOODSDETAIL sender:newGoodsUrl];
}

#pragma mark - table view data source

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _models.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MZLLocationDetailGoodsCell *cell = [tableView dequeueReusableTableViewCell:MZL_LD_GOODS_CELL_REUSE_ID];
//    [cell updateWithModel:_models[indexPath.row]];
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    MZLModelGoods *goods = (MZLModelGoods *)(_models[indexPath.row]);
//    [self.parentViewController performSegueWithIdentifier:MZL_SEGUE_TOGOODSDETAIL sender:goods.goodsUrl];
//}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MZL_LD_GOODS_CELL_HEIGHT;
}

- (void)dealloc {
//    MZLLog(@"页面销毁，通知也要移除");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
