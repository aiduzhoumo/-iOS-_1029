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
    // Do any additional setup after loading the view.
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
}

- (UIView *)footerSpacingView {
    UIView *view = [super footerSpacingView];
    [view createTopSepView];
    return view;
}

#pragma mark - service

- (void)loadGoods {
    [self loadModels:@selector(locationGoodsService:pagingParam:succBlock:errorBlock:) params:@[self.locationParam, [self pagingParamFromModels]]];
}

#pragma mark - table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLLocationDetailGoodsCell *cell = [tableView dequeueReusableTableViewCell:MZL_LD_GOODS_CELL_REUSE_ID];
    [cell updateWithModel:_models[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLModelGoods *goods = (MZLModelGoods *)(_models[indexPath.row]);
    [self.parentViewController performSegueWithIdentifier:MZL_SEGUE_TOGOODSDETAIL sender:goods.goodsUrl];
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MZL_LD_GOODS_CELL_HEIGHT;
}

@end
