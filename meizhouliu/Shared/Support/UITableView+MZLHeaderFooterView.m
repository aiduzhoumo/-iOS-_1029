//
//  UITableView+MZLHeaderFooterView.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UITableView+MZLHeaderFooterView.h"
#import "WeView.h"
#import "UILabel+COAdditions.h"

#define SINGLE_LINE_HEIGHT 35.0

@implementation UITableView (MZLHeaderFooterView)

#pragma mark - basic refresh view

- (UIView *)refreshView {
    return [self refreshView:MZL_TABLEVIEW_FOOTER_REFRESH];
}

- (UIView *)refreshView:(NSString *)text {
    static CGFloat vwRefreshHeight = SINGLE_LINE_HEIGHT;
    
    WeView *result = [[WeView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, vwRefreshHeight)];
//    [result setBackgroundColor:[UIColor blueColor]];
    
    UILabel *lbl = [[UILabel alloc] init];
    [lbl setFont:MZL_FONT(MZL_TABLEVIEW_FOOTER_FONT_SIZE)];
    [lbl setTextColor:MZL_COLOR_BLACK_999999()];
    [lbl setText:text];
    lbl.minDesiredSize = [lbl textSizeForSingleLine];
    lbl.tag = TAG_REFRESHVIEW_LABEL;
    
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] init];
    [ai setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [ai setTag:TAG_REFRESHVIEW_ACTIVITYINDICATOR];
    [ai startAnimating];
    
    [[result addSubviewsWithHorizontalLayout:@[ai, lbl]]
     setHSpacing:3.0];
    
    return result;
}

//- (void)showFooterActivityIndicator {
//    [self toggleActivityIndicator:self.tableFooterView];
//}
//
//- (void)hideFooterActivityIndicator {
//    [self toggleActivityIndicator:self.tableFooterView];
//}
//
//- (void)toggleActivityIndicator:(UIView *)view {
//    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.tableFooterView viewWithTag:TAG_REFRESHVIEW_ACTIVITYINDICATOR];
//    if (indicator) {
//        if (indicator.hidden) {
//            [indicator startAnimating];
//        } else {
//            [indicator stopAnimating];
//        }
//    }
//}

#pragma mark - master detail label view 

- (UIView *)labelsView:(NSArray *)textsToDisplay {
    
    CGFloat vwHeight = textsToDisplay.count * SINGLE_LINE_HEIGHT;

    WeView *result = [[WeView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, vwHeight)];
    NSMutableArray *lbls = [NSMutableArray array];
    for (NSString *text in textsToDisplay) {
        UILabel *lbl = [[UILabel alloc] init];
        [lbl setFont:MZL_FONT(MZL_TABLEVIEW_FOOTER_FONT_SIZE)];
        [lbl setText:text];
        [lbl setTextColor:MZL_COLOR_BLACK_999999()];
        lbl.minDesiredSize = [lbl textSizeForSingleLine];
        [lbls addObject:lbl];
    }
    
    [[result addSubviewsWithVerticalLayout:lbls]
     setVSpacing:3];
    return result;

}

@end
