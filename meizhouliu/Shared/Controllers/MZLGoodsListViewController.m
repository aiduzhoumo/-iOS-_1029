//
//  MZLGoodsListViewController.m
//  mzl_mobile_ios
//
//  Created by race on 14/12/5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLGoodsListViewController.h"
#import "MZLGoodsItemCell.h"
#import "MZLModelArticle.h"
#import "MZLServices.h"
#import "MZLModelGoodsDetail.h"
#import "MZLGoodsDetailViewController.h"

#define SEGUE_TODETAIL @"toGoodsDetail"
#define GOODS_CELL_HEIGHT_WITHOUT_DESC 121;
#define GOODS_CELL_HEIGHT_NO_DESC 88;
@interface MZLGoodsListViewController () {
    MZLModelArticle *_article;
    MZLGoodsItemCell *_prototypeCell;
}

@end

@implementation MZLGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tv = self.tvGoods;
    // for calculating cell height
    _prototypeCell  = [_tv dequeueReusableGoodsItemCell];
    self.title = @"相关商品";
    _article = self.article;
    self.view.backgroundColor = MZL_BG_COLOR();
    _tv.backgroundColor = MZL_BG_COLOR();
    _tv.separatorColor = colorWithHexString(@"#e5e5e5");
    [self loadGoods];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:MZL_SEGUE_TOGOODSDETAIL]) {
        MZLGoodsDetailViewController *vcGoodsDetail = (MZLGoodsDetailViewController *)segue.destinationViewController;
        vcGoodsDetail.goodsUrl = sender;
    }
    
}


#pragma mark - service related

- (void)loadGoods {
    [self loadModels:@selector(goodsInArticle:succBlock:errorBlock:) params:@[self.article]];
}

- (BOOL)_canLoadMore {
    return NO;
}

#pragma mark - table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLGoodsItemCell *cell = [_tv dequeueReusableGoodsItemCell];
    if (! cell.isVisted) {
        [cell updateOnFirstVisit];
    }
    [cell updateContentFromGoods:_models[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [_prototypeCell updateContentFromGoods:_models[indexPath.row]];
    [_prototypeCell.lblDescription sizeToFit];
    if (_prototypeCell.lblDescription.visible == NO) {
        return GOODS_CELL_HEIGHT_NO_DESC;
    }
    return _prototypeCell.lblDescription.frame.size.height + GOODS_CELL_HEIGHT_WITHOUT_DESC;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - table view delegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLModelGoodsDetail *goods = (MZLModelGoodsDetail *)(_models[indexPath.row]);
    NSString *goodsUrl = [self goodsUrlWithArticle:_article.identifier goodsId:goods.goodsInfo.identifier];
    [self performSegueWithIdentifier:MZL_SEGUE_TOGOODSDETAIL sender:goodsUrl];
}

- (NSString *)goodsUrlWithArticle:(NSInteger)articleId goodsId:(NSInteger)goodsId {
    NSString *_goodsUrl = [NSString stringWithFormat:@"http://www.meizhouliu.com/articles/%@/products/%@", @(articleId), @(goodsId)];
    return _goodsUrl;
}


@end
