//
//  MZLPersonalizedShortArticleVC.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLPersonalizedShortArticleVC.h"
#import <IBMessageCenter.h>
#import "MZLBaseViewController+CityList.h"
#import "MZLFilterParam.h"
#import "MZLServices.h"
//#import "MZLShortArticleCell.h"
#import "MZLShortArticleCellStyle2.h"

@interface MZLPersonalizedShortArticleVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tvPerShortArticle;

@end

@implementation MZLPersonalizedShortArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - protected override

- (NSArray *)noRecordTextsWithFilters {
    return @[@"对不起啊，", @"没有找到你个性化需求的玩法，", @"请重新选择。"];
}

- (void)_mzl_homeInternalInit {
    self.title = @"玩法";
    _tv = self.tvPerShortArticle;
    _tv.backgroundColor = @"EFEFF4".co_toHexColor;
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tv removeUnnecessarySeparators];
    [self addCityListDropdownBarButtonItem];
}

#pragma mark - protected for load

- (void)_loadModelsWithoutFilters {
    NSArray *params = [self serviceParamsFromFilter:nil paging:nil];
    if (! params) {
        return;
    }
    [self invokeService:@selector(personalizeShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
}

- (void)_loadModelsWithFilters:(MZLFilterParam *)filter {
    NSArray *params = [self serviceParamsFromFilter:filter paging:nil];
    if (! params) {
        return;
    }
    [self invokeService:@selector(personalizeShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
}

#pragma mark - protected for load more

- (BOOL)_canLoadMore {
    return YES;
}

- (void)_loadMoreWithoutFilters:(MZLPagingSvcParam *)pagingParam {
    NSArray *params = [self serviceParamsFromFilter:nil paging:pagingParam];
    if (! params) {
        return;
    }
    [self invokeLoadMoreService:@selector(personalizeShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
}

- (void)_loadMoreWithFilters:(MZLFilterParam *)filter {
    NSArray *params = [self serviceParamsFromFilter:filter paging:nil];
    if (! params) {
        return;
    }
    [self invokeLoadMoreService:@selector(personalizeShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
}

#pragma mark - table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLShortArticleCellStyle2 *cell = [MZLShortArticleCellStyle2 cellWithTableview:tableView model:_models[indexPath.row]];
    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MZLShortArticleCellStyle2 heightForTableView:tableView withModel:_models[indexPath.row]];
}

#pragma mark - statsID

- (NSString *)statsID {
    return @"短文玩法列表";
}

#pragma mark - misc

- (NSArray *)serviceParamsFromFilter:(MZLFilterParam *)filter paging:(MZLPagingSvcParam *)paging {
    if ([self checkAndShowCityListOnLocationNotDetermined]) {
        return nil;
    }
    MZLFilterParam *paramFilter = filter;
    if (! paramFilter) {
        paramFilter = [[MZLFilterParam alloc] init];
    }
    paramFilter.destinationName = [MZLSharedData selectedCity];
    MZLPagingSvcParam *paramPaging = paging;
    if (! paramPaging) {
        paramPaging = [self pagingParamFromModels];
    }
    return @[paramFilter, paramPaging];
}

@end
