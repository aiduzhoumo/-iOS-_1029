//
//  MZLCityListViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLCityListViewController.h"
#import "MZLLocationInfo.h"
#import "pinyin.h"
#import "COKeyValuePair.h"
#import "MZLArticleListViewController.h"
#import "NSArray+COAdditions.h"
#import "UITableView+MZLAdditions.h"
#import "MobClick.h"
#import "UIViewController+MZLModelPresentation.h"
#import "NSString+COPinYin4ObjcAddition.h"
#import "COStringWithPinYin.h"
#import "MZLSharedData.h"
//#import "UIView+MZLAdditions.h"

//#define INDEX_CACHED_CITY @"*"
//#define INDEX_CUR_CITY @"#"
#define INDEX_CUR_CITY @"*"
#define INDEX_GPS_LOC @"#"
#define INDEX_HOT_CITIES @"$"
#define HEIGHT_CITY_CELL 40.0

#define KEY_CUR_CITY @"当前所在"

@interface MZLCityListSearchDelegate : NSObject <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) MZLCityListViewController *ownerController;
@property (nonatomic, strong) NSArray *filteredCityList;

@end

@implementation MZLCityListSearchDelegate

- (NSArray *)allLocationList {
    return [MZLSharedData allLocations];
}

- (NSString *)locationFromIndexPath:(NSIndexPath *)indexPath {
    COStringWithPinYin *pinyinStr = self.filteredCityList[indexPath.row];
    return pinyinStr.str;
}

#pragma mark - search display delegate

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [tableView removeUnnecessarySeparators];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSString *searchAllPinyinStr = [searchString co_toPinYin];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.pinyin BEGINSWITH[c] %@ OR SELF.pinyinCapital BEGINSWITH[c] %@", searchAllPinyinStr, searchAllPinyinStr];
    self.filteredCityList = [[self allLocationList] filteredArrayUsingPredicate:pred];
    return YES;
}

#pragma mark - table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.ownerController.tvCityList dequeueReusableCellWithIdentifier:@"cityCell"];
    cell.textLabel.text = [self locationFromIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredCityList.count;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HEIGHT_CITY_CELL;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * selectedCity = [self locationFromIndexPath:indexPath];
    [MZLSharedData setSelectedCity:selectedCity];
    [self.ownerController.searchDisplayController setActive:NO animated:YES];
    [self.ownerController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end


@interface MZLCityListViewController () {
    NSMutableArray *_cities;
    NSDictionary *_indexedCities;
    NSMutableArray *_sectionIndexes;
    UISearchDisplayController *_searchController;
    MZLCityListSearchDelegate *_searchDelegate;
}

@end

@implementation MZLCityListViewController

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
    // Do any additional setup after loading the view.
    
    [self initWithStatusBar:self.bgStatusBar navBar:self.navBar];
    self.navigationItem.leftBarButtonItem = [self backBarButtonItemWithImageNamed:@"BackArrow" action:@selector(actionForBackBtn)];
    [self initSearch];
//    self.tvCityList.separatorColor = colorWithHexString(@"#e5e5e5");
    [self.tvCityList removeUnnecessarySeparators];
    [self initCityList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:@"城市列表页"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"城市列表页"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - data init

- (void)initSearch {
    _searchDelegate = [[MZLCityListSearchDelegate alloc] init];
    _searchDelegate.ownerController = self;
    
//    self.searchBar.delegate = _searchDelegate;
    
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    _searchController.delegate = _searchDelegate;
    
    _searchController.searchResultsDelegate = _searchDelegate;
    _searchController.searchResultsDataSource = _searchDelegate;
}

- (void)initCityList {
    _cities = [[NSMutableArray alloc] init];
    _sectionIndexes = [NSMutableArray array];
    // 当前所在
    NSString *cachedCity = [MZLSharedData cachedCity];
    if (cachedCity) {
        NSDictionary *dictLastVisitedCity = @{KEY_CUR_CITY: @[cachedCity]};
        [_cities addObject:dictLastVisitedCity];
        [_sectionIndexes addObject:INDEX_CUR_CITY];
    }
    // GPS定位
    NSString *currentCity = [MZLSharedData currentCity];
    if (currentCity) {
        NSDictionary *dictCurCity = @{@"GPS定位": @[currentCity]};
        [_cities addObject:dictCurCity];
        [_sectionIndexes addObject:INDEX_GPS_LOC];
    }
    // 热门城市
    NSDictionary *dictHotCities = @{@"热门城市": @[@"杭州市", @"上海市", @"南京市", @"苏州市", @"宁波市", @"无锡市"]};
    [_cities addObject:dictHotCities];
    [_sectionIndexes addObject:INDEX_HOT_CITIES];
    // 索引城市列表
    NSArray *cityList = [MZLSharedData allCities];
    NSArray *indexedCityList = [cityList map:^id(id object) {
        COKeyValuePair *pair = [[COKeyValuePair alloc] init];
        NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([object characterAtIndex:0])]uppercaseString];
        NSString *firstCityString = [object substringToIndex:1];
        if ([firstCityString isEqual:@"长"]) {
            pair.key = @"C";
        }else{
            pair.key = singlePinyinLetter;
        }
        pair.value = object;
        return pair;
    }];
    
    _indexedCities = [indexedCityList groupBy:@"key" filterOnValue:^id(id value) {
        return [value valueForKey:@"value"];
    }];
    // 索引
    NSArray *tempIndexes = [_indexedCities allKeys];
    tempIndexes = [tempIndexes sort];
    [_sectionIndexes addObjectsFromArray:tempIndexes];
}

#pragma mark - table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
    cell.textLabel.text = [self getCityFromIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.indentationLevel = 1;
    cell.separatorInset = UIEdgeInsetsMake(0, 30, 0, 0);
    CGFloat fontSize = 14;
    cell.textLabel.font = MZL_FONT(fontSize);
    if ([self isCurCitySectionFromIndexPath:indexPath]) {
        cell.textLabel.font = MZL_BOLD_FONT(fontSize);
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self isCurCitySectionFromSection:section]) {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HEIGHT_CITY_CELL / 2)];
        footer.backgroundColor = colorWithHexString(@"#dbdbdb");
        return footer;
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 当前所在，GPS定位，热门城市，城市列表
    return [_sectionIndexes count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self getCityListForSection:section] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sectionIndexes;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index; {
    return [_sectionIndexes indexOfObject:title];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section <= (_cities.count - 1)) {
        return [self keyFromCities:section];
    } else {
        return [_sectionIndexes objectAtIndex:section];
    }
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HEIGHT_CITY_CELL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self isCurCitySectionFromSection:section]) {
        return HEIGHT_CITY_CELL / 2 - 5;
    }
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * selectedCity = [self getCityFromIndexPath:indexPath];
    [MZLSharedData setSelectedCity:selectedCity];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - misc

- (void)actionForBackBtn {
    // 必须选中城市
    if (isEmptyString([MZLSharedData selectedCity])) {
        [UIAlertView showAlertMessage:@"请选择你的所在城市！"];
        return;
    }
    [self backToParent];
}

- (NSArray *)getCityListForSection:(NSInteger)section {
    if (section <= ([_cities count] - 1)) {
        NSDictionary *dict = [_cities objectAtIndex:section];
        return [[dict allValues] objectAtIndex:0]; // we only have one key-value
        // return [cityListWithinSection count];
    } else {
        NSString *sectionIndex = [_sectionIndexes objectAtIndex:section];
        return [_indexedCities objectForKey:sectionIndex];
        // return [[_indexedCities objectForKey:sectionIndex] count];
    }
}

- (NSString *)getCityFromIndexPath:(NSIndexPath *)indexPath {
    NSArray *cityList = [self getCityListForSection:indexPath.section];
    NSString *city = (NSString *)[cityList objectAtIndex:indexPath.row];
    return city;
}

- (BOOL)isCurCitySectionFromIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    return [self isCurCitySectionFromSection:section];
}

- (BOOL)isCurCitySectionFromSection:(NSInteger)section {
    NSString *key = [self keyFromCities:section];
    return [key isEqualToString:KEY_CUR_CITY];
}

- (NSString *)keyFromCities:(NSInteger)section {
    if (section <= _cities.count - 1) {
        NSDictionary *dict = [_cities objectAtIndex:section];
        return [[dict allKeys] objectAtIndex:0]; // we only have one key-value
    }
    return nil;
}

@end
