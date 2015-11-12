//
//  MZLFilterSectionDistanceView.m
//  Test
//
//  Created by Whitman on 14-9-10.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterSectionDistanceView.h"
#import <IBMessageCenter.h>
#import <POPSpringAnimation.h>
#import "MZLModelFilterItem.h"
#import "UIView+COPopAdditions.h"
#import <Masonry/Masonry.h>

#define WIDTH_FILTER_DISTANCE 24.0
#define FILTER_DISTANCE_H_MARGIN 12.0
#define WIDTH_MZL_FILTER_SECTION_VIEW 260.0
#define MZL_FILTER_SECTION_VIEW_H_MARGIN 15.0
#define NOTI_FILTERSECTION_DISTANCE_TITLEVIEW_DID_LAYOUT @"NOTI_FILTERSECTION_DISTANCE_TITLEVIEW_DID_LAYOUT"
#define NOTI_DISTANCE_MODIFIED @"NOTI_FILTERSECTION_DISTANCE_CONTENTVIEW_DID_LAYOUT"


UIImageView *imageViewWithImageNamed(NSString *imageName) {
    UIImageView *result = [[UIImageView alloc] init];
    [result setFixedDesiredSize:CGSizeMake(WIDTH_FILTER_DISTANCE  , WIDTH_FILTER_DISTANCE)];
    result.image = [UIImage imageNamed:imageName];
    return result;
}


@interface MZLFilterSectionDistanceTitleView : MZLFilterView

@end

@implementation MZLFilterSectionDistanceTitleView

- (void)initInternal {
    [self setHStretches];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 由于layout自上而下，只有在这里进行拦截，重新调整所有label的位置
    [IBMessageCenter sendMessageNamed:NOTI_FILTERSECTION_DISTANCE_TITLEVIEW_DID_LAYOUT forSource:self];
}

@end

@interface MZLFilterSectionDistanceContentView : MZLFilterView <UIGestureRecognizerDelegate>
/** 绿色可拖动的圆点图 */
@property (nonatomic, weak) UIImageView *movableDistanceImage;
@property (nonatomic, weak) UIImageView *selectedDistanceImage;
@property (nonatomic, strong) NSArray *distanceImages;
/** 可拖动的最小centerX */
@property (nonatomic, assign) CGFloat minCenterX;
/** 可拖动的最大centerX */
@property (nonatomic, assign) CGFloat maxCenterX;

@end

@implementation MZLFilterSectionDistanceContentView

- (void)initInternal {
    UIImageView *movableDistanceImage = imageViewWithImageNamed(@"Filter_Round_Slider");
    [self addSubviewWithCustomLayout:movableDistanceImage];
    self.movableDistanceImage = movableDistanceImage;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.movableDistanceImage addGestureRecognizer:panGesture];
    self.movableDistanceImage.userInteractionEnabled = YES;
}

- (void)setDistanceImages:(NSArray *)distanceImages {
    _distanceImages = distanceImages;
    for (UIImageView *imageView in distanceImages) {
        [imageView addTapGestureRecognizer:self action:@selector(onImageTap:)];
    }
}

- (void)onImageTap:(UITapGestureRecognizer *)recognizer {
    UIImageView *distanceImageView = (UIImageView *)recognizer.view;
    CGPoint centerPoint = [self centerPosFromDistanceImage:distanceImageView];
    POPSpringAnimation *anim = [self.movableDistanceImage co_animateCenter:centerPoint];
    anim.delegate = self;
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    [self checkDistance];
}

- (void)onPan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self];
    CGFloat centerX = recognizer.view.center.x + translation.x;
    if (centerX < self.minCenterX) {
        centerX = self.minCenterX;
    } else if (centerX > self.maxCenterX) {
        centerX = self.maxCenterX;
    }
    CGPoint finalPosition = CGPointMake(centerX, recognizer.view.center.y);
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        float slideFactor = 0.2 * slideMult;
        // find closest distance image and set center
        UIImageView *target = self.distanceImages[0];
        CGFloat deviation = ABS((target.centerX - centerX));
        for (UIImageView *imageView in self.distanceImages) {
            CGFloat temp = ABS(imageView.centerX - centerX);
            if (temp < deviation) {
                deviation = temp;
                target = imageView;
            }
        }
        finalPosition.x = target.centerX;
        [UIView animateWithDuration:slideFactor * 2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPosition;
        } completion:^(BOOL finished) {
            [self checkDistance];
        }];
    } else {
        recognizer.view.center = finalPosition;
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    }
}

- (void)checkDistance {
    // 浮点型转为整型再做比较
    NSInteger movableCenterX = (NSInteger)self.movableDistanceImage.centerX;
    NSInteger selectedCenterX = (NSInteger)self.selectedDistanceImage.centerX;
    if (movableCenterX == selectedCenterX) {
        return;
    }
    // set new selected
    for (UIImageView *imageView in self.distanceImages) {
        selectedCenterX = (NSInteger)imageView.centerX;
        if (selectedCenterX == movableCenterX) {
            self.selectedDistanceImage = imageView;
            [self onDistanceModified];
            break;
        }
    }
}

- (void)onDistanceModified {
    // 此处send给FilterScrollView
    [IBMessageCenter sendMessageNamed:NOTI_DISTANCE_MODIFIED forSource:self];
}

- (CGPoint)centerPosFromDistanceImage:(UIView *)distanceImage {
    if (distanceImage) {
        return CGPointMake(distanceImage.centerX, self.movableDistanceImage.center.y);
    }
    return CGPointMake(((UIView *)self.distanceImages[0]).centerX , self.movableDistanceImage.center.y);
}

- (void)setSelectedDistanceItem:(MZLModelFilterItem *)selectedItem {
    for (UIImageView *distanceImage in self.distanceImages) {
        if (distanceImage.tag == selectedItem.identifier) {
            self.selectedDistanceImage = distanceImage;
            self.movableDistanceImage.center = [self centerPosFromDistanceImage:distanceImage];
            break;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self bringSubviewToFront:self.movableDistanceImage];
    if (self.distanceImages.count > 0) {
        self.minCenterX = ((UIView *)self.distanceImages[0]).centerX;
        self.maxCenterX = ((UIView *)self.distanceImages[self.distanceImages.count - 1]).centerX;
        // 没有设置selectedImage默认设为第一个(全部)
        if (! self.selectedDistanceImage) {
            self.selectedDistanceImage = self.distanceImages[0];
        }
        self.movableDistanceImage.center = [self centerPosFromDistanceImage:self.selectedDistanceImage];
    }
}

@end

@interface MZLFilterSectionDistanceView() {
    NSMutableArray *_distanceImages;
    NSMutableArray *_distanceTitles;
    @protected WeView *_bottom;
    __weak MZLFilterSectionDistanceContentView *_distanceContentView;
}

@end

@implementation MZLFilterSectionDistanceView

- (void)dealloc {
    [IBMessageCenter removeMessageListenersForTarget:self];
}

- (void)initInternal {
//    _top = [[WeView alloc] init];
    _bottom = [[WeView alloc] init];
    [self initBottomView];
    [[[self addSubviewsWithVerticalLayout:@[ _bottom]]
     setHAlign:H_ALIGN_LEFT]
     setTopMargin:32];
}
#pragma mark - protected

- (void)resetFilterOptions {
    // reset to 全部
    MZLModelFilterItem *firstItem = self.filterOptions.items[0];
    [self toggleSelectedLabel:firstItem.identifier];
    [_distanceContentView setSelectedDistanceItem:firstItem];
}

- (MZLModelFilterType *)selectedFilterOptions {
    MZLModelFilterType *result = [self.filterOptions copy];
    MZLModelFilterItem *item = [[MZLModelFilterItem alloc] init];
    item.identifier = _distanceContentView.selectedDistanceImage.tag;
    result.items = @[item];
    return result;
}

- (void)setSelectedFilterOptions:(MZLModelFilterType *)selectedFilterOptions {
    if (selectedFilterOptions.items.count == 0) {
        return;
    }
    MZLModelFilterItem *selectedItem = selectedFilterOptions.items[0];
    [self toggleSelectedLabel:selectedItem.identifier];
    [_distanceContentView setSelectedDistanceItem:selectedItem];
}

- (void)initBottomView {
    
    NSMutableArray *distanceTopTitles = [NSMutableArray array];
    NSMutableArray *distanceBottomTitles = [NSMutableArray array];
    NSMutableArray *distanceItems = [NSMutableArray array];
    NSInteger countOfItems = self.filterOptions.items.count;
    NSInteger connectWidth = (globalWindow().width - WIDTH_FILTER_DISTANCE * countOfItems - 2 * FILTER_DISTANCE_H_MARGIN) / (countOfItems - 1);
    if (connectWidth < 0) {
        connectWidth = 0;
    }
    _distanceImages = [NSMutableArray array];
    _distanceTitles = [NSMutableArray array];
    UIView *lastLine;
    for (int i = 1; i <= countOfItems; i ++) {
        MZLModelFilterItem *filterItem = self.filterOptions.items[i - 1];
        UIImageView *distanceImage;
        if (i == 1) {
            distanceImage = imageViewWithImageNamed(@"Filter_Distance_Left");
        } else if (i == countOfItems) {
            distanceImage = imageViewWithImageNamed(@"Filter_Distance_Right");
        } else {
            distanceImage = imageViewWithImageNamed(@"Filter_Distance_Center");
        }
        distanceImage.tag = filterItem.identifier;
        [_distanceImages addObject:distanceImage];
        [distanceItems addObject:distanceImage];
        
        // 距离之间的连线
        UIView *connectView = [[UIView alloc] init];
        if (i != countOfItems) {
            UIView *distanceLine = [self createViewWithParentView:self];
            distanceLine.backgroundColor = colorWithHexString(@"#B0B0B0");
            [distanceLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(75);
                if (lastLine) {
                    make.left.equalTo(lastLine.mas_right).offset(13);
                }else{
                    make.left.equalTo(self.mas_left).offset(30);
                }
                
                make.width.mas_offset(connectWidth+11);
                make.height.equalTo(@1);
            }];
            lastLine = distanceLine;
            
            connectView.backgroundColor = colorWithHexString(@"#B0B0B0");
            [connectView setFixedDesiredSize:CGSizeMake(connectWidth, 0.0)];
        }
        [distanceItems addObject:connectView];
        
        UILabel *distanceLbl = [[UILabel alloc] init];
        distanceLbl.tag = filterItem.identifier;
        distanceLbl.font = MZL_FONT(12.0);
        if (i % 2 == 1) {
            [distanceTopTitles addObject:distanceLbl];
        } else {
            [distanceBottomTitles addObject:distanceLbl];
        }
        distanceLbl.text = filterItem.displayName;
        [_distanceTitles addObject:distanceLbl];

    }
    MZLModelFilterItem *filterItem = self.filterOptions.items[0];
    [self toggleSelectedLabel:filterItem.identifier];
    
    MZLFilterSectionDistanceContentView *distanceContentView = [[MZLFilterSectionDistanceContentView alloc] init];
    _distanceContentView = distanceContentView;
    distanceContentView.distanceImages = _distanceImages;
    [[distanceContentView addSubviewsWithHorizontalLayout:distanceItems]
     setHSpacing:0];
    [IBMessageCenter addMessageListener:NOTI_DISTANCE_MODIFIED source:distanceContentView target:self action:@selector(onDistanceModified)];
    MZLFilterSectionDistanceTitleView *distanceTopTitleView = [[MZLFilterSectionDistanceTitleView alloc] init];
    [distanceTopTitleView addSubviewsWithHorizontalLayout:distanceTopTitles];
    [IBMessageCenter addMessageListener:NOTI_FILTERSECTION_DISTANCE_TITLEVIEW_DID_LAYOUT source:distanceTopTitleView target:self action:@selector(onTopTitleViewDidLayout)];
    MZLFilterSectionDistanceTitleView *distanceBottomTitleView = [[MZLFilterSectionDistanceTitleView alloc] init];
    [IBMessageCenter addMessageListener:NOTI_FILTERSECTION_DISTANCE_TITLEVIEW_DID_LAYOUT source:distanceTopTitleView target:self action:@selector(onBottomTitleViewDidLayout)];
    [distanceBottomTitleView addSubviewsWithHorizontalLayout:distanceBottomTitles];
    [[_bottom addSubviewsWithVerticalLayout:@[distanceTopTitleView, distanceContentView, distanceBottomTitleView]] setHMargin:FILTER_DISTANCE_H_MARGIN];
}

#pragma mark - title view layout

- (void)onTopTitleViewDidLayout {
    [self onTitleViewDidLayout:0];
}

- (void)onBottomTitleViewDidLayout {
    [self onTitleViewDidLayout:1];
}

- (void)onTitleViewDidLayout:(NSInteger)startIndex {
    for (NSUInteger i = startIndex; i < _distanceImages.count; i += 2) {
        UIImageView *imageView = _distanceImages[i];
        UILabel *lbl = _distanceTitles[i];
        lbl.center = CGPointMake(imageView.centerX, lbl.centerY);
    }
}

#pragma mark - distance modified

- (void)onDistanceModified {
    [self toggleSelectedLabel:_distanceContentView.selectedDistanceImage.tag];
    [IBMessageCenter sendMessageNamed:NOTI_FILTER_MODIFIED forSource:self];
}

- (void)toggleSelectedLabel:(NSInteger)selectedFilterItemId {
    for (UILabel *lbl in _distanceTitles) {
        if (lbl.tag == selectedFilterItemId) {
            lbl.textColor = MZL_COLOR_YELLOW_FDD414();
        } else {
            lbl.textColor = MZL_COLOR_GRAY_7F7F7F();
        }
    }
}

@end
