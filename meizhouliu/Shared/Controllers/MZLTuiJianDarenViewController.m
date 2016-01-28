//
//  MZLTuiJianDarenViewController.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/12/31.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLTuiJianDarenViewController.h"
#import "MZLTuiJianDarenCell.h"
#import "MZLServices.h"
#import "MZLTuiJianDarenCell.h"
#import "MZLAuthorDetailViewController.h"
#import "MZLModelAuthor.h"
#import "MZLModelUser.h"

@interface MZLTuiJianDarenViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tuijianTab;

@end

@implementation MZLTuiJianDarenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐达人";

    
    [self adjustTableViewInsets];
    
    self.tuijianTab.tableHeaderView = nil;
    self.tuijianTab.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tv = self.tuijianTab;
    _tv.backgroundColor = MZL_BG_COLOR();
    
    _tv.dataSource = self;
    _tv.delegate = self;
    
    
    [self loadModels];
}

- (NSString *)statsID {
    return @"推荐达人";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self adjustTableViewInsets];
//    [self loadModels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)_loadModels {
    MZLPagingSvcParam *param = [self pagingParamFromModels];
    [self loadModels:@selector(tuijianDarenWithPagingParam:SuccBlock:errorBlock:) params:@[param]];
    
}

- (void)_loadMore {
    MZLPagingSvcParam *param = [self pagingParamFromModels];
    [self invokeLoadMoreService:@selector(tuijianDarenWithPagingParam:SuccBlock:errorBlock:) params:@[param]];
}

- (BOOL)_canLoadMore {
    return YES;
}

- (NSInteger)pageFetchCount {
    return 3;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld",_models.count);
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLTuiJianDarenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tuijiandaren"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MZLTuiJianDarenCell" owner:nil options:nil] lastObject];
    }
    [cell initWithInfo:_models[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLAuthorDetailViewController *vcAuthor = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:NSStringFromClass([MZLAuthorDetailViewController class])];
    MZLModelUser *user = _models[indexPath.row];
    MZLModelAuthor *author = [user toAuthor];
    vcAuthor.authorParam = author;
    [self.navigationController pushViewController:vcAuthor animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
