//
//  MZLLocationMapViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//


#import "MZLLocationMapViewController.h"
#import "MZLModelLocationDetail.h"
#import "MZLMapAnnotation.h"
#import "UIViewController+MZLAnnotationView.h"
#import "UIView+MZLAdditions.h"

@interface MZLLocationMapViewController () {
    MZLMapAnnotation *_annotation;
}

@end

@implementation MZLLocationMapViewController

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
    
//    self.lblLocName.text = self.location.name;
//    [self.lblLocName setNumberOfLines:0];
//    self.lblLocName.lineBreakMode =NSLineBreakByWordWrapping;
//    self.lblLocName.textColor = MZL_COLOR_BLACK_555555();
//    
//    self.lblAddress.text = self.location.address;
//    [self.lblAddress setNumberOfLines:0];
//    self.lblAddress.lineBreakMode =NSLineBreakByWordWrapping;
//    self.lblAddress.textColor = MZL_COLOR_BLACK_555555();
//    NSString *address = isEmptyString(self.location.address) ? MZL_MSG_DEFAULT_ADDRESS : self.location.address;
//    self.lblAddress.text = [NSString stringWithFormat:@"地址：%@", address];
//    
//    self.vwLocBg.backgroundColor = colorWithHexString(@"#dcf1ee");
    self.vwLocBg.hidden = YES;
    
    UIView *closeView = [[self.view createSubView] co_insetsParent:UIEdgeInsetsMake(24, COInvalidCons, COInvalidCons, 24) width:36 height:36];
    closeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    closeView.layer.cornerRadius = 3.0;
    [[[closeView createSubViewImageViewWithImageNamed:@"Short_Article_Close"] co_width:24 height:24] co_centerParent];
    [closeView addTapGestureRecognizer:self action:@selector(onCloseMapView:)];
    
    if (! isEmptyString(self.location.address)) {
        UIView *addressView = [[self.view createSubView] co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, 0, 0)];
        addressView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        UILabel *addressLbl = [addressView createSubViewLabelWithFontSize:12 textColor:@"D8D8D8".co_toHexColor];
        addressLbl.text = self.location.address;
        addressLbl.numberOfLines = 2;
        [addressLbl co_offsetParent:16.0];
    }
    //Configure the mapView
    self.mapLocation.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self.navigationController.navigationBar setHidden:YES];
    if ([self isCoordinateValid:self.location]) {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = self.location.latitude;
        coordinate.longitude = self.location.longitude;
        MKCoordinateSpan coordinateSpan = coordinateSpanFromLocation(self.location);
        MKCoordinateRegion regin = {coordinate,coordinateSpan};
        [self.mapLocation setRegion:regin animated:YES];
        _annotation = [[MZLMapAnnotation alloc] initWithLocation:coordinate title:self.location.name subTitle:nil];
        _annotation.displayName = self.location.address;
    } else {
        [UIAlertView showAlertMessage:@"该目的地暂无定位信息"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_annotation) {
        [self.mapLocation addAnnotation:_annotation];
    }
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

- (NSString *)statsID {
    return @"目的地地图页";
}

- (BOOL)isCoordinateValid:(MZLModelLocationDetail *)location {
    return isCoordinateValid(CLLocationCoordinate2DMake(location.latitude, location.longitude));
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString * const identifier = @"PinView";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (pinView) {
        pinView.annotation = annotation;
    } else {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    pinView.animatesDrop = YES;
    pinView.rightCalloutAccessoryView = [self navCalloutViewForAnnotation:annotation];
    pinView.canShowCallout = YES;
    return pinView;
}

- (void)onCloseMapView:(UITapGestureRecognizer *)tap {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
