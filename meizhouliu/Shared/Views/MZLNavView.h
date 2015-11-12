//
//  MZLNavView.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-11-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MZLNavView_Center_ContainerSize @"containerSize"
#define MZLNavView_Center_ColumnCount @"columnCount"
#define MZLNavView_Center_HMargin @"hMargin"
#define MZLNavView_Center_RowSpacing @"rowSpacing"
#define MZLNavView_Center_ColumnSpacing @"columnSpacing"
#define MZLNavView_Center_OddColumnTopMargin @"oddColumnTopMargin"
#define MZLNavView_Center_EvenColumnTopMargin @"evenColumnTopMargin"

#define MZLNavView_Center_TAG_IMAGE 100
#define MZLNavView_Center_TAG_CHECKMARK_IMAGE 101
#define MZLNavView_Center_TAG_NAME_LABEL 102

@class MZLModelFilterType;

@protocol MZLNavViewDelegate <NSObject>

@optional
- (void)onNextStep:(id)sender;
- (void)onAnimationStart;
- (void)onAnimationEnd;

@end


@interface MZLNavView : UIView {
    @protected
    __weak UIView *_topView;
    __weak UIView *_centerView;
    __weak UIView *_bottomView;
    __weak UIView *_bottomContentView;
    NSMutableArray *_imageContainers;
    __weak UILabel *_titleLbl;
    BOOL _isAnimated;
}

/** public methods */
- (void)showSubviewsAnimatedIfNecessary;
- (void)hideSubviews;
- (void)disappearAnimated;
- (MZLModelFilterType *)filterTypeWithSelectedOptions;

/** helper methods */
- (UIView *)createViewWithParentView:(UIView *)parent;
- (UIImageView *)createImageViewWithParentView:(UIView *)parent;
- (UILabel *)createLabelWithParentView:(UIView *)parent;
- (id)createView:(Class)viewClass parent:(UIView *)parent;

/** background view */
- (void)initBackground;
- (NSString *)bgImageName;

/** top view */
- (NSString *)titleStr;

/** center view */
- (NSMutableDictionary *)centerViewLayoutParams;
- (NSArray *)imageNames;
- (NSArray *)tagForImages;
- (NSArray *)lblNames;
- (NSArray *)umengEvents;
- (void)onImageContainerClicked:(UIGestureRecognizer *)sender;
- (CGSize)imageViewSize;

/** bottom view */
/** 标识是引导步骤的第几步,第一页为0 */
- (NSInteger)pageIndex;
- (NSString *)despStr;
- (NSString *)nextBtnStr;
- (void)onNextBtnClicked:(UIButton *)sender;

/** selected filter options */
- (MZLModelFilterType *)filterType;
- (NSArray *)selectedFilterOptions;

/** animation */
- (NSArray *)imageSequenceInAnimation;
- (void)showImagesAnimated;

@property (nonatomic, assign) id<MZLNavViewDelegate> delegate;

@end
