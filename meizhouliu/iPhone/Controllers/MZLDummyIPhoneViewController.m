//
//  MZLDummyIPhoneViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-23.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLDummyIPhoneViewController.h"
#import "MZLServices.h"
#import <objc/runtime.h>

// for short articles
#import "MZLPagingSvcParam.h"
#import "MZLShortArticleCell.h"
#import "MZLShortArticleCellStyle2.h"
#import "MZLModelSurroundingLocations.h"
#import "MZLModelLocationExt.h"
#import "MZLModelAuthor.h"

@interface MZLDummyIPhoneViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_models;
}


@property (weak, nonatomic) IBOutlet UITableView *tv;

@end

@implementation MZLDummyIPhoneViewController

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
    
    self.tv.dataSource = self;
    self.tv.delegate = self;
    self.tv.allowsSelection = NO;
    
    [self initData];
//    [self initServiceData];
    self.tv.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    [self initFakeShortArticles];
    [self.tv reloadData];
}

- (void)initServiceData {
    [self loadShortArticles];
}

#pragma mark - test for table data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - test for table data delegate

- (UITableViewCell *)defaultTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"reuseId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self shortArticleCellWithTableView:tableView indexPath:indexPath];
    return [self shortArticleCellStyle2WithTableView:tableView indexPath:indexPath];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self heightForShortArticleCellWithTableView:tableView indexPath:indexPath];
    CGFloat height = [self heightForShortArticleCellStyle2WithTableView:tableView indexPath:indexPath];
    return height;
}

#pragma mark - test for short articles

#define SHORT_ARTICLE_TYPE MZLShortArticleCellTypeDefault

- (void)initFakeShortArticles {
    MZLModelShortArticle *model = [[MZLModelShortArticle alloc] init];
    model.tags = @"情侣 朋友";
    MZLModelSurroundingLocations *location = [[MZLModelSurroundingLocations alloc] init];
    location.locationName = @"杭州西湖";
    MZLModelLocationExt *locExt = [[MZLModelLocationExt alloc] init];
    locExt.address = @"这是一个很长的地址";
    location.locationExt = locExt;
    model.location = location;
    model.publishedAt = [[NSDate date] timeIntervalSince1970];
    model.content = @"这是一个很长的内容这是一个很长的内容这是一个很长的内容这是一个很长的内容这是一个很长的内容这是一个很长的内容的内容这是一个很长的内容这是一个很长的内容的内容这是一个很长的内容这是一个很长的内容这是一个很长的内容这是一个很长的内容这是一个很长的内容这是一个很长的内容的内容这是一个很长的内容这是一个很长的内容的内容";
    model.consumption = 30;
    model.commentsCount = 10;
    model.upsCount = 11;
    _models = [NSMutableArray array];
    
    //    NSArray *images = @[image1, image2];
    NSMutableArray *images = [NSMutableArray array];
    NSInteger base = 68400;
    for (int i = 1; i <= 15; i++) {
        MZLModelImage *image = [[MZLModelImage alloc] init];
        NSInteger photoId = base + i;
        image.fileUrl = [NSString stringWithFormat:@"http://meizhouliu-photo.b0.upaiyun.com/uploads/photo/file/%@/image.jpg", @(photoId)];
//        image.fileUrl = @"http://meizhouliu-photo.b0.upaiyun.com/uploads/photo/file/5514/1353294149444_U7116P704DT20120913114942.jpg";
        [images addObject:image];
    }
    model.photos = images;
    
    MZLModelUser *user = [[MZLModelUser alloc] init];
    user.nickName = @"北北";
    MZLModelImage *header = [[MZLModelImage alloc] init];
    header.fileUrl = @"http://meizhouliu-photo.b0.upaiyun.com/uploads/photo/file/5514/1353294149444_U7116P704DT20120913114942.jpg";
    user.headerImage = header;
    model.author = user;
    
    [_models addObject:model];
}

- (void)loadShortArticles {
    MZLPagingSvcParam *param = [MZLPagingSvcParam pagingSvcParamWithPageIndex:1 fetchCount:10];
    MZLModelAuthor *user = [[MZLModelAuthor alloc] init];
    user.identifier = 10;
    [MZLServices authorShortArticleListWithAuthor:user pagingParam:param succBlock:^(NSArray *models) {
//        _models = [NSMutableArray arrayWithArray:[models subarrayWithRange:NSMakeRange(0, 1)]];
        _models = [NSMutableArray arrayWithArray:models];
        [self.tv reloadData];
    } errorBlock:^(NSError *error) {
        COLogObject(error);
    }];
//    [MZLServices authorShortArticleListWithPagingParam:param succBlock:^(NSArray *models) {
//        _models = [NSMutableArray arrayWithArray:models];
//        [self.tv reloadData];
//    } errorBlock:^(NSError *error) {
//        COLogObject(error);
//    }];
}

- (MZLShortArticleCell *)shortArticleCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    MZLShortArticleCell * cell = [MZLShortArticleCell cellWithTableview:tableView type:SHORT_ARTICLE_TYPE model:_models[indexPath.row]];
    return cell;
}

- (MZLShortArticleCellStyle2 *)shortArticleCellStyle2WithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    MZLShortArticleCellStyle2 * cell = [MZLShortArticleCellStyle2 cellWithTableview:tableView model:_models[indexPath.row]];
    return cell;
}

- (CGFloat)heightForShortArticleCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    CGFloat height = [MZLShortArticleCell heightForTableView:tableView withType:SHORT_ARTICLE_TYPE withModel:_models[indexPath.row]];
    return height;
}

- (CGFloat)heightForShortArticleCellStyle2WithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    CGFloat height = [MZLShortArticleCellStyle2 heightForTableView:tableView withModel:_models[indexPath.row]];
    return height;
}

@end
