//
//  MZLHotGoodsVC.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15/4/20.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLHotGoodsVC.h"
#import "MZLHotGoodsCell.h"
#import "MZLServices.h"
#import "MZLModelGoods.h"
#import "MZLGoodsDetailViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>

@interface MZLHotGoodsVC ()<AMapSearchDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UITableView *tvHotGoods;

@end

@implementation MZLHotGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tv = self.tvHotGoods;
    _tv.backgroundColor = MZL_BG_COLOR();
    [self loadModels];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self adjustTableViewBottomInset:MZL_TAB_BAR_HEIGHT scrollIndicatorBottomInset:MZL_TAB_BAR_HEIGHT];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:MZL_SEGUE_TOGOODSDETAIL]) {
        MZLGoodsDetailViewController *vcGoodsDetail = segue.destinationViewController;
        vcGoodsDetail.goodsUrl = (NSString *)sender;
    }
}


- (NSString *)statsID {
    return @"爆款商品";
}

#pragma mark - override

- (BOOL)_canLoadMore {
    return NO;
}

- (void)_loadModels {
    [self reset];
    
    [self geo];
}

- (void)geo {
    
    
    AMapGeocodeSearchRequest *regeoRequest = [[AMapGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_Geocode;
    regeoRequest.address = [MZLSharedData selectedCity];
    
    AMapSearchAPI *api = [MZLSharedData aMapSearch];
    api.delegate = self;
    [api AMapGeocodeSearch:regeoRequest];

}

#pragma mark - amapDelegate 
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    AMapGeocode *geocode = response.geocodes[0];
    CGFloat longitude =  geocode.location.longitude;
    CGFloat latitude = geocode.location.latitude;
    
    [MZLServices hotGoodsServiceWithLon:longitude lat:latitude succBlock:^(NSDictionary *models) {
        [self getModels:models];
    } errorBlock:^(NSError *error) {
        [self onNetworkError];
    }];
}

- (void)getModels:(NSDictionary *)responsDic {
    
    if([[responsDic objectForKey:@"IsSuccess"] intValue] == 1){
        NSArray *goodsArr = [[responsDic objectForKey:@"Res"] objectForKey:@"list"];
        NSMutableArray *modelArr = [NSMutableArray array];
        for (NSDictionary *dict in goodsArr) {
            MZLModelGoods *goods = [[MZLModelGoods alloc] initWithDic:dict];
            [modelArr addObject:goods];
        }
        _models = [NSMutableArray arrayWithArray:modelArr];
        [_tv reloadData];
    }
    
    [self hideProgressIndicator];
}

- (void)_loadMore {
//    [self invokeLoadMoreService:@selector(hotGoodsService:succBlock:errorBlock:) params:@[[self pagingParamFromModels]]];
}

- (void)mzl_onWillBecomeTabVisibleController {
    [self loadModels];
}

#pragma mark - table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLHotGoodsCell *cell= [tableView dequeueReusableCellWithIdentifier:@"MZLHotGoodsCell"];
    [cell updateWithGoods:_models[indexPath.row]];
    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MZLHotGoodsCell cellHeigth];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLModelGoods *goods = (MZLModelGoods *)(_models[indexPath.row]);
    NSString *nstring = goods.goodsUrl;
    NSArray *array = [nstring componentsSeparatedByString:@"$"];
    NSString *url = [array objectAtIndex:0];
    NSString *token = [MZLSharedData appDuZhouMoToken];
    NSString *newGoodsUrl = [NSString stringWithFormat:@"%@%@",url,token];
    MZLLog(@"%@",newGoodsUrl);
    [self performSegueWithIdentifier:MZL_SEGUE_TOGOODSDETAIL sender:newGoodsUrl];
}
- (void)dealloc {
    MZLLog(@"热门商品页面消失");
}

@end
