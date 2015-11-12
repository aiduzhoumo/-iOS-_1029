//
//  MZLLocationInforViewController.m
//  mzl_mobile_ios
//
//  Created by race on 14/10/21.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLocationInforViewController.h"

#import "MZLModelLocationDetail.h"
#import "MZLModelImage.h"
#import "MZLCarouselView.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLModelLocationExt.h"
#import "MZLModelTagType.h"
#import "MZLServices.h"
#import "MZLImageGalleryNavigationController.h"
#import "MZLImageGalleryViewController.h"
#import "MZLLocationDetailViewController.h"
#import "UIScrollView+MZLParallax.h"
#import "UIScrollView+MZLAddition.h"
#import "MZLPagingSvcParam.h"
#import "UIView+MZLAdditions.h"
#import "MZLMapAnnotation.h"
#import "UIViewController+MZLAnnotationView.h"
#import "UIScrollView+COAddition.h"
#import "MZLServices.h"
#import "MZLSharedData.h"
#import "MZLFilterParam.h"
#import "NSString+MZLImageURL.h"

static const CGFloat KCarouseHeight = 300.0;
#define CONTENT_BOTTOM_MARGIN 20.0
#define KEY_MAP_FRAME @"KEY_MAP_FRAME"
#define KEY_MAP_VISIBLERECT @"KEY_MAP_VISIBLERECT"

#define KEY_CONTENTSIZE @"contentSize"

@interface MZLLocationInforViewController () {
    NSArray *_locationPhotos;
    NSInteger _locationPhotoCount;
    MZLCarouselView *_carouselView;
    UIScrollView *_contentScroll;
    UILabel *_lblDesp;
    UIView *_contentScrollContent;
    
    UIView *_despView;
    UIView *_despViewArrow;
    WeView *_mapContainer;
    __weak UIImageView *_mapTopShadow;
    __weak UIImageView *_mapBottomShadow;
    UIView *_mapPlaceHolder;
    MKMapView *_map;
    
    UIView *_toLocArtTipView;
    NSInteger _toLocArtFlag;
    
    UIView *_contentTop;
    UIView *_contentBottom;
    
    BOOL _ignoreScroll;
}

@end

@implementation MZLLocationInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ignoreScroll = YES;
    [self initUI];
    // 由于parentViewController(LocationDetail)不隐藏indicator, 而controller本身也没有service调用，故需要在这隐藏
    [self hideProgressIndicator:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    _ignoreScroll = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_contentScroll removeObserver:self forKeyPath:KEY_CONTENTSIZE];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UI related

- (void)initUI {
    self.view.backgroundColor = MZL_BG_COLOR();
    [self initMapView];
    [self initContentView];
    //这里保证_contentScroll的contentSize的高度不小于view的高度 使在内容长度不够的情况下也能执行上拉操作
     _contentScroll.contentSize = _contentScroll.contentSize.height > self.view.height ? _contentScroll.contentSize : self.view.size;
}

- (void)initMapView {
    if (! [self isCoordinateValid:self.locationDetail]) {
        return;
    }
    
    MKMapView *map = [[MKMapView alloc] initWithFrame:self.view.frame];
    map.delegate = self;
    [self.view addSubview:map];
    
    _map = map;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.locationDetail.latitude;
    coordinate.longitude = self.locationDetail.longitude;
    MKCoordinateSpan coordinateSpan = coordinateSpanFromLocation(self.locationDetail);
    MKCoordinateRegion regin = {coordinate, coordinateSpan};
    [map setRegion:regin animated:NO];
    MZLMapAnnotation *annotation = [[MZLMapAnnotation alloc] initWithLocation:coordinate title:self.locationDetail.name subTitle:nil];
    annotation.displayName = self.locationDetail.address;
    [map addAnnotation:annotation];
    
    // map address
    if (! isEmptyString(self.locationDetail.address)) {
        WeView *addressView = [[WeView alloc] init];
        addressView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
        UILabel *addressLbl = [[UILabel alloc] init];
        addressLbl.text = self.locationDetail.address;
        addressLbl.font = MZL_FONT(12.0);
        addressLbl.textColor = colorWithHexString(@"#e5e5e5");
        addressLbl.textAlignment = NSTextAlignmentLeft;
        addressLbl.numberOfLines = 2;
        
        CGFloat hMargin = 15.0;
        CGFloat addressLblHeight = [addressLbl sizeThatFits:CGSizeMake(self.view.width - 2 * hMargin, 0)].height;
        [addressLbl setMinDesiredHeight:addressLblHeight];
        
        [[[[addressView addSubviewWithCustomLayout:addressLbl] setHMargin:hMargin] setVMargin:7] setHAlign:H_ALIGN_LEFT];
        
        [self.view addSubview:addressView];
        CGFloat height = [addressView sizeThatFits:CGSizeMake(self.view.width, 0.0)].height;
        [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(addressView.superview).offset(MZL_TOP_BAR_HEIGHT);
            make.bottom.mas_equalTo(addressView.superview);
            make.left.right.mas_equalTo(addressView.superview);
            make.height.mas_equalTo(height);
        }];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // fix iOS7下contentView被莫名重置为(0, 0)的bug
    if ([keyPath isEqualToString:KEY_CONTENTSIZE]) {
        if (_contentScroll.contentSize.width == 0 && _contentScroll.contentSize.height == 0) {
            NSValue *oldSizeValue = [change objectForKey:NSKeyValueChangeOldKey];
            CGSize oldSize = [oldSizeValue CGSizeValue];
            if (oldSize.width > 0 && oldSize.height > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _contentScroll.contentSize = oldSize;
                });
            }
        }
    }
}

#define KEY_CONTENT_TOP_HEIGHT @"KEY_CONTENT_TOP_HEIGHT"

- (void)initContentView {
    _contentScroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [_contentScroll addObserver:self forKeyPath:KEY_CONTENTSIZE options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];

    [self.view addSubview:_contentScroll];
    _contentScroll.delegate = self;
    UIEdgeInsets inset = UIEdgeInsetsMake(MZL_TOP_BAR_HEIGHT, 0, MZL_TAB_BAR_HEIGHT, 0);
    [_contentScroll mzl_setInsetsForContentAndIndicator:inset];
    
    UIView *content = [_contentScroll createSubView];
    UIView *contentLastSubView;
    
    void(^ topConsMaker)(UIView *, UIView *, MASConstraintMaker *) = ^(UIView *sibling, UIView *superView, MASConstraintMaker *maker){
        if (sibling) {
            maker.top.mas_equalTo(sibling.mas_bottom);
        } else {
            maker.top.mas_equalTo(superView);
        }
    };
    UIView *top = [content createSubView];
    _contentTop = top;
    UIView *topLastSubview;
    top.backgroundColor = MZL_BG_COLOR();
    CGFloat topHeight = 0;
    if (_locationDetail.photos.count > 0) {
        [self initCarouselView:top];
        topLastSubview = _carouselView;
        topHeight += KCarouseHeight;
    }
    [self initLocationNameView];
    // 目的地标签
    if (_locationDetail.tagTypes.count > 0) {
        UIView *tagView = [self tagsView];
        [top addSubview:tagView];
        CGFloat tagViewHeight = [tagView sizeThatFits:CGSizeMake(self.view.width, 0.0)].height;
        topHeight += tagViewHeight;
        [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(tagView.superview);
            topConsMaker(_carouselView, top, make);
            make.height.mas_equalTo(tagViewHeight);
        }];
        topLastSubview = tagView;
    }
    // 目的地描述
    if (! isEmptyString(_locationDetail.locationExt.introduction)) {
        UIView *despView = [self descriptionView];
        _despView = despView;
        [top addSubview:despView];
        CGFloat despViewHeight = [despView sizeThatFits:CGSizeMake(self.view.width, 0.0)].height;
        topHeight += despViewHeight;
        [despView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(despView.superview);
            topConsMaker(topLastSubview, top, make);
            make.height.mas_equalTo(despViewHeight);
        }];
        topLastSubview = despView;
    }
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top.superview);
        make.left.right.mas_equalTo(top.superview);
        if (topLastSubview) {
            make.bottom.mas_equalTo(topLastSubview.mas_bottom);
        } else {
            make.height.mas_equalTo(0);
        }
    }];
    [top setProperty:KEY_CONTENT_TOP_HEIGHT value:@(topHeight)];
    contentLastSubView = top;

    // 目的地地图
    if ([self isCoordinateValid:self.locationDetail]) {
        UIView *mapPlaceHolder = [self mapPlaceHolderView];
        _mapPlaceHolder = mapPlaceHolder;
        [content addSubview:mapPlaceHolder];
        CGFloat mapHeight = 190;
        [mapPlaceHolder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(mapPlaceHolder.superview);
            make.top.mas_equalTo(mapPlaceHolder.superview).offset(topHeight);
            make.height.mas_equalTo(mapHeight);
        }];
        contentLastSubView = mapPlaceHolder;
    }
    
    UIView *bottom = [content createSubView];
    _contentBottom = bottom;
    _contentBottom.backgroundColor = MZL_BG_COLOR();
    UIView *bottomSpacing = [bottom createSubView];
    [bottomSpacing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(bottomSpacing.superview);
        make.height.mas_equalTo(60);
    }];
    // 目的地地点
    if (! isEmptyString(_locationDetail.address)) {
        UIView *addressView = [self addressView];
        [bottom addSubview:addressView];
        CGFloat addressViewHeight = [addressView sizeThatFits:CGSizeMake(self.view.width, 0.0)].height;
        [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.right.mas_equalTo(addressView.superview);
            make.height.mas_equalTo(addressViewHeight);
        }];
        [bottomSpacing mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(addressView.mas_bottom);
        }];
    } else {
        [bottomSpacing mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bottomSpacing.superview);
        }];
    }
    [_contentBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_contentBottom.superview);
        make.top.mas_equalTo(contentLastSubView.mas_bottom);
        make.bottom.mas_equalTo(bottomSpacing.mas_bottom);
    }];
    contentLastSubView = _contentBottom;
    
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(content.superview);
        make.width.mas_equalTo(self.view.width);
        make.bottom.mas_equalTo(contentLastSubView.mas_bottom);
    }];
    [content setNeedsLayout];
    [content layoutIfNeeded];
    
    _contentScrollContent = content;
    [self setContentScrollContentSize:CGSizeMake(self.view.width, content.height)];

}

- (void)setContentScrollContentSize:(CGSize)size {
    size.width = self.view.width;
    CGFloat height = self.view.height - _contentScroll.contentInset.top - MZL_TAB_BAR_HEIGHT;
    if (size.height < height) {
        size.height = height;
    }
    _contentScroll.contentSize = size;
    // 设置一个比较大的高度避免看到底层的map
    CGFloat tipViewHeight = 40 + CO_SCREEN_HEIGHT;
    if (! _toLocArtTipView) {
        _toLocArtTipView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height, size.width, tipViewHeight)];
        _toLocArtTipView.backgroundColor = MZL_BG_COLOR();
        [_contentScroll addSubview:_toLocArtTipView];
        UILabel *lbl = [_toLocArtTipView createSubViewLabelWithFontSize:12 textColor:colorWithHexString(@"#B0B0B0")];
        lbl.text = @"上拉查看玩法";
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lbl.superview);
            make.centerX.mas_equalTo(lbl.superview);
        }];
    } else {
        _toLocArtTipView.frame = CGRectMake(0, size.height, self.view.width, tipViewHeight);
    }
}

- (void)initCarouselView:(UIView *)superView {
    NSArray *locationCoverUrls = [_locationDetail.photos map:^id(id object) {
        MZLModelImage *image = (MZLModelImage *)object;
        return [image.fileUrl imageUrl_640_600];
    }];
    _carouselView = [MZLCarouselView instanceWithImageUrls:locationCoverUrls defaultImageName:MZL_DEFAULT_IMAGE_LOCATION_COVER frame:CGRectMake(0, 0, self.view.width, KCarouseHeight)];
    [_carouselView addTapGestureRecognizer:self action:@selector(onLocationCoverImageClicked)];
    [_carouselView hidePageControl];
    _carouselView.clipsToBounds = YES;
    [superView addSubview:_carouselView];
    [_carouselView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_equalTo(_carouselView.superview);
        make.height.mas_equalTo(KCarouseHeight);
    }];
}

- (void)initLocationNameView {
    if (_carouselView && ! isEmptyString(self.locationDetail.name)) {
        CGFloat height = 160;
        CGFloat leftBottomMargin = 16.0;
        CGFloat lblPreferredWidth = CO_SCREEN_WIDTH - leftBottomMargin - 80;
        UIView *bgView = [_contentTop createSubView];
        bgView.userInteractionEnabled = NO;
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
            make.left.right.and.bottom.mas_equalTo(_carouselView);
        }];
        UIImageView *bgImage = [bgView createSubViewImageViewWithImageNamed:@"loc_info_shadow"];
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.bottom.mas_equalTo(bgView);
        }];
        
        UIView *bgContentView = [bgView createSubView];
        UILabel *despLbl = [bgContentView createSubViewLabel];
        despLbl.font =  MZL_ITALIC_FONT(14.0);
        despLbl.textColor = [UIColor whiteColor];
        despLbl.numberOfLines = 2;
        despLbl.preferredMaxLayoutWidth = lblPreferredWidth;
        [despLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(despLbl.superview);
            make.left.mas_equalTo(despLbl.superview).offset(2);
            make.width.mas_equalTo(lblPreferredWidth);
        }];
        __weak MZLLocationInforViewController *weakself = self;
        MZLFilterParam *filterParam = [MZLFilterParam filterParamsFromFilterTypes:[MZLSharedData selectedFilterOptions]];
        [MZLServices locationPersonalizeTagDespServiceWithLocation:self.locationDetail filter:filterParam succBlock:^(NSArray *models) {
            weakself.locationDetail.tagDesps = models;
            despLbl.text = [weakself.locationDetail tagDesp];
        } errorBlock:^(NSError *error) {
        }];
        UILabel *nameLbl = [bgContentView createSubViewLabel];
        nameLbl.font = MZL_BOLD_FONT(24.0);
        nameLbl.textColor = [UIColor whiteColor];
        nameLbl.text = self.locationDetail.name;
        nameLbl.numberOfLines = 2;
        nameLbl.preferredMaxLayoutWidth = lblPreferredWidth;
//        NSInteger nameLength = self.locationDetail.name.length;
//        if (nameLength <= 16) {
//            nameLbl.font = MZL_FONT(36);
//        } else {
//            nameLbl.font = MZL_FONT(24);
//        }
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(despLbl.mas_top).offset(-8);
            make.left.mas_equalTo(nameLbl.superview);
            make.width.mas_equalTo(lblPreferredWidth);
        }];
        
        [bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgContentView.superview).offset(leftBottomMargin);
            make.right.mas_equalTo(bgContentView.superview).offset(-12);
            make.bottom.mas_equalTo(bgContentView.superview).offset(-leftBottomMargin);
            make.top.mas_equalTo(nameLbl.mas_top);
        }];
    }
}

#define HEIGHT_DESP_VIEW_HIDDEN 67
#define IS_DISPLAY_ALL_DESP @"IS_DISPLAY_ALL_DESP"
#define KEY_HEIGHT_DESP_VIEW_FULL @"KEY_HEIGHT_DESP_VIEW_FULL"

- (UIView *)descriptionView {
    WeView *view = [[WeView alloc] init];
    
    CGFloat maxWidth = self.view.width - 15.0 * 2;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_locationDetail.locationExt.introduction];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_locationDetail.locationExt.introduction length])];
    
    NSMutableArray *subviews = [NSMutableArray array];
    
    UILabel *lblDesp = [[UILabel alloc] init];
    _lblDesp = lblDesp;
    [subviews addObject:lblDesp];
    [lblDesp setHasCellHAlign:YES];
    lblDesp.font = MZL_FONT(14.0);
    lblDesp.textColor = colorWithHexString(@"#383838");
    lblDesp.attributedText = attributedString;
    lblDesp.maxDesiredWidth = maxWidth;
    lblDesp.numberOfLines = 0;
    CGSize lblDespSize = [lblDesp sizeThatFits:CGSizeMake(maxWidth, 0.0)];
    //    [lblDesp setMinDesiredHeight:lblDespSize.height];
    if (lblDespSize.height > HEIGHT_DESP_VIEW_HIDDEN) { // 缩略形式显示
        [lblDesp setFixedDesiredHeight:HEIGHT_DESP_VIEW_HIDDEN];
        [lblDesp setProperty:KEY_HEIGHT_DESP_VIEW_FULL value:@(lblDespSize.height)];
        [lblDesp setProperty:IS_DISPLAY_ALL_DESP value:@(NO)];
        WeView *arrowContainer = [[WeView alloc] init];
        [subviews addObject:arrowContainer];
        UIImageView *arrow = [[UIImageView alloc] init];
        _despViewArrow = arrow;
        arrow.image = [UIImage imageNamed:@"loc_info_arrow"];
        [arrow setFixedDesiredSize:CGSizeMake(16, 16)];
        [[[arrowContainer addSubviewWithCustomLayout:arrow]
          setTopMargin:4]
         setHAlign:H_ALIGN_RIGHT];
        [arrowContainer setHStretches];
        [view addTapGestureRecognizer:self action:@selector(toggleDespView:)];
    } else {
        [lblDesp setFixedDesiredHeight:lblDespSize.height];
        [lblDesp setProperty:IS_DISPLAY_ALL_DESP value:@(YES)];
    }
    
    [[[[view addSubviewsWithVerticalLayout:subviews]
       setHMargin:15.0]
      setHAlign:H_ALIGN_LEFT]
     setBottomMargin:10];
    
    return view;
}

- (void)toggleDespView:(UIGestureRecognizer *)tap {
    BOOL toDisplayAll = ! [[_lblDesp getProperty:IS_DISPLAY_ALL_DESP] boolValue];
    [_lblDesp setProperty:IS_DISPLAY_ALL_DESP value:@(toDisplayAll)];
    CGFloat height = HEIGHT_DESP_VIEW_HIDDEN;
    CGAffineTransform arrowToTransform = CGAffineTransformIdentity;
    if (toDisplayAll) {
        arrowToTransform = CGAffineTransformMakeRotation(M_PI);
        height = [[_lblDesp getProperty:KEY_HEIGHT_DESP_VIEW_FULL] floatValue];
    }
    [_lblDesp setFixedDesiredHeight:height];
    CGFloat despViewHeight = [_despView sizeThatFits:CGSizeMake(self.view.width, 0.0)].height;
    [_despView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(despViewHeight);
    }];
    [_contentTop setNeedsLayout];
    [_contentTop layoutIfNeeded];
    [_mapPlaceHolder mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mapPlaceHolder.superview).offset(_contentTop.height);
    }];
    
    [_contentScrollContent setNeedsLayout];
    [_contentScrollContent layoutIfNeeded];
    CGSize scrollContentSize = CGSizeMake(self.view.width, _contentScrollContent.height);
    [self setContentScrollContentSize:scrollContentSize];
    [UIView animateWithDuration:0.3 animations:^{
        _despViewArrow.transform = arrowToTransform;
    }];
}

- (UIView *)tagsView {
    NSMutableArray *tagsView = [NSMutableArray array];
    for (MZLModelTagType *tagType in _locationDetail.tagTypes) {
        UIView *vwTags = [self tagsView:tagType.identifier tagType:tagType.name tags:tagType.tags];
        [vwTags setHStretches];
        [tagsView addObject:vwTags];
    }
    WeView *view = [[WeView alloc] init];
    [[[view addSubviewsWithVerticalLayout:tagsView] setTopMargin:15.0] setHMargin:15.0];
    return view;
}

- (UIView *)tagsView:(NSInteger)type tagType:(NSString *)tagType tags:(NSString *)tags {
    WeView *view = [[WeView alloc] init];
    
    WeView *leftView = [[WeView alloc] init];
    [leftView setHasCellVAlign:YES];
    [leftView setHasCellHAlign:YES];
    UIImageView *image = [[UIImageView alloc] init];
    [image setFixedDesiredSize:CGSizeMake(16.0, 16.0)];
    if (type == MZL_TAG_TYPE_PEOPLE) {
        image.image = [UIImage imageNamed:@"LD_Tag_People"];
    } else {
        image.image = [UIImage imageNamed:@"LD_Tag_Feature"];
    }
//    UILabel *lblTagType = [[UILabel alloc] init];
//    lblTagType.textColor = colorWithHexString(@"#96c5c1");
//    lblTagType.font = MZL_BOLD_FONT(12.0);
//    lblTagType.text = tagType;
//    [lblTagType setFixedDesiredWidth:24.0];
    [[[leftView addSubviewsWithHorizontalLayout:@[image]]
      setVAlign:V_ALIGN_TOP] setTopMargin:6];
    
    NSArray *tagsArr = generateTags(tags);
    NSMutableArray *tagsView = [NSMutableArray array];
    NSMutableArray *tagsRow = [NSMutableArray array];
    NSInteger index = 0;
    
    for (NSString *tag in tagsArr) {
        index ++;
        UILabel *lblTag = [[UILabel alloc] init];
        [lblTag setFixedDesiredWidth:48];
        lblTag.text = tag;
        lblTag.textColor = colorWithHexString(@"#B0B0B0");
        lblTag.font = MZL_FONT(12.0);
        
        if (index < (CO_SCREEN_WIDTH > MZL_BASE_SCREEN_WIDTH ? 5:4) ) {
           [tagsRow addObjectsFromArray:@[lblTag,[self tagFixedSpaceView]]];
        }else{
            WeView *vwTagsRow = [[WeView alloc] init];
            [tagsRow addObjectsFromArray:@[lblTag]];
            [[vwTagsRow addSubviewsWithHorizontalLayout:tagsRow] setTopMargin:6];
            [tagsView addObject:vwTagsRow];
            [tagsRow removeAllObjects];
            index = 0;
        }
    }
    
    if (tagsRow.count > 0) {
        WeView *vwTagsRow = [[WeView alloc] init];
        [[vwTagsRow addSubviewsWithHorizontalLayout:tagsRow] setTopMargin:6];
        [tagsView addObject:vwTagsRow];
        
    }
    WeView *rightView = [[WeView alloc] init];
    [[rightView addSubviewsWithVerticalLayout:tagsView]
     setHAlign:H_ALIGN_LEFT];
    
    [[[[[view addSubviewsWithHorizontalLayout:@[leftView, rightView]]
         setHAlign:H_ALIGN_LEFT]
        setVAlign:V_ALIGN_TOP]
       setHSpacing:23.0]
     setBottomMargin:12.0];
    return view;
}

- (UIView *)tagFixedSpaceView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 13.0,0.0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)mapPlaceHolderView {
    UIView *mapPlaceHolder = [[UIView alloc] init];
    mapPlaceHolder.backgroundColor = [UIColor clearColor];
    
    CGFloat height = 3;
    UIImageView *topShadow = [mapPlaceHolder createSubViewImageViewWithImageNamed:@"LD_Map_TopShadow"];
    _mapTopShadow = topShadow;
    [topShadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.top.and.left.right.mas_equalTo(topShadow.superview);
    }];
    UIImageView *bottomShadow = [mapPlaceHolder createSubViewImageViewWithImageNamed:@"LD_Map_BottomShadow"];
    _mapBottomShadow = bottomShadow;
    [bottomShadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.bottom.and.left.right.mas_equalTo(bottomShadow.superview);
    }];
    [mapPlaceHolder addTapGestureRecognizer:self action:@selector(onMapToFullScreen:)];
    return mapPlaceHolder;
}

- (WeView *)addressView {
    WeView *addressView = [[WeView alloc] init];
    //    addressView.backgroundColor = MZL_BG_COLOR();
    UILabel *addressTitle = [[UILabel alloc] init];
    addressTitle.text = @"地址";
    addressTitle.font = MZL_BOLD_FONT(15);
    addressTitle.textColor = colorWithHexString(@"#383838");
    
    UILabel *addressDetail = [[UILabel alloc] init];
    addressDetail.numberOfLines = 2;
    addressDetail.text = self.locationDetail.address;
    addressDetail.font = MZL_FONT(12);
    addressDetail.textColor = colorWithHexString(@"#383838");
    
    CGFloat hMargin = 15.0;
    CGFloat detailHeight = [addressDetail sizeThatFits:CGSizeMake(self.view.width - 2 * hMargin, 0)].height;
    [addressDetail setMinDesiredHeight:detailHeight];
    
    [[[[[[addressView addSubviewsWithVerticalLayout:@[addressTitle, addressDetail]]
        setVSpacing:5]
       setHMargin:15]
      setVMargin:15]
     setHAlign:H_ALIGN_LEFT]
     setVAlign:V_ALIGN_TOP];
    
    return addressView;
}


#pragma mark - helper methods

- (BOOL)isCoordinateValid:(MZLModelLocationDetail *)location {
    return isCoordinateValid(CLLocationCoordinate2DMake(location.latitude, location.longitude));
}

/**
 *  切换map的全屏显示
 *
 *  @param flag - YES, 全屏显示; NO, 非全屏显示
 */
- (void)toggleMapView:(BOOL)mapFullScreenFlag {
    CGFloat topOffset = 0;
    CGFloat bottomOffset = 0;
    UIBarButtonItem *leftBarButtonItem;
    MZLLocationDetailViewController *locationDetailVC = (MZLLocationDetailViewController *)self.parentViewController;

    if (mapFullScreenFlag) {
        _mapTopShadow.hidden = YES;
        _mapBottomShadow.hidden = YES;
        topOffset = _contentTop.height;
        bottomOffset = _contentBottom.height + MZL_TAB_BAR_HEIGHT;
        leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onMapBackToNormal:)];
    } else {
        _contentScroll.hidden = NO;
        [self toggleMapAnnationHighlighted:NO];
        leftBarButtonItem = [self.parentViewController backBarButtonItemWithImageNamed:@"BackArrow" action:nil];
    }
    [_contentTop mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentTop.superview).offset(-topOffset);
    }];
    [_contentBottom mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mapPlaceHolder.mas_bottom).offset(bottomOffset);
    }];
    self.parentViewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    [UIView animateWithDuration:0.3 animations:^{
        if (mapFullScreenFlag) {
            [_map setProperty:KEY_MAP_FRAME value:[NSValue valueWithCGRect:_map.frame]];
            MKMapRect visibleMapRect = [_map visibleMapRect];
            CGRect visibleRect = CGRectMake(visibleMapRect.origin.x, visibleMapRect.origin.y, visibleMapRect.size.width, visibleMapRect.size.height);
            [_map setProperty:KEY_MAP_VISIBLERECT value:[NSValue valueWithCGRect:visibleRect]];
            _map.frame = CGRectMake(0, 0, _map.width, _map.height);
        } else {
            NSValue *frameValue = [_map getProperty:KEY_MAP_FRAME];
            _map.frame = [frameValue CGRectValue];
            CGRect visibleRect = [[_map getProperty:KEY_MAP_VISIBLERECT] CGRectValue];
            MKMapRect visibleMapRect = MKMapRectMake(visibleRect.origin.x, visibleRect.origin.y, visibleRect.size.width, visibleRect.size.height);
            [_map setVisibleMapRect:visibleMapRect];
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (mapFullScreenFlag) {
            _contentScroll.hidden = YES;
            [self toggleMapAnnationHighlighted:YES];
            [locationDetailVC showLocationDetailTabBar:! mapFullScreenFlag];
        } else {
            _mapTopShadow.hidden = NO;
            _mapBottomShadow.hidden = NO;
        }
    }];
}

- (void)toggleMapAnnationHighlighted:(BOOL)flag {
    id<MKAnnotation> annotation = _map.annotations[0];
    if (flag) {
        [_map selectAnnotation:annotation animated:YES];
    } else {
        [_map deselectAnnotation:annotation animated:YES];
    }
}

- (void)onMapBackToNormal:(id)sender {
    MZLLocationDetailViewController *locationDetailVC = (MZLLocationDetailViewController *)self.parentViewController;
    __weak MZLLocationInforViewController *weakSelf = self;
    [locationDetailVC showLocationDetailTabBar:YES completion:^{
        [weakSelf toggleMapView:NO];
    }];
}

- (void)onMapToFullScreen:(UITapGestureRecognizer *)tap {
    [self toggleMapView:YES];
}

#pragma mark - services 

- (void)locationPhotosService {
    [self showNetworkProgressIndicator];
    MZLPagingSvcParam *param = [[MZLPagingSvcParam alloc] init];
    param.fetchCount = MZL_IMAGE_GALLERY_SVC_FETCH_SIZE;
    param.pageIndex = 1;
    [MZLServices locationPhotosService:self.locationDetail pagingParam:param succBlock:^(NSArray *models) {
        [self hideProgressIndicator];
        NSDictionary *dict = [models getProperty:MZL_SVC_RESPONSE_HEADERS];
        _locationPhotoCount = [dict[@"X-Total"] integerValue];
        _locationPhotos = [models map:^id(id object) {
            return [object fileUrl];
        }];
        [self toImageGallery:nil];
    } errorBlock:^(NSError *error) {
        [self hideProgressIndicator];
        [UIAlertView alertOnNetworkError];
    }];
}

- (void)toImageGallery:(id)sender {
    MZLImageGalleryNavigationController *navController = [[MZLImageGalleryNavigationController alloc] init];
    MZLImageGalleryViewController *vcImageGallery = [[MZLImageGalleryViewController alloc] init];
//    vcImageGallery.locationAllPhotos = _locationPhotos;
    vcImageGallery.location = self.locationDetail;
    vcImageGallery.totalPhotoCount = _locationPhotoCount;
    [vcImageGallery addPhotos:_locationPhotos];
    [navController pushViewController:vcImageGallery animated:NO];
    [self presentViewController:navController animated:YES completion:nil];
}


- (void)onLocationCoverImageClicked {
    if (_locationPhotos) {
        [self toImageGallery:nil];
    } else {
        [self locationPhotosService];
    }
}


#pragma mark - scroll delegate

- (void)parallaxScroll:(UIScrollView *)scrollView {
    if (! _carouselView) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    // 偏移量
    CGFloat deviation = offsetY + MZL_TOP_BAR_HEIGHT;
    if (offsetY <= -1 * MZL_TOP_BAR_HEIGHT) { // 上滑拉伸效果
        CGFloat newOffset = deviation;
        CGFloat newHeight = KCarouseHeight - newOffset;
        [_carouselView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_carouselView.superview).offset(newOffset);
            make.height.mas_equalTo(newHeight);
        }];
    } else if (offsetY <= KCarouseHeight - MZL_TOP_BAR_HEIGHT) {
        CGFloat parallaxFactor = 2.0;
        int deviationDelta = (int)(deviation / parallaxFactor);
        CGFloat newOffset = deviation - deviationDelta;
        CGFloat newHeight = KCarouseHeight - deviationDelta;
        [_carouselView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_carouselView.superview).offset(newOffset);
            make.height.mas_equalTo(newHeight);
        }];
    }
}

- (void)parallaxMap:(UIScrollView *)scrollView {
    CGPoint mapOriginInView = [self.view convertPoint:_mapPlaceHolder.frame.origin fromView:_mapPlaceHolder.superview];
    CGFloat topVisibleY = MZL_TOP_BAR_HEIGHT;
    CGFloat bottomVisibleY = self.view.height - MZL_TAB_BAR_HEIGHT;
    CGFloat visibleHeight = bottomVisibleY - topVisibleY;
    // 这里实际上是要将visibleHeight的高度映射到_mapPlaceHolder的高度，形成视差效果
    if (mapOriginInView.y <= bottomVisibleY && mapOriginInView.y >= topVisibleY) {
        CGFloat deviation = bottomVisibleY - mapOriginInView.y;
        // 再缩小一点范围，避免边缘看不到
        CGFloat mapMargin = 20.0;
        CGFloat mapHeight = _mapPlaceHolder.height - mapMargin * 2;
        CGFloat deviationInMap = round(deviation * mapHeight / visibleHeight);
        CGFloat mapCenterY = mapOriginInView.y + mapMargin + mapHeight - deviationInMap;
        [_map setCenter:CGPointMake(_map.centerX, mapCenterY)];
    } else {
        _map.frame = CGRectMake(0, 0, _map.width, _map.height);
    }
}

#define FLAG_TO_ART_BEGIN 1
#define FLAG_TO_ART_POSSIBLE 2
#define FLAG_TO_ART_CONFIRMED 3
#define TEXT_PULL_TO_ARTLIST @"上拉查看玩法列表"
#define TEXT_RELEASE_TO_ARTLIST @"释放显示玩法列表"

- (void)handleJumpToArtListOnScroll:(UIScrollView *)scrollView {
    if (_toLocArtFlag < FLAG_TO_ART_BEGIN) {
        return;
    }
    UILabel *lbl = (UILabel *)_toLocArtTipView.subviews[0];
    if ([scrollView co_isScrollToBottomWithOffset:60]) {
        lbl.text = TEXT_RELEASE_TO_ARTLIST;
        _toLocArtFlag = FLAG_TO_ART_CONFIRMED;
    } else {
        lbl.text = TEXT_PULL_TO_ARTLIST;
        _toLocArtFlag = FLAG_TO_ART_POSSIBLE;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_ignoreScroll) {
        return;
    }
    [self parallaxScroll:scrollView];
    [self parallaxMap:scrollView];
    [self handleJumpToArtListOnScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView co_isScrollToBottom]) {
        _toLocArtFlag = FLAG_TO_ART_BEGIN;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_toLocArtFlag == FLAG_TO_ART_CONFIRMED) {
        MZLLocationDetailViewController *parent = (MZLLocationDetailViewController *)self.parentViewController;
        [parent tabToSelectedIndex:MZL_LOCATION_DETAIL_ARTICLES_SECTION];
    }
    _toLocArtFlag = -1;
}

#pragma mark - map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString * const identifier = @"PinView";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (pinView) {
        pinView.annotation = annotation;
    } else {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    pinView.rightCalloutAccessoryView = [self navCalloutViewForAnnotation:annotation];
    pinView.canShowCallout = YES;
    return pinView;
}

@end
