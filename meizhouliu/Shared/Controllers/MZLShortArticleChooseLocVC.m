//
//  MZLShortArticleChooseLocVC.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLShortArticleChooseLocVC.h"

#import "UIView+MZLAdditions.h"
#import "MZLShortArticleChooseLocItemCell.h"
#import "MZLSurroundingLocSvcParam.h"
#import "MZLModelSurroundingLocations.h"
#import "MZLLocationInfo.h"
#import "MZLServices.h"
#import "MZLModelShortArticle.h"
#import "MZLShortArticleContentVC.h"
#import "MZLTabBarViewController.h"
#import "NSError+CONetwork.h"
#import "MZLLocResponse.h"

#define MZL_ESTIMATE_HEIGHT 88
#define MZL_SEGUE_TO_SHORTARTICLE_CONTENT @"toNextStep"


@interface MZLShortArticleChooseLocVC () <UITextFieldDelegate> {
    NSTimer *_locationTimer;
}

@property (nonatomic, weak)UIView *vwLocRefresh;
@property (nonatomic, weak)UIView *vwLocError;
@property (nonatomic, weak)UIButton *btnRefresh;
@property (nonatomic, weak)UIButton *btnReLocate;
@property (nonatomic, weak)UILabel *lblError;
@property (nonatomic, weak)UILabel *lblCurrentLoc;

@property (nonatomic, strong) UITableViewCell *prototypeCell;
@property (nonatomic, strong) MZLLocationInfo *curLocation;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MZLShortArticleChooseLocVC

- (void)viewDidLoad {
//    [super viewDidLoad];
    [self initInternal];
    
    // for calculating cell height
    self.prototypeCell  = [_tv dequeueReusableChooseLocItemCell];
    
    [self startLocationService];
    
}

- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
    MZLTabBarViewController *tabBarVC = (MZLTabBarViewController *)self.presentingViewController;
    [tabBarVC showMzlTabBar:NO animatedFlag:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:MZL_SEGUE_TO_SHORTARTICLE_CONTENT]) {
        MZLShortArticleContentVC *vcShortArticle = (MZLShortArticleContentVC *)segue.destinationViewController;
        vcShortArticle.model = sender;
    }
}

- (void)toShortArticleContent:(MZLModelSurroundingLocations *)location {
    [self hideProgressIndicator];
    MZLModelShortArticle *shortArticle = [[MZLModelShortArticle alloc] init];
    shortArticle.location = location;
    [self performSegueWithIdentifier:MZL_SEGUE_TO_SHORTARTICLE_CONTENT sender:shortArticle];
}

#pragma mark - protected for load

- (NSArray *)noRecordTexts {
    if (! isEmptyString(self.lblCurrentLoc.text)) {
        return @[@"找不到这个地方哦，", @"请输入更准确的关键词，比如加入目的地城市试试？"];
    }
    return [super noRecordTexts];
}

- (void)_onLoadSuccBlock:(NSArray *)modelsFromSvc {
    [self toggleTableView];
    [self.btnRefresh.layer removeAllAnimations];
}

- (BOOL)_canLoadMore {
    return YES;
}

- (void)toggleTableView {
    if (_models.count > 0) {
        _tv.visible = YES;
    }else{
        _tv.visible = NO;
    }
}
#pragma mark - service related

- (void)loadSurroundingLocations {
    self.curLocation.city = self.tfLocation.text;
    MZLSurroundingLocSvcParam *svcParam = [MZLSurroundingLocSvcParam instanceWithCurLocation:self.curLocation paging:[self pagingParamFromModels]];
    [self loadModels:@selector(surroundingLocations:succBlock:errorBlock:) params:@[svcParam]];
}

- (void)_loadMore {
    MZLSurroundingLocSvcParam *svcParam = [MZLSurroundingLocSvcParam instanceWithCurLocation:self.curLocation paging:[self pagingParamFromModels]];
    [self invokeLoadMoreService:@selector(surroundingLocations:succBlock:errorBlock:) params:@[svcParam]];
}

#pragma mark - UI

- (void)initInternal {
    UIBarButtonItem  *leftBarButtonItem;
    leftBarButtonItem = [self backBarButtonItemWithImageNamed:@"Short_Article_Close" action:nil];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.tfLocation.layer.cornerRadius = 5;
    self.tfLocation.textColor = colorWithHexString(@"#434343");
    self.tfLocation.delegate = self;
    self.tfLocation.returnKeyType = UIReturnKeySearch;
    [self createLocRefreshView];
    [self createLocTableView];
}

- (void)createLocRefreshView {
    self.vwLocRefresh = [self.view createSubView];
    [self.vwLocRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.vwLocRefresh.superview);
        make.top.mas_equalTo(self.vwLocRefresh.superview).offset(64);
        make.height.equalTo(@32);
    }];
    self.vwLocRefresh.backgroundColor = colorWithHexString(@"#f2f3f5");
    
    UILabel *lblCurrentLoc = [self.vwLocRefresh createSubViewLabel];
    self.lblCurrentLoc = lblCurrentLoc;
    [lblCurrentLoc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vwLocRefresh.mas_left).offset(15);
        make.centerY.equalTo(self.vwLocRefresh.mas_centerY);
        make.right.equalTo(self.vwLocRefresh.mas_right).offset(-30);
    }];
    lblCurrentLoc.font = MZL_FONT(12);
    lblCurrentLoc.textColor = colorWithHexString(@"#939393");
    
    UIButton *btn = [self.vwLocRefresh createSubBtnWithImageNamed:@"Short_Article_Faild_Location" imageSize:CGSizeMake(16, 16)];
    self.btnRefresh = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.vwLocRefresh.mas_right).offset(-15);
        make.centerY.equalTo(self.vwLocRefresh.mas_centerY);
        make.width.equalTo(@16);
        make.height.equalTo(@16);
    }];
    [btn addTarget:self action:@selector(relocation) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createLocTableView {
    _tv = [self.view createSubViewTableView];
    _tv.separatorColor = colorWithHexString(@"d8d8d8");
    _tv.visible = NO;
    _tv.dataSource = self;
    _tv.delegate = self;
    [_tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.vwLocRefresh.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    UITapGestureRecognizer *recognizer = [_tv addTapGestureRecognizer:self action:@selector(dismissKeyboard)];
    recognizer.cancelsTouchesInView = NO;
}

- (void)createLocateErrorView {
    if (self.vwLocError) {
        [self.vwLocError removeFromSuperview];
    }
    self.vwLocError = [self.view createSubView];
    [self.vwLocError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.vwLocError.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [self.vwLocError createSubBtnWithImageNamed:@"Short_Article_Faild_Location" imageSize:CGSizeMake(32, 32)];
    self.btnReLocate = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.vwLocError.center);
    }];
    [btn addTarget:self action:@selector(relocation) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblError = [self.vwLocError createSubViewLabel];
    self.lblError = lblError;
    lblError.text = @"定位失败，请重新定位";
    lblError.font = MZL_FONT(18);
    lblError.textColor = colorWithHexString(@"#b0b0b0");
    [lblError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(btn);
        make.bottom.equalTo(btn.mas_top).offset(-16);
    }];
}

- (void)changeLocationLabelText:(NSString *)addr {
    self.lblCurrentLoc.text = addr;
    // TO DO 刷新列表
}

- (IBAction)close:(id)sender {
    [self.navigationController dismissCurrentViewController];
}
- (IBAction)search:(id)sender {
    [_models removeAllObjects];
    [self dismissKeyboard];
    [self loadSurroundingLocations];
}

#pragma mark - text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self search:nil];
    return YES;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLShortArticleChooseLocItemCell *cell = [tableView dequeueReusableChooseLocItemCell];
    [cell updateOnFirstVisit];
    [cell updateContentWithLocationInfo:_models[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLShortArticleChooseLocItemCell *cell = [tableView dequeueReusableChooseLocItemCell];
    [cell updateContentWithLocationInfo:_models[indexPath.row]];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MZL_ESTIMATE_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLModelSurroundingLocations *location = _models[indexPath.row];
    [self queryAMapLocation:location];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{          
    if ([self.tfLocation isFirstResponder]) {
        [self.tfLocation resignFirstResponder];
    }
}
#pragma mark - location related

- (void)relocation {
    if (self.lblError) {
        self.lblError.text = @"正在定位";
    }
    if (self.btnRefresh) {
         [self rotateWithView:self.btnReLocate];
        self.btnReLocate.userInteractionEnabled = NO;
    }
//    if (!isEmptyString(self.curLocation.city)) {
//        self.tfLocation.text = nil; //when relocation ,need to clear the filter parameter
//    }
    if (![self isLocationServiceRunning]) {
        [self startLocationService];
    }
}

- (void)startLocationService {
    if (! [CLLocationManager locationServicesEnabled]) {
        [self onLocationDisabled];
        return;
    }
    [self stopLocationTimer];
    [self initLocationManager];
    [self rotateWithView:self.btnRefresh];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        // for iOS 8 and above
        if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [[self locationManager] requestWhenInUseAuthorization];
        } else {
            [[self locationManager] startUpdatingLocation];
        }
    } else {
        [self onLocationAuthorizedStatusDetermined];
    }
}

- (void)initLocationManager {
    if (! self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
    }
}

- (void)onLocationDisabled {
    //统一显示定位失败
    [self onLocationError];
}

- (void)onLocationUpdated:(NSString *)addr {
    [self hideProgressIndicator:NO];
    [self changeLocationLabelText:addr];
}

- (void)onLocationError {
//    [self hideProgressIndicator:NO];
    [self.btnRefresh.layer removeAllAnimations];
    [self createLocateErrorView];
    [self.tfLocation setEnabled:NO];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

#pragma mark - AMap service and delegate

- (void)queryAMapLocation:(MZLModelSurroundingLocations *)location {
    [self showNetworkProgressIndicator:@"目的地数据查询中..."];
    [MZLServices aMapLocationQuery:location succBlock:^(NSArray *models) {
        MZLModelSurroundingLocations *temp = models[0];
        location.identifier = temp.identifier;
        [self toShortArticleContent:location];
    } errorBlock:^(NSError *error) {
        if ([error co_responseStatusCode] == MZL_HTTP_RESPONSECODE_NOTEXIST) {
            [self createAMapLocation:location];
        } else {
            [self onNetworkError];
        }
    }];
}

- (void)createAMapLocation:(MZLModelSurroundingLocations *)location {
    [MZLServices aMapLocationCreate:location succBlock:^(NSArray *models) {
        MZLLocResponse *temp = models[0];
        location.identifier = temp.destination.identifier;
        [self toShortArticleContent:location];
    } errorBlock:^(NSError *error) {
        [self onNetworkError];
    }];
}

- (void)searchReGeocode:(CLLocation *)location
{
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    CGFloat latitude = location.coordinate.latitude;
    CGFloat longitude = location.coordinate.longitude;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    regeoRequest.requireExtension = NO;
    AMapSearchAPI *api = [MZLSharedData aMapSearch];
    api.delegate = self;
    [api AMapReGoecodeSearch: regeoRequest];
}

- (void)searchRequest:(id)request didFailWithError:(NSError *)error {
    [self onAMapReGeocodeDone];
    [self onLocationError];
}

- (void)onAMapReGeocodeDone {
    [self stopLocationTimer];
    [MZLSharedData aMapSearch].delegate = nil;
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    [self.btnRefresh.layer removeAllAnimations];
    [self onAMapReGeocodeDone];
    [self onLocationRetrieved:response.regeocode.formattedAddress];
}

#pragma mark - location service and delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    // 当状态为不确定状态时，不开启定位，只有当状态确定时，才开始刷新位置信息
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorized) {
        [self onLocationAuthorizedStatusDetermined];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self stopLocationService];
    CLLocation *location = locations[locations.count - 1];
    [self setLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    [self invokeGeocoder:location];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self stopLocationService];
    [self stopLocationTimer];
    [self onLocationError];
}

- (void)onLocationAuthorizedStatusDetermined {
    // 用户允许location service 或 拒绝
    [self.locationManager startUpdatingLocation];
    _locationTimer = [NSTimer scheduledTimerWithTimeInterval:MZL_DEFAULT_TIMEOUT target:self selector:@selector(onLocationTimerTimeout:) userInfo:nil repeats:NO];
}

- (void)onLocationTimerTimeout:(NSTimer *)timer {
    if (_locationTimer) {
        _locationTimer = nil;
        [self stopAllLocationService];
        [self onLocationError];
    }
}

- (void)stopAllLocationService {
    [self stopLocationService];
    [self stopGeoService];
}

- (void)stopLocationTimer {
    if (_locationTimer) {
        [_locationTimer invalidate];
        _locationTimer = nil;
    }
}

- (void)stopGeoService {
    [MZLSharedData stopGeoService];
}

- (void)stopLocationService {
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}

- (void)invokeGeocoder:(CLLocation *)location {
    [self searchReGeocode:location];
}

- (void)onLocationRetrieved:(NSString *)addr{
    [self onLocationUpdated:addr];
    [self loadSurroundingLocations];
    if (self.vwLocError) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.tfLocation.enabled = YES;
        [self.vwLocError removeFromSuperview];
    }
}

- (void)setLatitude:(CGFloat)latitude longitude:(CGFloat)longitude {
    if (!_curLocation) {
        _curLocation = [[MZLLocationInfo alloc] init];
    }
    _curLocation.latitude = @(latitude);
    _curLocation.longitude = @(longitude);   
}

#pragma mark - helper methods

- (void)rotateWithView:(UIView *)view {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 0.8;
    rotationAnimation.repeatCount = MAXFLOAT;//设置循环次数
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:rotationAnimation forKey:@"Rotation"];
}

- (void)dismissKeyboard {
    if ([_tfLocation isFirstResponder]) {
        [_tfLocation resignFirstResponder];
    }
}

- (BOOL)isLocationServiceRunning {
    // 处于定位或地址解析都认为是地址服务都在运行
    return (self.locationManager.delegate != nil || [MZLSharedData aMapSearch].delegate != nil);
}


@end
