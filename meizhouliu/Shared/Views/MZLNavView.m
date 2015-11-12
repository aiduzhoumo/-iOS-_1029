//
//  MZLNavView.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-11-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLNavView.h"
#import <Masonry/Masonry.h>
#import "UIImage+COAdditions.h"
//#import "UIView+COAdditions.h"
#import "MZLModelFilterType.h"
#import "MZLModelFilterItem.h"
//#import "MZLFilterScrollView.h"
#import "MZLFilterContentView.h"
#import "MZLFilterBar.h"
#import "MobClick.h"

#define HEIGHT_TOP_VIEW 60
#define HEIGHT_CENTER_VIEW 330

@interface MZLNavView () {
}

@end

@implementation MZLNavView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInit];
    }
    return self;
}

- (void)internalInit {
    [self initBackground];
    [self initTopView];
    [self initCenterView];
    [self initBottomView];
}

- (void)initBackground {
//    UIImageView *bgImage = [self createImageViewWithParentView:self];
//    bgImage.image = [UIImage imageNamed:[self bgImageName]];
//    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self);
//    }];
}

- (void)initTopView {
    UIView *topView = [self createViewWithParentView:self];
    _topView = topView;
//    topView.backgroundColor = [UIColor greenColor];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_equalTo(self);
        make.height.mas_equalTo(HEIGHT_TOP_VIEW);
    }];
    UILabel *titleLbl = [self createLabelWithParentView:topView];
    _titleLbl = titleLbl;
    titleLbl.font = MZL_BOLD_FONT(24);
    titleLbl.textColor = colorWithHexString(@"ea7f00");
    titleLbl.text = [self titleStr];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topView);
        make.centerY.mas_equalTo(topView);
    }];
    
}

- (void)initCenterView {
    UIView *centerView = [self createViewWithParentView:self];
    _centerView = centerView;
//    centerView.backgroundColor = [UIColor purpleColor];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_topView.mas_bottom);
        make.height.mas_equalTo(HEIGHT_CENTER_VIEW);
        make.width.mas_equalTo(MZL_BASE_SCREEN_WIDTH);
        make.centerX.mas_equalTo(centerView.superview);
    }];
    [self initImageContainerViews:centerView];
}

- (void)initBottomView {
    UIView *bottomView = [self createViewWithParentView:self];
    _bottomView = bottomView;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_centerView.mas_bottom);
        make.bottom.mas_equalTo(self);
    }];
    CGFloat bottomContentWidth = 180;
    UIView *bottomContentView = [self createViewWithParentView:bottomView];
    _bottomContentView = bottomContentView;
//    bottomContentView.backgroundColor = [UIColor blueColor];
    [bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomView);
        make.centerY.mas_equalTo(bottomView);
        make.size.mas_equalTo(CGSizeMake(bottomContentWidth, 80));
    }];
    UILabel *despLbl = [self createDespLabel:bottomContentView];
    [despLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomContentView);
        make.top.mas_equalTo(bottomContentView);
    }];
    UIView *indicatorContainerView = [self createIndicatorContainerView:bottomContentView];
    [indicatorContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomContentView);
        make.top.mas_equalTo(despLbl.mas_bottom).offset(9);
        make.size.mas_equalTo(CGSizeMake(bottomContentWidth, 6));
    }];
    UIButton *btn = [self createNextBtn:bottomContentView];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomContentView);
        make.top.mas_equalTo(indicatorContainerView.mas_bottom).offset(9);
        make.size.mas_equalTo(CGSizeMake(bottomContentWidth, 36));
    }];
    
}

#pragma mark - bottom view

- (UILabel *)createDespLabel:(UIView *)parent {
    UILabel *lbl = [self createLabelWithParentView:parent];
    lbl.font = MZL_FONT(12.0);
    lbl.numberOfLines = 1;
    lbl.textColor = [UIColor whiteColor];
    lbl.text = [self despStr];
    return lbl;
}

- (UIButton *)createNextBtn:(UIView *)parent {
    UIButton *btn = [self createView:[UIButton class] parent:parent];
    [btn setTitle:[self nextBtnStr] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.layer setCornerRadius:5.0];
    [btn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [btn.layer setBorderWidth:1.0];
    [btn addTarget:self action:@selector(onNextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIView *)createIndicatorContainerView:(UIView *)parent {
    UIView *indicatorContainerView = [self createViewWithParentView:parent];
//    indicatorContainerView.backgroundColor = [UIColor whiteColor];
    NSMutableArray *indicators = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        UIView *view = [self createViewWithParentView:indicatorContainerView];
        view.backgroundColor = colorWithHexString(@"#ea7f00");
        CGFloat indicatorWidth = 6.0;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(indicatorWidth, indicatorWidth));
        }];
        [view co_toRoundShapeWithDiameter:indicatorWidth];
        [indicators addObject:view];
    }
    [indicators[[self pageIndex]] setBackgroundColor:[UIColor whiteColor]];
    
    [indicators[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(indicatorContainerView);
    }];
    CGFloat offset = 8.0;
    [indicators[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([indicators[1] mas_left]).offset(-offset);
        make.centerY.mas_equalTo(indicatorContainerView);
    }];
    [indicators[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([indicators[1] mas_right]).offset(offset);
        make.centerY.mas_equalTo(indicatorContainerView);
    }];
    return indicatorContainerView;
}

#pragma mark - center view

#define HEIGHT_CENTER_LABEL 20

- (void)animateOnViewZoom:(UIView *)view {
    UIGestureRecognizer *gestureRecognizer;
    if (view.superview.gestureRecognizers.count > 0) {
        gestureRecognizer = view.superview.gestureRecognizers[0];
    }
    gestureRecognizer.enabled = NO;
    CGSize imageOriginalSize = view.bounds.size;
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imageOriginalSize.width * 1.2, imageOriginalSize.height * 1.2));
    }];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear  animations:^{
        [view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(imageOriginalSize);
        }];
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear  animations:^{
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            gestureRecognizer.enabled = YES;
        }];
    }];
}

- (void)onImageContainerClicked:(UIGestureRecognizer *)sender {
    UIView *view = sender.view;
    UIView *checkmarkImage = [view viewWithTag:MZLNavView_Center_TAG_CHECKMARK_IMAGE];
    checkmarkImage.hidden = !checkmarkImage.hidden;
    UIView *image = [view viewWithTag:MZLNavView_Center_TAG_IMAGE];
    [MobClick event:[sender.view getProperty:MZL_KEY_UMENT_EVENT]];
    [self animateOnViewZoom:image];
}

- (CGSize)imageViewSize {
    CGSize containerSize = [[self centerViewLayoutParams][MZLNavView_Center_ContainerSize] CGSizeValue];
    return CGSizeMake(containerSize.width, containerSize.height - HEIGHT_CENTER_LABEL);
}

- (void)initImageContainerViews:(UIView *)parent {
    NSArray *imageNames = [self imageNames];
    NSArray *lblNames = [self lblNames];
    NSArray *umengEvents = [self umengEvents];
    NSDictionary *paramDict = [self centerViewLayoutParams];
    CGSize containerSize = [paramDict[MZLNavView_Center_ContainerSize] CGSizeValue];
    CGFloat containerWidth = containerSize.width;
    CGFloat containerHeight = containerSize.height;
    CGFloat lblHeight = HEIGHT_CENTER_LABEL;
    CGFloat imageHeight = containerSize.height - lblHeight;
    NSInteger imageCount = imageNames.count;
    NSInteger columnCount = [paramDict[MZLNavView_Center_ColumnCount] integerValue];
    NSInteger rowCount = imageCount / columnCount;
    CGFloat hMargin = [paramDict[MZLNavView_Center_HMargin] floatValue];
    CGFloat rowSpacing = [paramDict[MZLNavView_Center_RowSpacing] floatValue];
    CGFloat columnSpacing = [paramDict[MZLNavView_Center_ColumnSpacing] floatValue];
    CGFloat oddColumnTopMargin = [paramDict[MZLNavView_Center_OddColumnTopMargin] floatValue];
    CGFloat evenColumnTopMargin = [paramDict[MZLNavView_Center_EvenColumnTopMargin] floatValue];
    NSInteger imageIndex = -1;
    _imageContainers = [NSMutableArray array];
    for (int row = 0; row < rowCount; row ++) {
        for (int column = 0; column < columnCount; column++) {
            imageIndex ++;
            UIView *imageContainer = [self createViewWithParentView:parent];
            [imageContainer setProperty:MZL_KEY_UMENT_EVENT value:umengEvents[imageIndex]];
            [_imageContainers addObject:imageContainer];
            [imageContainer addTapGestureRecognizer:self action:@selector(onImageContainerClicked:)];
//            imageContainer.backgroundColor = [UIColor brownColor];
            [imageContainer mas_makeConstraints:^(MASConstraintMaker *make) {
                CGFloat top = row * (containerHeight + rowSpacing);
                if ((column + 1) % 2 == 1) {
                    top += oddColumnTopMargin;
                } else {
                    top += evenColumnTopMargin;
                }
                make.top.mas_equalTo(parent).offset(top);
                CGFloat centerXFromParentLeft = hMargin + column * (containerWidth + columnSpacing) + containerWidth / 2.0;
                make.centerX.mas_equalTo(parent.mas_left).offset(centerXFromParentLeft);
                make.size.mas_equalTo(containerSize);
            }];
            UILabel *nameLbl = [self nameLabelInParentView:imageContainer];
            nameLbl.text = lblNames[imageIndex];
            UIImageView *imageView = [self imageInParentView:imageContainer];
//            imageView.backgroundColor = [UIColor orangeColor];
            imageView.image = [UIImage imageNamed:imageNames[imageIndex]];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(containerWidth, imageHeight));
                make.centerX.mas_equalTo(imageContainer);
                make.centerY.mas_equalTo(imageContainer.mas_top).offset(imageHeight / 2.0);
            }];
            [self checkmarkImageInParentView:imageContainer];
        }
    }
}

- (UIImageView *)imageInParentView:(UIView *)parentView {
    UIImageView *imageView = [self createImageViewWithParentView:parentView];
    imageView.tag = MZLNavView_Center_TAG_IMAGE;
    return imageView;
}

- (UIImageView *)checkmarkImageInParentView:(UIView *)parentView {
    UIImageView *checkmarkImage = [self createImageViewWithParentView:parentView];
    checkmarkImage.image = [UIImage imageNamed:@"nav_check"];
    [checkmarkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.right.mas_equalTo(parentView);
        make.bottom.mas_equalTo(parentView).offset(-1 * HEIGHT_CENTER_LABEL);
    }];
    checkmarkImage.tag = MZLNavView_Center_TAG_CHECKMARK_IMAGE;
    checkmarkImage.hidden = YES;
    return checkmarkImage;
}

- (UILabel *)nameLabelInParentView:(UIView *)parentView {
    UILabel *lbl = [self createLabelWithParentView:parentView];
    lbl.font = MZL_FONT(15);
    lbl.tag = MZLNavView_Center_TAG_NAME_LABEL;
    lbl.textColor = colorWithHexString(@"ea7f00");
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(parentView);
        make.centerX.mas_equalTo(parentView);
    }];
    return lbl;
}

#pragma mark - protected background, for override

- (NSString *)bgImageName {
    return @"nav_bg_1";
}

#pragma mark - protected top view, for override

- (NSString *)titleStr {
    return @"";
}

#pragma mark - protected center view, for override

- (NSMutableDictionary *)centerViewLayoutParams {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[MZLNavView_Center_ColumnCount] = @2;
    paramDict[MZLNavView_Center_HMargin] = @16;
    paramDict[MZLNavView_Center_OddColumnTopMargin] = @0;
    paramDict[MZLNavView_Center_EvenColumnTopMargin] = @0;
    return paramDict;
}

/** filter identifier to set on image tag */
- (NSArray *)tagForImages {
    return nil;
}

- (NSArray *)imageNames {
    return nil;
}

- (NSArray *)lblNames {
    return nil;
}

- (NSArray *)umengEvents {
    return nil;
}

#pragma mark - protected bottom view, for override

- (NSInteger)pageIndex {
    return -1;
}

- (NSString *)despStr {
    return @"还有更多选择在app里面噢";
}

- (NSString *)nextBtnStr {
    return @"下一步";
}

- (void)onNextBtnClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onNextStep:)]) {
        [self.delegate onNextStep:sender];
    }
}

#pragma mark - protected animation, for override

- (NSArray *)imageSequenceInAnimation {
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < _imageContainers.count; i ++) {
        [result addObject:@(i)];
    }
    return [NSArray arrayWithArray:result];
}

#pragma mark - animation

- (void)hideSubviews {
    for (UIView *container in _imageContainers) {
        for (UIView *view in container.subviews) {
            if (view.tag == MZLNavView_Center_TAG_IMAGE) {
                [view mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
            } else {
                view.alpha = 0;
            }
        }
    }
    [_titleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_topView).offset(self.width);
    }];
    [_bottomContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomView).offset(self.height - HEIGHT_TOP_VIEW - HEIGHT_CENTER_VIEW);
    }];
    [self layoutIfNeeded];
}

- (void)showTitleLblAnimated {
    [_titleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_topView);
    }];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear  animations:^{
        [_titleLbl layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self showImagesAnimated];
    }];
}

- (void)showImagesAnimated {
    CGFloat delay = 0;
    NSArray *imageSequenceInAnimation = [self imageSequenceInAnimation];
    for (int i = 0; i < imageSequenceInAnimation.count; i ++) {
        NSInteger index = [imageSequenceInAnimation[i] integerValue];
        UIView *container = _imageContainers[index];
        UIView *image = [container viewWithTag:MZLNavView_Center_TAG_IMAGE];
        image.hidden = NO;
        [image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo([self imageViewSize]);
        }];
        [UIView animateWithDuration:0.25 delay:delay usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
            [image layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (i >= imageSequenceInAnimation.count - 1) {
                [self showLblNamesAndCheckmarkAnimated];
                [self showBottomViewAnimated];
            }
        }];
        delay += 0.2;
    }
}

- (void)showLblNamesAndCheckmarkAnimated {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        for (UIView *container in _imageContainers) {
            for (UIView *view in container.subviews) {
                if (view.tag != MZLNavView_Center_TAG_IMAGE) {
                    view.alpha = 1;
                }
            }
        }
    } completion:^(BOOL finished) {
//        [self showBottomViewAnimated];
    }];
}

- (void)showBottomViewAnimated {
    [_bottomContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomView);
    }];
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(onAnimationEnd)]) {
            [self.delegate onAnimationEnd];
        }
    }];
}

#pragma mark - helper methods

- (UIView *)createViewWithParentView:(UIView *)parent {
    return [self createView:[UIView class] parent:parent];
}

- (UIImageView *)createImageViewWithParentView:(UIView *)parent {
    return [self createView:[UIImageView class] parent:parent];
}

- (UILabel *)createLabelWithParentView:(UIView *)parent {
    return [self createView:[UILabel class] parent:parent];
}

- (id)createView:(Class)viewClass parent:(UIView *)parent {
    id view = [[viewClass alloc] init];
    [parent addSubview:view];
    return view;
}

#pragma mark - public methods

- (void)showSubviewsAnimatedIfNecessary {
    if (! _isAnimated) {
        self.userInteractionEnabled = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(onAnimationStart)]) {
            [self.delegate onAnimationStart];
        }
        [self hideSubviews];
        [self showTitleLblAnimated];
        _isAnimated = YES;
    }
}

- (void)animateOnFilterBar {
    UIWindow *window = globalWindow();
    MZLFilterContentView *filterScroll;
    MZLFilterBar *filterBar;
    for (UIView *view in window.subviews) {
        if ([view isMemberOfClass:[MZLFilterContentView class]]) {
            filterScroll = (MZLFilterContentView *)view;
            for (UIView *subview in view.subviews) {
                if ([subview isMemberOfClass:[MZLFilterBar class]]) {
                    filterBar = (MZLFilterBar *)subview;
                    break;
                }
            }
            break;
        }
    }
    if (filterBar) {
        CGFloat alphaOriginalValue = filterBar.alpha;
        filterScroll.userInteractionEnabled = NO;
        [UIView animateWithDuration:.7 animations:^{
            filterBar.alpha = 1.0;
            filterBar.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.1);
        } completion:^(BOOL finished) {
//            [filterBar toggleFilterImage:YES];
            [UIView animateWithDuration:.7 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                filterBar.alpha = alphaOriginalValue;
                filterBar.layer.transform = CATransform3DMakeScale(1, 1, 1);
            } completion:^(BOOL finished) {
//                [filterBar toggleFilterImage:NO];
                filterScroll.userInteractionEnabled = YES;
            }];
        }];
    }
}

- (void)disappearAnimated {
//    UIView *view = [self.window snapshotViewAfterScreenUpdates:YES];
    UIImage *image = [UIImage windowScreenshot];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    view.image = image;
    [self.window addSubview:view];
    
    // gradually grow small to the right center
    [UIView animateWithDuration:1.5 animations:^{
        view.frame = CGRectMake(self.window.bounds.size.width - 15.0, self.window.bounds.size.height / 2.0, 0, 0);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        [self animateOnFilterBar];
    }];
    
//    // ease out
//    [UIView animateWithDuration:1.5 animations:^{
//        view.layer.opacity = 0;
//        view.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
//    } completion:^(BOOL finished) {
//        [view removeFromSuperview];
//    }];
//    
//    // to center and then to the right center
//    [UIView animateWithDuration:.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        view.frame = CGRectMake(0, self.window.bounds.size.height / 2.0, self.window.bounds.size.width, 3);
//    } completion:^(BOOL finished) {
//        if ([view isKindOfClass:[UIImageView class]]) {
//            ((UIImageView *)view).image = nil;
//        }
//        view.backgroundColor = [UIColor whiteColor];
//        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            view.frame = CGRectMake(self.window.bounds.size.width, self.window.bounds.size.height / 2.0, 0, 0);
//        } completion:^(BOOL finished) {
//            [view removeFromSuperview];
//        }];
//    }];
}

- (MZLModelFilterType *)filterTypeWithSelectedOptions {
    MZLModelFilterType *filterType = [self filterType];
    filterType.items = [self selectedFilterOptions];
    if (filterType.items.count == 0) {
        return nil;
    }
    return filterType;
}

#pragma mark - selected filter options

- (MZLModelFilterType *)filterType {
    return nil;
}

- (NSArray *)selectedFilterOptions {
    NSArray *imageTags = [self tagForImages];
    NSArray *lblNames = [self lblNames];
    NSMutableArray *selected = [NSMutableArray array];
    NSInteger index = -1;
    for (UIView *container in _imageContainers) {
        index ++;
        UIView *checkmark = [container viewWithTag:MZLNavView_Center_TAG_CHECKMARK_IMAGE];
        if (! checkmark.hidden) {
            MZLModelFilterItem *selectedItem = [[MZLModelFilterItem alloc] init];
            selectedItem.identifier = [imageTags[index] integerValue];
            selectedItem.displayName = lblNames[index];
            [selected addObject:selectedItem];
        }
    }
    return selected;
}

@end
