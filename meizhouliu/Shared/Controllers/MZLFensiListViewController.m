//
//  MZLFensiListViewController.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/7.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLFensiListViewController.h"
#import "MZLFeriendListCell.h"
#import "MZLServices.h"
#import "MZLModelAuthor.h"
#import "MZLModelUser.h"
#import "MZLAuthorDetailViewController.h"

@interface MZLFensiListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *fensiListTableView;

@end

@implementation MZLFensiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fensiListTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tv = self.fensiListTableView;
    _tv.dataSource = self;
    _tv.delegate = self;
    _tv.backgroundColor = MZL_BG_COLOR();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self adjustTableViewInsets];
    [self loadModels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)statsID {
    return @"好友粉丝列表";
}

- (BOOL)_canLoadMore {
    return YES;
}

- (void)_loadModels {
    //    MZLPagingSvcParam *param = [self pagingParamFromModels];
    [self loadModels:@selector(fensiListForUser:WithPagingParam:succBlock:errorBlock:) params:@[self.user,[self pagingParamFromModels]]];
}

- (void)_loadMore {
    //    MZLPagingSvcParam *param = [self pagingParamFromModels];
    [self invokeLoadMoreService:@selector(fensiListForUser:WithPagingParam:succBlock:errorBlock:) params:@[self.user,[self pagingParamFromModels]]];
}

- (void)mzl_onWillBecomeTabVisibleController {
    [self loadModels];
}

#pragma mark - table data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MZLLog(@"%@",_models);
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MZLFeriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feriendList"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MZLFeriendListCell" owner:nil options:nil] lastObject];
    }
    [cell initWithFeriendListInfo:_models[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLAuthorDetailViewController *vcAuthor = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:NSStringFromClass([MZLAuthorDetailViewController class])];
    MZLModelUser *user = _models[indexPath.row];
    MZLModelAuthor *author = [user toAuthor];
    vcAuthor.authorParam = author;
    [self.navigationController pushViewController:vcAuthor animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
